namespace RecordingPlayback;

using Beef_FMOD;
using Common;
using System;

static class Program
{
	const int32 SCREEN_WIDTH = NUM_COLUMNS;
	const int32 SCREEN_HEIGHT = 10;
	const int32 SCREEN_BUFF_SIZE = (SCREEN_WIDTH + 1) * SCREEN_HEIGHT + 1;

	static int currentScreenPosition = -1;
	static char8* screenBuffer = new char8[SCREEN_BUFF_SIZE + 1]* ~ delete _; // +1 for null-term

	static StringView RECORD_FILENAME = "playback.cmd.txt";

	enum State
	{
	    Selection,
	    Record,
	    Playback,
	    Quit
	}

	static int Main(String[] Args)
	{
		Common_Start();
    	void* extraDriverData = null;

		FMOD_STUDIO.System system = .(null);
		ERRCHECK!(FMOD_STUDIO.System.Create(out system));

		// The example Studio project is authored for 5.1 sound, so set up the system output mode to match
		FMOD.System coreSystem = .(null);
		ERRCHECK!(system.GetCoreSystem(out coreSystem));
		ERRCHECK!(coreSystem.SetSoftwareFormat(0, ._5POINT1, 0));

		ERRCHECK!(system.Initialize(1024, .NORMAL, .NORMAL, extraDriverData));

		State state = .Selection;

		while (state != .Quit)
		{
		    switch (state)
		    {
	        case .Selection:
	            state = executeSelection(system);
	        case .Record:
	            state = executeRecord(system);
	        case .Playback:
	            state = executePlayback(system);
	        case .Quit: {}
		    }
		}

		ERRCHECK!(system.Release());
		Common_Close();
		return 0;
	}

	// Show the main selection menu
	static State executeSelection(FMOD_STUDIO.System system)
	{
		String btnQuitText = scope .();
		Common_BtnStr(.BTN_QUIT, btnQuitText);
		String btnAct1Text = scope .();
		Common_BtnStr(.BTN_ACTION1, btnAct1Text);
		String btnAct2Text = scope .();
		Common_BtnStr(.BTN_ACTION2, btnAct2Text);

	    while (true)
	    {
	        Common_Update();
	
	        if (Common_BtnDown(.BTN_ACTION1))
	            return .Record;

	        if (Common_BtnDown(.BTN_ACTION2))
	            return .Playback;

	        if (Common_BtnDown(.BTN_QUIT))
	            return .Quit;
	
	        ERRCHECK!(system.Update());
	
	        Common_Draw("==================================================");
	        Common_Draw("Recording and playback example.");
	        Common_Draw("Copyright (c) Firelight Technologies 2012-2023.");
	        Common_Draw("==================================================");
	        Common_Draw("");
	        Common_Draw("Waiting to start recording");
	        Common_Draw("");
	        Common_Draw("Press {0} to start recording", btnAct1Text);
	        Common_Draw("Press {0} to play back recording", btnAct2Text);
	        Common_Draw("Press {0} to quit", btnQuitText);
	        Common_Draw("");
	        Common_Sleep(50);
	    }
	}

