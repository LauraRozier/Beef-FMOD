namespace MusicCallbacks;

using Beef_FMOD;
using Common;
using System;
using System.Collections;

static class Program
{
	const int MAX_ENTRIES = 6;

	struct CallbackInfo
	{
	    public List<String> mEntries = new .();
	}

	static int Main(String[] Args)
	{
		Common_Start();
    	void* extraDriverData = null;
	    CallbackInfo info = .();

		FMOD_STUDIO.System system = .(null);
		ERRCHECK!(FMOD_STUDIO.System.Create(out system));

		// The example Studio project is authored for 5.1 sound, so set up the system output mode to match
		FMOD.System coreSystem = .(null);
		ERRCHECK!(system.GetCoreSystem(out coreSystem));
		ERRCHECK!(coreSystem.SetSoftwareFormat(0, ._5POINT1, 0));

		ERRCHECK!(system.Initialize(1024, .NORMAL, .NORMAL, extraDriverData));

		String bankFileMaster = scope .();
		FMOD_STUDIO.Bank masterBank = .(null);
		Common_MediaPath("Master.bank", bankFileMaster);
		ERRCHECK!(system.LoadBankFile(bankFileMaster, .NORMAL, out masterBank));

		String bankFileMasterStr = scope .();
		FMOD_STUDIO.Bank stringsBank = .(null);
		Common_MediaPath("Master.strings.bank", bankFileMasterStr);
		ERRCHECK!(system.LoadBankFile(bankFileMasterStr, .NORMAL, out stringsBank));

		String bankFileMusic = scope .();
		FMOD_STUDIO.Bank musicBank = .(null);
		Common_MediaPath("Music.bank", bankFileMusic);
		FMOD.RESULT result = system.LoadBankFile(bankFileMusic, .NORMAL, out musicBank);

		if (result != .OK) // Music bank is not exported by default, you will have to export from the tool first
		    Common_Fatal("Please export music.bank from the Studio tool to run this example");

		FMOD_STUDIO.EventDescription eventDescription = .(null);
		ERRCHECK!(system.GetEvent("event:/Music/Level 01", out eventDescription));

		FMOD_STUDIO.EventInstance eventInstance = .(null);
		ERRCHECK!(eventDescription.CreateInstance(out eventInstance));

		ERRCHECK!(eventInstance.SetUserData(&info));
		ERRCHECK!(eventInstance.SetCallback(=> markerCallback, .TIMELINE_MARKER | .TIMELINE_BEAT | .SOUND_PLAYED | .SOUND_STOPPED));
		ERRCHECK!(eventInstance.Start());

		FMOD_STUDIO.PARAMETER_DESCRIPTION parameterDescription;
		ERRCHECK!(eventDescription.GetParameterDescriptionByName("Progression", out parameterDescription));

		FMOD_STUDIO.PARAMETER_ID progressionID = parameterDescription.Id;

		float progression = 0.0f;
		ERRCHECK!(eventInstance.SetParameterByID(progressionID, progression));

		String btnMoreText = scope .();
		Common_BtnStr(.BTN_MORE, btnMoreText);
		String btnQuitText = scope .();
		Common_BtnStr(.BTN_QUIT, btnQuitText);

		repeat
		{
	        Common_Update();
	
	        if (Common_BtnDown(.BTN_MORE))
	        {
	            progression = (progression == 0.0f ? 1.0f : 0.0f);
	            ERRCHECK!(eventInstance.SetParameterByID(progressionID, progression));
	        }
	
	        ERRCHECK!(system.Update());
	
	        int32 position;
	        ERRCHECK!(eventInstance.GetTimelinePosition(out position) );
	
	        Common_Draw("==================================================");
	        Common_Draw("Music Callback Example.");
	        Common_Draw("Copyright (c) Firelight Technologies 2012-2023.");
	        Common_Draw("==================================================");
	        Common_Draw("");
	        Common_Draw("Timeline = {0}", position);
	        Common_Draw("");

	        for (int32 i = 0; i < info.mEntries.Count; i++)
	            Common_Draw("  {0}\n", info.mEntries[i]);

	        Common_Draw("");
	        Common_Draw("Press {0} to toggle progression (currently {1})", btnMoreText, progression);
	        Common_Draw("Press {0} to quit", btnQuitText);
	
	        Common_Sleep(50);
		} while (!Common_BtnDown(.BTN_QUIT));

		ERRCHECK!(system.Release());

		Common_Close();
		DeleteContainerAndItems!(info.mEntries);
		return 0;
	}

	// Obtain a lock and add a string entry to our list
	static void markerAddString(CallbackInfo* info, StringView format, params Span<Object> args)
	{
		String buf = new .(256);
		buf.AppendF(format, params args);
		buf.EnsureNullTerminator();

	    if (info.mEntries.Count >= MAX_ENTRIES)
		{
			String str = info.mEntries.Front;
	        info.mEntries.Remove(str);
			delete str;
		}

	    info.mEntries.Add(buf);
	}

	static FMOD.RESULT markerCallback(FMOD_STUDIO.EVENT_CALLBACK_TYPE type, void* event, void* parameters)
	{
	    CallbackInfo* callbackInfo;
		void* callbackInfoPtr = null;

		FMOD_STUDIO.EventInstance eventObj = .(event);
	    ERRCHECK!(eventObj.GetUserData(out callbackInfoPtr));
		callbackInfo = (CallbackInfo*)callbackInfoPtr;
	
	    if (type == .TIMELINE_MARKER)
	    {
	        FMOD_STUDIO.TIMELINE_MARKER_PROPERTIES* props = (FMOD_STUDIO.TIMELINE_MARKER_PROPERTIES*)parameters;
			String tmp = scope .();
			tmp.Append(props.Name);
	        markerAddString(callbackInfo, "Named marker '{0}'", tmp);
	    }
	    else if (type == .TIMELINE_BEAT)
	    {
	        FMOD_STUDIO.TIMELINE_BEAT_PROPERTIES* props = (FMOD_STUDIO.TIMELINE_BEAT_PROPERTIES*)parameters;
	        markerAddString(callbackInfo, "beat {0}, bar {1} (tempo {2:N1} {3}:{4})", props.Beat, props.Bar, props.Tempo, props.TimeSignatureUpper, props.TimeSignatureLower);
	    }
	    else if (type == .SOUND_PLAYED || type == .SOUND_STOPPED)
	    {
	        FMOD.Sound sound = .(parameters);
			String name = scope .(256);
	        ERRCHECK!(sound.GetName(name, 256));
	        uint32 len;
	        ERRCHECK!(sound.GetLength(out len, .MS));
	
	        markerAddString(callbackInfo, "Sound '{0}' (length {1:N3}) {2}", name, (float)len/1000.0f, type == .SOUND_PLAYED ? "Started" : "Stopped");
	    }
	
	    return .OK;
	}
}