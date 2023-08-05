namespace LoadBanks;

using Beef_FMOD;
using Common;
using System;

static class Program
{
	//
	// Load method as enum for our sample code
	//
	enum LoadBankMethod
	{
	    File,
	    Memory,
	    MemoryPoint,
	    Custom
	};
	const StringView[4] BANK_LOAD_METHOD_NAMES = .(
	    "File",
	    "Memory",
	    "Memory-Point",
	    "Custom"
	);

	//
	// Sanity check for loading files
	//
    const uint64 MAX_FILE_LENGTH = 2 * 1024 * 1024 * 1024UL;

	//
	// Custom callbacks that just wrap fopen
	//
	static FMOD.RESULT customFileOpen([MangleConst]char8* name, ref uint32 filesize, ref void* handle, void* userdata)
	{
		// We pass the filename into our callbacks via userdata in the custom info struct
		char8* filename = (char8*)userdata;

		filesize = 0;
		handle = null;

		Platform.BfpFileResult fileResult = .Ok;
		Platform.BfpFile* file = Platform.BfpFile_Create(filename, .OpenExisting, .Read, .Normal, &fileResult);

		if ((file == null) || (fileResult != .Ok))
			return .ERR_FILE_NOTFOUND;

		int64 length = Platform.BfpFile_GetFileSize(file);
		Platform.BfpFile_Seek(file, 0, .Absolute);

		if (length >= MAX_FILE_LENGTH)
		{
		    Platform.BfpFile_Release(file);
		    return .ERR_FILE_BAD;
		}

		filesize = (uint32)length;
		handle = file;

		return .OK;
	}

	static FMOD.RESULT customFileClose(void* handle, void* userdata)
	{
	    Platform.BfpFile* file = (Platform.BfpFile*)handle;
		Platform.BfpFile_Release(file);
	    return .OK;
	}

	static FMOD.RESULT customFileRead(void* handle, void* buffer, uint32 sizebytes, ref uint32 bytesread, void* userdata)
	{
	    bytesread = 0;
	    Platform.BfpFile* file = (Platform.BfpFile*)handle;

		Platform.BfpFileResult result = .Ok;
	    int read = Platform.BfpFile_Read(file, buffer, sizebytes, -1, &result);
	    bytesread = (uint32)read;

		
		if ((result != .Ok) && (result != .PartialData))
			return .ERR_FILE_BAD;

	    // If the request is larger than the bytes left in the file, then we must return EOF
	    if (read < sizebytes)
	        return .ERR_FILE_EOF;

	    return .OK;
	}

	static FMOD.RESULT customFileSeek(void* handle, uint32 pos, void* userdata)
	{
	    Platform.BfpFile* file = (Platform.BfpFile*)handle;
	    Platform.BfpFile_Seek(file, pos, .Absolute);
	    return .OK;
	}

	//
	// Helper function that loads a file into aligned memory buffer
	//
	static FMOD.RESULT loadFile(StringView filename, out char8* memoryBase, out char8* memoryPtr, out int32 memoryLength)
	{
		memoryBase = null;
		memoryPtr = null;
		memoryLength = 0;

	    // If we don't support fopen then just return a single invalid byte for our file
	    int length = 1;

		Platform.BfpFileResult fileResult = .Ok;
		Platform.BfpFile* file = Platform.BfpFile_Create(filename.Ptr, .OpenExisting, .Read, .Normal, &fileResult);

		if ((file == null) || (fileResult != .Ok))
	        return .ERR_FILE_NOTFOUND;

	    length = Platform.BfpFile_GetFileSize(file);
	    Platform.BfpFile_Seek(file, 0, .Absolute);

	    if (length >= MAX_FILE_LENGTH)
	    {
			Platform.BfpFile_Release(file);
	        return .ERR_FILE_BAD;
	    }

	    // Load into a pointer aligned to FMOD_STUDIO_LOAD_MEMORY_ALIGNMENT
	    char8* membase = (char8*)(Internal.Malloc(length + FMOD_STUDIO.LOAD_MEMORY_ALIGNMENT));
	    char8* memptr = &membase[0];

		Platform.BfpFileResult result = .Ok;
	    int bytesRead = Platform.BfpFile_Read(file, memptr, length, -1, &result);
		Platform.BfpFile_Release(file);

	    if (bytesRead != length)
	    {
	        Internal.Free(membase);
	        return .ERR_FILE_BAD;
	    }

	    memoryBase = membase;
	    memoryPtr = memptr;
	    memoryLength = (int32)length;
	    return .OK;
	}