	// Start recording, load banks and then let the user trigger some sounds
	static State executeRecord(FMOD_STUDIO.System system)
	{
		String bankFileMaster = scope .();
	    FMOD_STUDIO.Bank masterBank = .(null);
		Common_MediaPath("Master.bank", bankFileMaster);
	    ERRCHECK!(system.LoadBankFile(bankFileMaster, .NONBLOCKING, out masterBank));

		String bankFileMasterStr = scope .();
	    FMOD_STUDIO.Bank stringsBank = .(null);
		Common_MediaPath("Master.strings.bank", bankFileMasterStr);
	    ERRCHECK!(system.LoadBankFile(bankFileMasterStr, .NONBLOCKING, out stringsBank));

		String bankFileVehicles = scope .();
	    FMOD_STUDIO.Bank vehiclesBank = .(null);
		Common_MediaPath("Vehicles.bank", bankFileVehicles);
	    ERRCHECK!(system.LoadBankFile(bankFileVehicles, .NONBLOCKING, out vehiclesBank));

		String bankFileSfx = scope .();
	    FMOD_STUDIO.Bank sfxBank = .(null);
		Common_MediaPath("SFX.bank", bankFileSfx);
	    ERRCHECK!(system.LoadBankFile(bankFileSfx, .NONBLOCKING, out sfxBank));
	
	    // Wait for banks to load
	    ERRCHECK!(system.FlushCommands());
	
	    // Start recording commands - it will also record which banks we have already loaded by now
		String recordFileStr = scope .();
		Common_WritePath(RECORD_FILENAME, recordFileStr);
	    ERRCHECK!(system.StartCommandCapture(recordFileStr, .NORMAL));
	
	    FMOD.GUID explosionID = .();
	    ERRCHECK!(system.LookupID("event:/Weapons/Explosion", out explosionID));
	
	    FMOD_STUDIO.EventDescription engineDescription = .(null);
	    ERRCHECK!(system.GetEvent("event:/Vehicles/Ride-on Mower", out engineDescription));
	
	    FMOD_STUDIO.EventInstance engineInstance = .(null);
	    ERRCHECK!(engineDescription.CreateInstance(out engineInstance));
	
	    ERRCHECK!(engineInstance.SetParameterByName("RPM", 650.0f));
	    ERRCHECK!(engineInstance.Start());
	
	    // Position the listener at the origin
	    FMOD.ATTRIBUTES_3D attributes = .();
	    attributes.Forward.Z = 1.0f;
	    attributes.Up.Y = 1.0f;
	    ERRCHECK!(system.SetListenerAttributes(0, ref attributes));
	
	    // Position the event 2 units in front of the listener
	    attributes.Position.Z = 2.0f;
	    ERRCHECK!(engineInstance.Set3DAttributes(attributes));
	
	    initializeScreenBuffer();
	
	    bool wantQuit = false;
		String screenBuffStr = new .();

		String btnLeftText = scope .();
		Common_BtnStr(.BTN_LEFT, btnLeftText);
		String btnRightText = scope .();
		Common_BtnStr(.BTN_RIGHT, btnRightText);
		String btnUpText = scope .();
		Common_BtnStr(.BTN_UP, btnUpText);
		String btnDownText = scope .();
		Common_BtnStr(.BTN_DOWN, btnDownText);
		String btnQuitText = scope .();
		Common_BtnStr(.BTN_QUIT, btnQuitText);
		String btnMoreText = scope .();
		Common_BtnStr(.BTN_MORE, btnMoreText);
		String btnAct1Text = scope .();
		Common_BtnStr(.BTN_ACTION1, btnAct1Text);
	
	    while (true)
	    {
	        Common_Update();
	
	        if (Common_BtnDown(.BTN_MORE))
	            break;
	
	        if (Common_BtnDown(.BTN_QUIT))
	        {
	            wantQuit = true;
	            break;
	        }
	
	        if (Common_BtnDown(.BTN_ACTION1))
	        {
	            // One-shot event
	            FMOD_STUDIO.EventDescription eventDescription = .(null);
	            ERRCHECK!(system.GetEventByID(explosionID, out eventDescription));
	
	            FMOD_STUDIO.EventInstance eventInstance = .(null);
	            ERRCHECK!(eventDescription.CreateInstance(out eventInstance));

	            for (int32 i = 0; i < 10; i++)
	                ERRCHECK!(eventInstance.SetVolume(i / 10.0f));
	
	            ERRCHECK!(eventInstance.Start());
	
	            // Release will clean up the instance when it completes
	            ERRCHECK!(eventInstance.Release());
	        }
	
	        if (Common_BtnDown(.BTN_LEFT))
	        {
	            attributes.Position.X -= 1.0f;
	            ERRCHECK!(engineInstance.Set3DAttributes(attributes));
	        }
	
	        if (Common_BtnDown(.BTN_RIGHT))
	        {
	            attributes.Position.X += 1.0f;
	            ERRCHECK!(engineInstance.Set3DAttributes(attributes));
	        }
	
	        if (Common_BtnDown(.BTN_UP))
	        {
	            attributes.Position.Z += 1.0f;
	            ERRCHECK!(engineInstance.Set3DAttributes(attributes));
	        }
	
	        if (Common_BtnDown(.BTN_DOWN))
	        {
	            attributes.Position.Z -= 1.0f;
	            ERRCHECK!(engineInstance.Set3DAttributes(attributes));
	        }
	
	        if (Common_BtnDown(.BTN_MORE))
	            break;

	        if (Common_BtnDown(.BTN_QUIT))
	        {
	            wantQuit = true;
	            break;
	        }
	
	        ERRCHECK!(system.Update());
	
	        updateScreenPosition(ref attributes.Position);
	        Common_Draw("==================================================");
	        Common_Draw("Recording and playback example.");
	        Common_Draw("Copyright (c) Firelight Technologies 2012-2023.");
	        Common_Draw("==================================================");
	        Common_Draw("");
	        Common_Draw("Recording!");
	        Common_Draw("");
			screenBuffStr.Clear();
			screenBuffStr.Append(screenBuffer);
	        Common_Draw(screenBuffStr);
	        Common_Draw("");
	        Common_Draw("Press {0} to finish recording", btnMoreText);
	        Common_Draw("Press {0} to play a one-shot", btnAct1Text);
	        Common_Draw("Use the arrow keys ({0}, {1}, {2}, {3}) to control the engine position", btnLeftText, btnRightText, btnUpText, btnDownText);
	        Common_Draw("Press {0} to quit", btnQuitText);
	
	        Common_Sleep(50);
	    }

		// Release the engine instance
		ERRCHECK!(engineInstance.Stop(.IMMEDIATE));
		ERRCHECK!(engineDescription.ReleaseAllInstances());

	    // Unload all the banks
	    ERRCHECK!(masterBank.Unload());
	    ERRCHECK!(stringsBank.Unload());
	    ERRCHECK!(vehiclesBank.Unload());
	    ERRCHECK!(sfxBank.Unload());
	
	    // Finish recording
	    ERRCHECK!(system.FlushCommands());
	    ERRCHECK!(system.StopCommandCapture());

		delete screenBuffStr;
	    return (wantQuit ? .Quit : .Selection);
	}
	
