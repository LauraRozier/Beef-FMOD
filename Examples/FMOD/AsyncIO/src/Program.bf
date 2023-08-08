namespace AsyncIO;

using Beef_FMOD;
using Common;
using System;
using System.Collections;

struct AsyncData
{
    public FMOD.ASYNCREADINFO* info;
}

class ScopedMutex
{
    Common_Mutex mMutex;

    public this(ref Common_Mutex mutex)
	{
		mMutex = mutex;
		Common_Mutex_Enter(mMutex);
	}

    public ~this()
	{
		Common_Mutex_Leave(mMutex);
	}
}

static class Program
{
	static Common_Mutex gListCrit = .();
	static Common_Mutex gLineCrit = .();
	static List<AsyncData*> gList = new .() ~ delete _;
	static bool gThreadQuit = false;
	static bool gThreadFinished = false;
	static bool gSleepBreak = false;

	/*
	    A little text buffer to allow a scrolling window
	*/
	const int DRAW_ROWS = NUM_ROWS - 8;
	const int DRAW_COLS = NUM_COLUMNS;

	static String[DRAW_ROWS] gLineData = .(
		new String(), new String(), new String(), new String(), new String(), new String(),
		new String(), new String(), new String(), new String(), new String(), new String(),
		new String(), new String(), new String(), new String(), new String()
	) ~ for (var line in _) delete line;

	public static int32 Main(String[] Args)
	{
		Common_Start();
    	void* extraDriverData = null;
	    void* threadhandle    = null;
	
	    Common_Mutex_Create(ref gLineCrit);
	    Common_Mutex_Create(ref gListCrit);
	    Common_Thread_Create(=> ProcessQueue, null, out threadhandle);

		/*
		    Create a System object and initialize.
		*/
		FMOD.System system = .(null);
		ERRCHECK!(FMOD.Factory.System_Create(out system));

		ERRCHECK!(system.Init(1, .NORMAL, extraDriverData));
		ERRCHECK!(system.SetStreamBufferSize(32768, .RAWBYTES));
		ERRCHECK!(system.SetFileSystem(=> myopen, => myclose, => myread, => myseek, => myasyncread, => myasynccancel, 2048));

		FMOD.Sound sound = .(null);
		String waveFile = scope .();
		Common_MediaPath("wave.mp3\0", waveFile);
		ERRCHECK!(system.CreateStream(waveFile, .LOOP_NORMAL | ._2D | .IGNORETAGS, out sound));

		FMOD.Channel channel = .(null);
		ERRCHECK!(system.PlaySound(sound, .(null), false, out channel));
		
		String btnQuitText = new .();
		Common_BtnStr(.BTN_QUIT, btnQuitText);
		String btnAct1Text = new .();
		Common_BtnStr(.BTN_ACTION1, btnAct1Text);

		repeat
		{
        	Common_Update();

			if (sound.HasHandle())
			{
			    bool starving = false;
			    FMOD.OPENSTATE openstate = .READY;
			    ERRCHECK!(sound.GetOpenState(out openstate, var _, out starving, var _b));

			    if (starving)
			        AddLine("Starving");

			    ERRCHECK!(channel.SetMute(starving));
			}

			if (Common_BtnDown(.BTN_ACTION1))
			{
			    if (sound.Release() == .OK)
			    {
			        sound.ClearHandle();
			        AddLine("Released sound");
			    }
			}

		    ERRCHECK!(system.Update());

		    Common_Draw("==================================================");
		    Common_Draw("Async IO Example.");
		    Common_Draw("Copyright (c) Firelight Technologies 2004-2023.");
		    Common_Draw("==================================================");
		    Common_Draw("");
		    Common_Draw("Press {0} to release playing stream", btnAct1Text);
		    Common_Draw("Press {0} to quit", btnQuitText);
		    Common_Draw("");
		    DrawLines();
		    Common_Sleep(50);
		} while (!Common_BtnDown(.BTN_QUIT));

		/*
		    Shut down
		*/
		if (sound.HasHandle())
		    ERRCHECK!(sound.Release());

		ERRCHECK!(system.Close());
		ERRCHECK!(system.Release());

		gThreadQuit = true;

		while (!gThreadFinished)
		    Common_Sleep(10);

		Common_Mutex_Destroy(gListCrit);
		Common_Mutex_Destroy(gLineCrit);
		Common_Thread_Destroy(threadhandle);
		Common_Close();
		delete btnQuitText;
		delete btnAct1Text;
		return 0;
	}

	static void AddLine(StringView format, params Span<Object> args)
	{
	    ScopedMutex mutex = scope .(ref gLineCrit);

	    String s = scope .(DRAW_COLS);
		s.AppendF(format, params args);

	    for (int i = 1; i < DRAW_ROWS; i++)
			gLineData[i - 1].Set(gLineData[i]);

		gLineData[DRAW_ROWS - 1].Set(s);
	}