	//
	// Helper function that loads a bank in using the given method
	//
	static FMOD.RESULT loadBank(FMOD_STUDIO.System system, LoadBankMethod method, StringView filename, out FMOD_STUDIO.Bank bank)
	{
		bank = .(null);
		String fileStr = scope .(filename);
		fileStr.Replace('\\', System.IO.Path.DirectorySeparatorChar);
		fileStr.Replace('/', System.IO.Path.DirectorySeparatorChar);
		fileStr.EnsureNullTerminator();

	    if (method == .File)
	        return system.LoadBankFile(fileStr, .NONBLOCKING, out bank);
	    
		if (method == .Memory || method == .MemoryPoint)
	    {
	        char8* memoryBase;
	        char8* memoryPtr;
	        int32 memoryLength;
	        FMOD.RESULT result = loadFile(fileStr, out memoryBase, out memoryPtr, out memoryLength);

	        if (result != .OK)
	            return result;

	        FMOD_STUDIO.LOAD_MEMORY_MODE memoryMode = (method == .MemoryPoint ? .LOAD_MEMORY_POINT : .LOAD_MEMORY);
	        result = system.LoadBankMemory((uint8*)memoryPtr, memoryLength, memoryMode, .NONBLOCKING, out bank);

	        if (result != .OK)
	        {
	            Internal.Free(memoryBase);
	            return result;
	        }

	        if (method == .MemoryPoint) // Keep memory around until bank unload completes
	            result = bank.SetUserData(memoryBase);
	        else // Don't need memory any more
	            Internal.Free(memoryBase);

	        return result;
	    }

        // Set up custom callback
        FMOD_STUDIO.BANK_INFO info = .();
        info.Size = sizeof(FMOD_STUDIO.BANK_INFO);
        info.OpenCallback = => customFileOpen;
        info.CloseCallback = => customFileClose;
        info.ReadCallback = => customFileRead;
        info.SeekCallback = => customFileSeek;
        info.UserData = fileStr.Ptr;
		info.UserDataLength = (int32)fileStr.Length + 1; // +1 to include the null-term

        return system.LoadBankCustom(ref info, .NONBLOCKING, out bank);
	}

	//
	// Helper function to return state as a string
	//
	static void getLoadingStateString(FMOD_STUDIO.LOADING_STATE state, FMOD.RESULT loadResult, String outStr)
	{
	    switch (state)
	    {
	        case .UNLOADING:
	            outStr.Set("unloading  ");
	        case .UNLOADED:
	            outStr.Set("unloaded   ");
	        case .LOADING:
	            outStr.Set("loading    ");
	        case .LOADED:
	            outStr.Set("loaded     ");
	        case .ERROR:
	            // Show some common errors
	            if (loadResult == .ERR_NOTREADY)
					outStr.Set("error (rdy)");
	            else if (loadResult == .ERR_FILE_BAD)
					outStr.Set("error (bad)");
	            else if (loadResult == .ERR_FILE_NOTFOUND)
					outStr.Set("error (mis)");
	            else
					outStr.Set("error      ");
	        default:
				outStr.Set("???");
	    }
	}

	//
	// Helper function to return handle validity as a string.
	// Just because the bank handle is valid doesn't mean the bank load
	// has completed successfully!
	//
	static void getHandleStateString(FMOD_STUDIO.Bank bank, String outStr)
	{
	    if (!bank.IsValid())
	        outStr.Set("invalid");
	    else
	        outStr.Set("valid  ");
	}

	//
	// Callback to free memory-point allocation when it is safe to do so
	//
	static FMOD.RESULT studioCallback(void* system, FMOD_STUDIO.SYSTEM_CALLBACK_TYPE type, void* commanddata, void* userdata)
	{
	    if (type == .BANK_UNLOAD)
	    {
	        // For memory-point, it is now safe to free our memory
	        FMOD_STUDIO.Bank bank = .(commanddata);
	        void* memory;
	        ERRCHECK!(bank.GetUserData(out memory));

	        if (memory != null)
	            Internal.Free(memory);
	    }

	    return .OK;
	}

