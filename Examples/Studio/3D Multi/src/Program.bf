namespace _3DMulti;

using Beef_FMOD;
using Common;
using System;

static class Program
{
	const int SCREEN_WIDTH = NUM_COLUMNS;
	const int SCREEN_HEIGHT = 10;
	const int32 BUFFER_SIZE = (SCREEN_WIDTH + 1) * SCREEN_HEIGHT + 1;
	
	static char8* backBuffer = new char8[BUFFER_SIZE + 1]* ~ delete _;
	static char8* screenBuffer = new char8[BUFFER_SIZE + 1]* ~ delete _;

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

		// Position two listeners
		ERRCHECK!(system.SetNumListeners(2));
		int activeListener = 0;
		float listenerDist = 8.0f;
		float[2] listenerWeight = .(1.0f, 0.0f);
		FMOD.ATTRIBUTES_3D[2] listenerAttributes = .();
		listenerAttributes[0].Forward.Z = 1.0f;
		listenerAttributes[0].Up.Y = 1.0f;
		listenerAttributes[0].Position.X = -listenerDist;
		listenerAttributes[1].Forward.Z = 1.0f;
		listenerAttributes[1].Up.Y = 1.0f;
		listenerAttributes[1].Position.X = listenerDist;

		ERRCHECK!(system.SetListenerAttributes(0, ref listenerAttributes[0]));
		ERRCHECK!(system.SetListenerWeight(0, listenerWeight[0]));
		ERRCHECK!(system.SetListenerAttributes(1, ref listenerAttributes[1]));
		ERRCHECK!(system.SetListenerWeight(1, listenerWeight[1]));

		// Position the event 2 units in front of the listener
		FMOD.ATTRIBUTES_3D carAttributes = .();
		carAttributes.Forward.Z = 1.0f;
		carAttributes.Up.Y = 1.0f;
		carAttributes.Position.X = 0.0f;
		carAttributes.Position.Z = 2.0f;
		ERRCHECK!(eventInstance.Set3DAttributes(carAttributes));

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
		String btnAct1Text = scope .();
		Common_BtnStr(.BTN_ACTION1, btnAct1Text);
		String btnAct2Text = scope .();
		Common_BtnStr(.BTN_ACTION2, btnAct2Text);
		String btnAct3Text = scope .();
		Common_BtnStr(.BTN_ACTION3, btnAct3Text);
		String btnAct4Text = scope .();
		Common_BtnStr(.BTN_ACTION4, btnAct4Text);

		String sbTmp = new .();