	static void DrawLines()
	{
	    ScopedMutex mutex = scope .(ref gLineCrit);

	    for (int i = 0; i < DRAW_ROWS; i++)
	        Common_Draw(gLineData[i]);
	}

	/*
	    File callbacks
	*/
	static FMOD.RESULT myopen(char8* name, out uint32 fileSize, out void* handle, void* userData)
	{
	    Runtime.Assert(name != null);
		String str = scope .();
		str.Append(name);
		str.EnsureNullTerminator();
	    Common_File_Open(str, 0, out fileSize, out handle); // mode 0 = 'read'.

	    if (handle != null)
	        return .ERR_FILE_NOTFOUND;

	    return .OK;
	}

	static FMOD.RESULT myclose(void* handle, void* userdata)
	{
		if (handle == null)
			return .OK;

	    Common_File_Close(handle);
	    return .OK;
	}

	static FMOD.RESULT myread(void* handle, void* buffer, uint32 sizebytes, out uint32 bytesread, void* userdata)
	{
	    Runtime.Assert(handle != null);
	    Runtime.Assert(buffer != null);
	    Common_File_Read(handle, buffer, sizebytes, out bytesread);

	    if (bytesread < sizebytes)
	        return .ERR_FILE_EOF;

	    return .OK;
	}

	static FMOD.RESULT myseek(void* handle, uint32 pos, void* userdata)
	{
	    Runtime.Assert(handle != null);
	    Common_File_Seek(handle, pos);
	    return .OK;
	}

	static FMOD.RESULT myasyncread(FMOD.ASYNCREADINFO* info, void* userdata)
	{
	    Runtime.Assert(info != null);
	    ScopedMutex mutex = scope .(ref gListCrit);
	    AsyncData* data = (AsyncData*)Internal.Malloc(sizeof(AsyncData));

	    if (data == null)
	    {
	        /* Signal FMOD to wake up, this operation has has failed */
	        info.Done(info, .ERR_MEMORY);
	        return .ERR_MEMORY;
	    }

	    AddLine("REQUEST {0:N5} bytes, offset {1:N5} PRIORITY = {2:N5}.", info.SizeBytes, info.Offset, info.Priority);
	    data.info = info;
	    gList.Add(data);

	    /* Example only: Use your native filesystem scheduler / priority here */
	    if (info.Priority > 50)
	        gSleepBreak = true;

	    return .OK;
	}

	static FMOD.RESULT myasynccancel(FMOD.ASYNCREADINFO* info, void* userdata)
	{
	    Runtime.Assert(info != null);
	    ScopedMutex mutex = scope .(ref gListCrit);

	    /* Find the pending IO request and remove it */
	    for (var item in gList)
	    {
	        AsyncData* data = item;

	        if (data.info == info)
	        {
	            gList.Remove(data);
	            Internal.Free(data);

	            /* Signal FMOD to wake up, this operation has been cancelled */
	            info.Done(info, .ERR_FILE_DISKEJECTED);
	            return .ERR_FILE_DISKEJECTED;
	        }
	    }

	    /* IO request not found, it must have completed already */
	    return .OK;
	}

	/*
	    Async file IO processing thread
	*/
	static void ProcessQueue(void* param)
	{
	    while (!gThreadQuit)
	    {
	        /* Grab the next IO task off the list */
			AsyncData* data = null;
	        Common_Mutex_Enter(gListCrit);

	        if (!gList.IsEmpty)
	        {
	            data = gList.Front;
	            gList.RemoveAt(0);
	        }

	        Common_Mutex_Leave(gListCrit);

	        if (data != null && data.info != null)
	        {
	            /* Example only: Let's deprive the read of the whole block, only give 16kb at a time to make it re-ask for more later */
	            uint32 toread = data.info.SizeBytes;

	            if (toread > 16384)
	                toread = 16384;

	            /* Example only: Demonstration of priority influencing turnaround time */
	            for (int32 i = 0; i < 50; i++)
	            {
	                Common_Sleep(10);

	                if (gSleepBreak)
	                {
	                    AddLine("URGENT REQUEST - reading now!");
	                    gSleepBreak = false;
	                    break;
	                }
	            }

	            /* Process the seek and read request with EOF handling */
	            Common_File_Seek(data.info.Handle, data.info.Offset);
	            Common_File_Read(data.info.Handle, data.info.Buffer, toread, out data.info.BytesRead);

	            if (data.info.BytesRead < toread)
	            {
	                AddLine("FED     {0:N5} bytes, offset {1:N5} (* EOF)", data.info.BytesRead, data.info.Offset);
	                data.info.Done(data.info, .ERR_FILE_EOF);
	            }
	            else
	            {
	                AddLine("FED     {0:N5} bytes, offset {1:N5}", data.info.BytesRead, data.info.Offset);
	                data.info.Done(data.info, .OK);
	            }
	        }
	        else
	        {
	            Common_Sleep(10); /* Example only: Use your native filesystem synchronisation to wait for more requests */
	        }

			if (data != null)
				Internal.Free(data);
	    }
		
	    gThreadFinished = true;
	}
}