	static int Main(String[] Args)
	{
		Common_Start();
    	void* extraDriverData = null;

		FMOD_STUDIO.System system = .(null);
		ERRCHECK!(FMOD_STUDIO.System.Create(out system));
		ERRCHECK!(system.Initialize(1024, .NORMAL, .NORMAL, extraDriverData));
		ERRCHECK!(system.SetCallback(=> studioCallback, .BANK_UNLOAD));

		let BANK_COUNT = 4;
		let BANK_NAMES = StringView[4](
		    "SFX.bank",
		    "Music.bank",
		    "Vehicles.bank",
		    "VO.bank"
		);

		FMOD_STUDIO.Bank[BANK_COUNT] banks = .();
		bool[BANK_COUNT] wantBankLoaded = .();
		bool wantSampleLoad = true;

		String btnAct1Text = scope .();
		Common_BtnStr(.BTN_ACTION1, btnAct1Text);
		String btnAct2Text = scope .();
		Common_BtnStr(.BTN_ACTION2, btnAct2Text);
		String btnAct3Text = scope .();
		Common_BtnStr(.BTN_ACTION3, btnAct3Text);
		String btnAct4Text = scope .();
		Common_BtnStr(.BTN_ACTION4, btnAct4Text);
		String btnMoreText = scope .();
		Common_BtnStr(.BTN_MORE, btnMoreText);
		String btnQuitText = scope .();
		Common_BtnStr(.BTN_QUIT, btnQuitText);

		String handleStateStr = new .();
		String bankLoadStateStr = new .();
		String sampleStateStr = new .();

		repeat
		{
        	Common_Update();

			for (int i = 0; i < BANK_COUNT; i++)
			{
			    if (Common_BtnDown((Common_Button)(.BTN_ACTION1 + i)))
			    {
			        // Toggle bank load, or bank unload
			        if (!wantBankLoaded[i])
			        {
						String filePath = scope .();
						Common_MediaPath(BANK_NAMES[i], filePath);
			            ERRCHECK!(loadBank(system, (LoadBankMethod)i, filePath, out banks[i]));
			            wantBankLoaded[i] = true;
			        }
			        else
			        {
			            ERRCHECK!(banks[i].Unload());
			            wantBankLoaded[i] = false;
			        }
			    }
			}

			if (Common_BtnDown(.BTN_MORE))
			    wantSampleLoad = !wantSampleLoad;

			// Load bank sample data automatically if that mode is enabled
			// Also query current status for text display
			FMOD.RESULT[BANK_COUNT] loadStateResult = .( .OK, .OK, .OK, .OK,  );
			FMOD.RESULT[BANK_COUNT] sampleStateResult = .( .OK, .OK, .OK, .OK, );
			FMOD_STUDIO.LOADING_STATE[BANK_COUNT] bankLoadState = .( .UNLOADED, .UNLOADED, .UNLOADED, .UNLOADED );
			FMOD_STUDIO.LOADING_STATE[BANK_COUNT] sampleLoadState = .( .UNLOADED, .UNLOADED, .UNLOADED, .UNLOADED );

			for (int i = 0; i < BANK_COUNT; i++)
			{
			    if (banks[i].IsValid())
			        loadStateResult[i] = banks[i].GetLoadingState(out bankLoadState[i]);

			    if (bankLoadState[i] == .LOADED)
			    {
			        sampleStateResult[i] = banks[i].GetSampleLoadingState(out sampleLoadState[i]);

			        if (wantSampleLoad && sampleLoadState[i] == .UNLOADED)
			            ERRCHECK!(banks[i].LoadSampleData());
			        else if (!wantSampleLoad && (sampleLoadState[i] == .LOADING || sampleLoadState[i] == .LOADED))
			            ERRCHECK!(banks[i].UnloadSampleData());
			    }
			}

			ERRCHECK!(system.Update());

			Common_Draw("==================================================");
			Common_Draw("Bank Load Example.");
			Common_Draw("Copyright (c) Firelight Technologies 2012-2023.");
			Common_Draw("==================================================");
			Common_Draw("Name            Handle  Bank-State  Sample-State");

			for (int i=0; i<BANK_COUNT; ++i)
			{
			    String namePad = scope .(64);
				char8* namePadPtr = namePad.CStr();
			    int bankNameLen = BANK_NAMES[i].Length + 1;
			    Internal.MemSet(namePadPtr, (uint8)' ', 15);
				Internal.MemCpy(namePadPtr, BANK_NAMES[i].Ptr, bankNameLen);

				getHandleStateString(banks[i], handleStateStr);
				getLoadingStateString(bankLoadState[i], loadStateResult[i], bankLoadStateStr);
				getLoadingStateString(sampleLoadState[i], sampleStateResult[i], sampleStateStr);
			    Common_Draw("{0} {1} {2} {3}", namePad, handleStateStr, bankLoadStateStr, sampleStateStr);
	        }
	
	        Common_Draw("");
	        Common_Draw("Press {0} to load bank 1 via {1}", btnAct1Text, BANK_LOAD_METHOD_NAMES[0]);
	        Common_Draw("Press {0} to load bank 2 via {1}", btnAct2Text, BANK_LOAD_METHOD_NAMES[1]);
	        Common_Draw("Press {0} to load bank 3 via {1}", btnAct3Text, BANK_LOAD_METHOD_NAMES[2]);
	        Common_Draw("Press {0} to load bank 4 via {1}", btnAct4Text, BANK_LOAD_METHOD_NAMES[3]);
	        Common_Draw("Press {0} to toggle sample data", btnMoreText);
	        Common_Draw("Press {0} to quit", btnQuitText);

			Common_Sleep(50);
		} while (!Common_BtnDown(.BTN_QUIT));

		ERRCHECK!(system.UnloadAll());
		ERRCHECK!(system.FlushCommands());
		ERRCHECK!(system.Release());

		delete handleStateStr;
		delete bankLoadStateStr;
		delete sampleStateStr;

		Common_Close();
		return 0;
	}
}