		repeat
		{
		    Common_Update();

		    if (Common_BtnDown(.BTN_LEFT))
		    {
		        carAttributes.Position.X -= 1.0f;
		        ERRCHECK!(eventInstance.Set3DAttributes(carAttributes));
		    }

		    if (Common_BtnDown(.BTN_RIGHT))
		    {
		        carAttributes.Position.X += 1.0f;
		        ERRCHECK!(eventInstance.Set3DAttributes(carAttributes));
		    }

		    if (Common_BtnDown(.BTN_UP))
		    {
		        carAttributes.Position.Z += 1.0f;
		        ERRCHECK!(eventInstance.Set3DAttributes(carAttributes));
		    }

		    if (Common_BtnDown(.BTN_DOWN))
		    {
		        carAttributes.Position.Z -= 1.0f;
		        ERRCHECK!(eventInstance.Set3DAttributes(carAttributes));
		    }

		    if (Common_BtnDown(.BTN_ACTION1))
		    {
		        activeListener++;

		        if (activeListener > 2)
		            activeListener = 0;
		    }

		    if (Common_BtnDown(.BTN_ACTION2))
		    {
		        activeListener--;

		        if (activeListener < 0)
		            activeListener = 2;
		    }

		    if (Common_BtnDown(.BTN_ACTION3))
		    {
		        listenerDist -= 1.0f;

		        if (listenerDist < 0.0f)
		            listenerDist = 0.0f;
		    }

		    if (Common_BtnDown(.BTN_ACTION4))
		    {
		        listenerDist += 1.0f;

		        if (listenerDist < 0.0f)
		            listenerDist = 0.0f;
		    }

		    for (int i = 0; i < 2; i++)
		    {
		        float target = (activeListener == i || activeListener == 2) ? 1.0f : 0.0f; // 0 = left, 1 = right, 2 = both

		        float dist = (target - listenerWeight[i]);
		        float step = 50.0f / 1000.0f; // very rough estimate of 50ms per update, not properly timed

		        if (dist >= -step && dist <= step)
		            listenerWeight[i] = target;
		        else if (dist > 0.0f)
		            listenerWeight[i] += step;
		        else
		            listenerWeight[i] += -step;
		    }

		    listenerAttributes[0].Position.X = -listenerDist;
		    listenerAttributes[1].Position.X = listenerDist;
		    ERRCHECK!(system.SetListenerAttributes(0, ref listenerAttributes[0]));
		    ERRCHECK!(system.SetListenerAttributes(1, ref listenerAttributes[1]));
		    ERRCHECK!(system.SetListenerWeight(0, listenerWeight[0]));
		    ERRCHECK!(system.SetListenerWeight(1, listenerWeight[1]));

		    ERRCHECK!(system.Update());

		    updateScreenPosition(ref carAttributes.Position, listenerDist, listenerWeight[0], listenerWeight[1]);

		    Common_Draw("==================================================");
		    Common_Draw("Event 3D Multi-Listener Example.");
		    Common_Draw("Copyright (c) Firelight Technologies 2012-2023.");
		    Common_Draw("==================================================");
			sbTmp.Clear();
			sbTmp.Append(screenBuffer);
		    Common_Draw(sbTmp);

		    Common_Draw("Left listener: {0}%", (int)(listenerWeight[0] * 100));
		    Common_Draw("Right listener: {0}%", (int)(listenerWeight[1] * 100));
		    Common_Draw("Use the arrow keys ({0}, {1}, {2}, {3}) to control the event position", btnLeftText, btnRightText, btnUpText, btnDownText);
		    Common_Draw("Use {0} and {1} to toggle left/right/both listeners", btnAct1Text, btnAct2Text);
		    Common_Draw("Use {0} and {1} to move listeners closer or further apart", btnAct3Text, btnAct4Text);
		    Common_Draw("Press {0} to quit", btnQuitText);

		    Common_Sleep(50);
		} while (!Common_BtnDown(.BTN_QUIT));

		delete sbTmp;
		ERRCHECK!(system.Release());
		Common_Close();
		return 0;
	}

	static void initializeScreenBuffer()
	{
	    Internal.MemSet(backBuffer, (uint8)' ', BUFFER_SIZE);
	    int idx = SCREEN_WIDTH;

	    for (int i = 0; i < SCREEN_HEIGHT; ++i)
	    {
	        backBuffer[idx] = '\n';
	        idx += SCREEN_WIDTH + 1;
	    }
	
	    backBuffer[(SCREEN_WIDTH + 1) * SCREEN_HEIGHT] = '\0';
	    Internal.MemCpy(screenBuffer, backBuffer, BUFFER_SIZE);
	}
	
	static void setCharacterIndex(ref FMOD.VECTOR position, char8 ch)
	{
	    int32 row = (int32)(-position.Z + (SCREEN_HEIGHT / 2));
	    int32 col = (int32)(position.X + (SCREEN_WIDTH / 2));
	
	    if (0 < row && row < SCREEN_HEIGHT && 0 < col && col < SCREEN_WIDTH)
	        screenBuffer[row * (SCREEN_WIDTH + 1) + col] = ch;
	}
	
	static char8 symbolForWeight(float weight)
	{
	    if (weight >= 0.95f)
	        return 'X';
	    else if (weight >= 0.05f)
	        return 'x';
	    else
	        return '.';
	}
	
	static void updateScreenPosition(ref FMOD.VECTOR worldPosition, float listenerDist, float weight1, float weight2)
	{
	    Internal.MemCpy(screenBuffer, backBuffer, BUFFER_SIZE);
	
	    FMOD.VECTOR pos = .();
	    setCharacterIndex(ref pos, '^');
	
	    pos.X = -listenerDist;
	    setCharacterIndex(ref pos, symbolForWeight(weight1));
	
	    pos.X = listenerDist;
	    setCharacterIndex(ref pos, symbolForWeight(weight2));
	
	    setCharacterIndex(ref worldPosition, 'o');
	}
}