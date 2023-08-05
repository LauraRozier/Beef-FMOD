namespace _3D;

using Beef_FMOD;
using Common;
using System;

static class Program
{
	const int SCREEN_WIDTH = NUM_COLUMNS;
	const int SCREEN_HEIGHT = 16;
	const int SCREEN_BUFFER_SIZE = (SCREEN_WIDTH + 1) * SCREEN_HEIGHT;

	static int currentScreenPosition = -1;
	static char8* screenBuffer = new char8[SCREEN_BUFFER_SIZE + 1]* ~ delete _;

	public static int Main(String[] Args)
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

		String bankFileMaster = scope .();
		FMOD_STUDIO.Bank masterBank = .(null);
		Common_MediaPath("Master.bank", bankFileMaster);
		ERRCHECK!(system.LoadBankFile(bankFileMaster, .NORMAL, out masterBank));

		String bankFileMasterStr = scope .();
		FMOD_STUDIO.Bank stringsBank = .(null);
		Common_MediaPath("Master.strings.bank", bankFileMasterStr);
		ERRCHECK!(system.LoadBankFile(bankFileMasterStr, .NORMAL, out stringsBank));

		String bankFileVehicles = scope .();
		FMOD_STUDIO.Bank vehiclesBank = .(null);
		Common_MediaPath("Vehicles.bank", bankFileVehicles);
		ERRCHECK!(system.LoadBankFile(bankFileVehicles, .NORMAL, out vehiclesBank));

		FMOD_STUDIO.EventDescription eventDescription = .(null);
		ERRCHECK!(system.GetEvent("event:/Vehicles/Ride-on Mower", out eventDescription));

		FMOD_STUDIO.EventInstance eventInstance = .(null);
		ERRCHECK!(eventDescription.CreateInstance(out eventInstance));

		ERRCHECK!(eventInstance.SetParameterByName("RPM", 650.0f));
		ERRCHECK!(eventInstance.Start());

		// Position the listener at the origin
		FMOD.ATTRIBUTES_3D attributes = .();
		attributes.Forward.Z = 1.0f;
		attributes.Up.Y = 1.0f;
		ERRCHECK!(system.SetListenerAttributes(0, ref attributes));

		// Position the event 2 units in front of the listener
		attributes.Position.Z = 2.0f;
		ERRCHECK!(eventInstance.Set3DAttributes(attributes));

		initializeScreenBuffer();

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

		String sbTmp = new .();

		repeat
		{
		    Common_Update();

		    if (Common_BtnDown(.BTN_LEFT))
		    {
		        attributes.Position.X -= 1.0f;
		        ERRCHECK!(eventInstance.Set3DAttributes(attributes));
		    }

		    if (Common_BtnDown(.BTN_RIGHT))
		    {
		        attributes.Position.X += 1.0f;
		        ERRCHECK!(eventInstance.Set3DAttributes(attributes));
		    }

		    if (Common_BtnDown(.BTN_UP))
		    {
		        attributes.Position.Z += 1.0f;
		        ERRCHECK!(eventInstance.Set3DAttributes(attributes));
		    }

		    if (Common_BtnDown(.BTN_DOWN))
		    {
		        attributes.Position.Z -= 1.0f;
		        ERRCHECK!(eventInstance.Set3DAttributes(attributes));
		    }

		    ERRCHECK!(system.Update());

		    updateScreenPosition(ref attributes.Position);
		    Common_Draw("==================================================");
		    Common_Draw("Event 3D Example.");
		    Common_Draw("Copyright (c) Firelight Technologies 2012-2023.");
		    Common_Draw("==================================================");
			sbTmp.Clear();
			sbTmp.Append(screenBuffer);
		    Common_Draw(sbTmp);
		    Common_Draw("Use the arrow keys ({0}, {1}, {2}, {3}) to control the event position", btnLeftText, btnRightText, btnUpText, btnDownText);
		    Common_Draw("Press {0} to quit", btnQuitText);

		    Common_Update();
		    Common_Sleep(50);
		} while (!Common_BtnDown(.BTN_QUIT));

		delete sbTmp;

		ERRCHECK!(system.Release());
		Common_Close();
		return 0;
	}

	static void initializeScreenBuffer()
	{
		Internal.MemSet(screenBuffer, (uint8)' ', SCREEN_BUFFER_SIZE);
	    int idx = SCREEN_WIDTH;

	    for (int i = 0; i < SCREEN_HEIGHT; ++i)
	    {
	        screenBuffer[idx] = '\n';
	        idx += SCREEN_WIDTH + 1;
	    }

	    screenBuffer[SCREEN_BUFFER_SIZE] = '\0';
	}

	static int getCharacterIndex(ref FMOD.VECTOR position)
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
	    int idx = getCharacterIndex(ref origin);
	    screenBuffer[idx] = '^';

	    idx = getCharacterIndex(ref eventPosition);

	    if (idx != -1)
	    {
	        screenBuffer[idx] = 'o';
	        currentScreenPosition = idx;
	    }
	}
}