namespace ObjectPan;

using Beef_FMOD;
using Common;
using System;

static class Program
{
	static int Main(String[] Args)
	{
		Common_Start();
	    void* extraDriverData = null;
	    bool isOnGround = false;
	    bool useListenerAttenuationPosition = false;
	
	    FMOD_STUDIO.System system = .(null);
	    ERRCHECK!(FMOD_STUDIO.System.Create(out system));
	
	    // The example Studio project is authored for 5.1 sound, so set up the system output mode to match
	    FMOD.System coreSystem = .(null);
	    ERRCHECK!(system.GetCoreSystem(out coreSystem));
	    ERRCHECK!(coreSystem.SetSoftwareFormat(0, ._5POINT1, 0));
	
	    // Attempt to initialize with a compatible object panning output
	    FMOD.RESULT result = coreSystem.SetOutput(.AUDIO3D);

	    if (result != .OK)
	    {
	        result = coreSystem.SetOutput(.WINSONIC);

	        if (result == .OK)
	            ERRCHECK!(coreSystem.SetSoftwareFormat(0, ._7POINT1POINT4, 0));
	    }
	
	    int32 numDrivers = 0;
	    ERRCHECK!(coreSystem.GetNumDrivers(out numDrivers) );
	
	    if (numDrivers == 0)
	    {
	        ERRCHECK!(coreSystem.SetDSPBufferSize(512, 4) );
	        ERRCHECK!(coreSystem.SetOutput(.AUTODETECT) );
	    }
	
	    // Due to a bug in WinSonic on Windows, FMOD initialization may fail on some machines.
	    // If you get the error "FMOD error 51 - Error initializing output device", try using
	    // a different output type such as FMOD_OUTPUTTYPE_AUTODETECT
	    ERRCHECK!(system.Initialize(1024, .NORMAL, .NORMAL, extraDriverData));

	    // Load everything needed for playback
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
	    ERRCHECK!(system.LoadBankFile(bankFileMusic, .NORMAL, out musicBank));

	    float spatializer;
	    float radioFrequency;
		
		FMOD_STUDIO.EventDescription spatializerDescription = .(null);
	    ERRCHECK!(system.GetEvent("event:/Music/Radio Station", out spatializerDescription));
	    FMOD_STUDIO.EventInstance spatializerInstance = .(null);
	    ERRCHECK!(spatializerDescription.CreateInstance(out spatializerInstance));
	    ERRCHECK!(spatializerInstance.Start());

		String btnAct1Text = scope .();
		Common_BtnStr(.BTN_ACTION1, btnAct1Text);
		String btnAct2Text = scope .();
		Common_BtnStr(.BTN_ACTION2, btnAct2Text);
		String btnAct3Text = scope .();
		Common_BtnStr(.BTN_ACTION3, btnAct3Text);
		String btnAct4Text = scope .();
		Common_BtnStr(.BTN_ACTION4, btnAct4Text);
		String btnQuitText = scope .();
		Common_BtnStr(.BTN_QUIT, btnQuitText);
	
	    repeat
	    {
	        Common_Update();
	
	        ERRCHECK!(spatializerInstance.GetParameterByName("Freq", var _1, out radioFrequency));
	        ERRCHECK!(spatializerInstance.GetParameterByName("Spatializer", var _2, out spatializer));
	
	        if (Common_BtnDown(.BTN_ACTION1))
	        {
	            if (radioFrequency == 3.00f)
	                ERRCHECK!(spatializerInstance.SetParameterByName("Freq", 0.00f));
	            else
	                ERRCHECK!(spatializerInstance.SetParameterByName("Freq", (radioFrequency + 1.50f)));
	        }
	
	        if (Common_BtnDown(.BTN_ACTION2))
	        {
	            if (spatializer == 1.00)
	                ERRCHECK!(spatializerInstance.SetParameterByName("Spatializer", 0.00f));
	            else
	                ERRCHECK!(spatializerInstance.SetParameterByName("Spatializer", 1.00f));
	        }
	
	        if (Common_BtnDown(.BTN_ACTION3))
	            isOnGround = !isOnGround;
	
	        if (Common_BtnDown(.BTN_ACTION4))
	            useListenerAttenuationPosition = !useListenerAttenuationPosition;
	
	        FMOD.ATTRIBUTES_3D vec = .();
	        vec.Forward.Z = 1.0f;
	        vec.Up.Y = 1.0f;
	        float t = 0;
	        vec.Position.X = Math.Sin(t) * 3.0f; /* Rotate sound in a circle */
	        vec.Position.Z = Math.Cos(t) * 3.0f; /* Rotate sound in a circle */
	        t += 0.03f;
	
	        if (isOnGround)
	            vec.Position.Y = 0;    /* At ground level */
	        else
	            vec.Position.Y = 5.0f; /* Up high */
	
	        ERRCHECK!(spatializerInstance.Set3DAttributes(vec));
	
	        FMOD.ATTRIBUTES_3D listener_vec = .();
	        listener_vec.Forward.Z = 1.0f;
	        listener_vec.Up.Y = 1.0f;
	
	        FMOD.VECTOR listener_attenuationPos = vec.Position;
	        listener_attenuationPos.Z -= -10.0f;

			FMOD.VECTOR attenuationPosition = useListenerAttenuationPosition ? listener_attenuationPos : .();
	        ERRCHECK!(system.SetListenerAttributes(0, ref listener_vec, ref attenuationPosition));
	        ERRCHECK!(system.Update());
	
	        StringView radioString = (radioFrequency == 0.00f) ? "Rock" : (radioFrequency == 1.50f) ? "Lo-fi" : "Hip hop";
	        StringView spatialString = (spatializer == 0.00f) ? "Standard 3D Spatializer" : "Object Spatializer";
	
	        Common_Draw("==================================================");
	        Common_Draw("Object Panning Example.");
	        Common_Draw("Copyright (c) Firelight Technologies 2015-2023.");
	        Common_Draw("==================================================");
	        Common_Draw("");
	        Common_Draw("Playing {0} with the {1}.", radioString, spatialString);
	        Common_Draw("Radio is {0}.", isOnGround ? "on the ground" : "up in the air");
	        Common_Draw("");
	        Common_Draw("Press {0} to switch stations.", btnAct1Text);
	        Common_Draw("Press {0} to switch spatializer.", btnAct2Text);
	        Common_Draw("Press {0} to elevate the event instance.", btnAct3Text);
	        Common_Draw("Press {0} to {1} use of attenuation position.", btnAct4Text, useListenerAttenuationPosition ? "disable" : "enable");
	        Common_Draw("");
	        Common_Draw("Press {0} to quit", btnQuitText);
	
	        Common_Sleep(50);
	    } while (!Common_BtnDown(.BTN_QUIT));

	    ERRCHECK!(stringsBank.Unload());
	    ERRCHECK!(musicBank.Unload());
	    ERRCHECK!(system.Release());
	
	    Common_Close();
		return 0;
	}
}