	// Play back a previously recorded file
	static State executePlayback(FMOD_STUDIO.System system)
	{
	    FMOD_STUDIO.CommandReplay replay = .(null);
		String recordFile = scope .();
		Common_WritePath(RECORD_FILENAME, recordFile);
	    ERRCHECK!(system.LoadCommandReplay(recordFile, .NORMAL, out replay));
	    int32 commandCount;
	    ERRCHECK!(replay.GetCommandCount(out commandCount));
	    float totalTime;
	    ERRCHECK!(replay.GetLength(out totalTime));
	    ERRCHECK!(replay.Start());
	    ERRCHECK!(system.Update());

		String btnQuitText = scope .();
		Common_BtnStr(.BTN_QUIT, btnQuitText);
		String btnMoreText = scope .();
		Common_BtnStr(.BTN_MORE, btnMoreText);
	
	    while (true)
	    {
	        Common_Update();
	
	        if (Common_BtnDown(.BTN_QUIT))
	            break;
	
	        if (Common_BtnDown(.BTN_MORE))
	        {
	            bool paused;
	            ERRCHECK!(replay.GetPaused(out paused));
	            ERRCHECK!(replay.SetPaused(!paused));
	        }
	
	        FMOD_STUDIO.PLAYBACK_STATE state;
	        ERRCHECK!(replay.GetPlaybackState(out state));

	        if (state == .STOPPED)
	            break;
	
	        int32 currentIndex;
	        float currentTime;
	        ERRCHECK!(replay.GetCurrentCommand(out currentIndex, out currentTime));
	
	        ERRCHECK!(system.Update());
	
	        Common_Draw("==================================================");
	        Common_Draw("Recording and playback example.");
	        Common_Draw("Copyright (c) Firelight Technologies 2012-2023.");
	        Common_Draw("==================================================");
	        Common_Draw("");
	        Common_Draw("Playing back commands:");
	        Common_Draw("Command = {0} / {1}\n", currentIndex, commandCount);
	        Common_Draw("Time = {0:N3} / {1:N3}\n", currentTime, totalTime);
	        Common_Draw("");
	        Common_Draw("Press {0} to pause/unpause recording", btnMoreText);
	        Common_Draw("Press {0} to quit", btnQuitText);
	
	        Common_Sleep(50);
	    }

	    ERRCHECK!(replay.Release());
	    ERRCHECK!(system.UnloadAll());
	    return .Selection;
	}
	
	static void initializeScreenBuffer()
	{
	    Internal.MemSet(screenBuffer, (uint8)' ', SCREEN_BUFF_SIZE);
	    int idx = SCREEN_WIDTH;

	    for (int i = 0; i < SCREEN_HEIGHT; i++)
	    {
	        screenBuffer[idx] = '\n';
	        idx += SCREEN_WIDTH + 1;
	    }
	
	    screenBuffer[(SCREEN_WIDTH + 1) * SCREEN_HEIGHT] = '\0';
	}
	
	static int32 getCharacterIndex(ref FMOD.VECTOR position)
	{
	    int32 row = (int32)(-position.Z + (SCREEN_HEIGHT / 2));
	    int32 col = (int32)(position.X + (SCREEN_WIDTH / 2));
	
	    if (0 < row && row < SCREEN_HEIGHT && 0 < col && col < SCREEN_WIDTH)
	        return (row * (SCREEN_WIDTH + 1)) + col;
	
	    return -1;
	}
	
	static void updateScreenPosition(ref FMOD.VECTOR eventPosition)
	{
	    if (currentScreenPosition != -1)
	    {
	        screenBuffer[currentScreenPosition] = ' ';
	        currentScreenPosition = -1;
	    }
	
	    FMOD.VECTOR origin = .();
	    int32 idx = getCharacterIndex(ref origin);
	    screenBuffer[idx] = '^';
	
	    idx = getCharacterIndex(ref eventPosition);

	    if (idx != -1)
	    {
	        screenBuffer[idx] = 'o';
	        currentScreenPosition = idx;
	    }
	}
}