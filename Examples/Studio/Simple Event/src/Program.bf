namespace SimpleEvent;

using Beef_FMOD;
using Common;
using System;

static class Program
{
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

		String bankFileSfx = scope .();
	    FMOD_STUDIO.Bank sfxBank = .(null);
		Common_MediaPath("SFX.bank", bankFileSfx);
	    ERRCHECK!(system.LoadBankFile(bankFileSfx, .NORMAL, out sfxBank));
	
	    // Get the Looping Ambience event
	    FMOD_STUDIO.EventDescription loopingAmbienceDescription = .(null);
	    ERRCHECK!(system.GetEvent("event:/Ambience/Country", out loopingAmbienceDescription));
	
	    FMOD_STUDIO.EventInstance loopingAmbienceInstance = .(null);
	    ERRCHECK!(loopingAmbienceDescription.CreateInstance(out loopingAmbienceInstance));
	
	    // Get the 4 Second Surge event
	    FMOD_STUDIO.EventDescription cancelDescription = .(null);
	    ERRCHECK!(system.GetEvent("event:/UI/Cancel", out cancelDescription));
	
	    FMOD_STUDIO.EventInstance cancelInstance = .(null);
	    ERRCHECK!(cancelDescription.CreateInstance(out cancelInstance));
	
	    // Get the Single Explosion event
	    FMOD_STUDIO.EventDescription explosionDescription = .(null);
	    ERRCHECK!(system.GetEvent("event:/Weapons/Explosion", out explosionDescription));
	
	    // Start loading explosion sample data and keep it in memory
	    ERRCHECK!(explosionDescription.LoadSampleData());

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
	
	    repeat
	    {
	        Common_Update();
	
	        if (Common_BtnDown(.BTN_ACTION1))
	        {
	            // One-shot event
	            FMOD_STUDIO.EventInstance eventInstance = .(null);
	            ERRCHECK!(explosionDescription.CreateInstance(out eventInstance));
	
	            ERRCHECK!(eventInstance.Start());
	
	            // Release will clean up the instance when it completes
	            ERRCHECK!(eventInstance.Release());
	        }
	
	        if (Common_BtnDown(.BTN_ACTION2))
	            ERRCHECK!(loopingAmbienceInstance.Start());
	
	        if (Common_BtnDown(.BTN_ACTION3))
	            ERRCHECK!(loopingAmbienceInstance.Stop(.IMMEDIATE));
	
	        if (Common_BtnDown(.BTN_ACTION4)) // Calling start on an instance will cause it to restart if it's already playing
	            ERRCHECK!(cancelInstance.Start());
	
	        ERRCHECK!(system.Update());
	
	        Common_Draw("==================================================");
	        Common_Draw("Simple Event Example.");
	        Common_Draw("Copyright (c) Firelight Technologies 2012-2023.");
	        Common_Draw("==================================================");
	        Common_Draw("");
	        Common_Draw("Press {0} to fire and forget the explosion", btnAct1Text);
	        Common_Draw("Press {0} to start the looping ambience", btnAct2Text);
	        Common_Draw("Press {0} to stop the looping ambience", btnAct3Text);
	        Common_Draw("Press {0} to start/restart the cancel sound", btnAct4Text);
	        Common_Draw("Press {0} to quit", btnQuitText);
	
	        Common_Sleep(50);
	    } while (!Common_BtnDown(.BTN_QUIT));

	    ERRCHECK!(sfxBank.Unload());
	    ERRCHECK!(stringsBank.Unload());
	    ERRCHECK!(masterBank.Unload());
	
	    ERRCHECK!(system.Release());
	
	    Common_Close();
		return 0;
	}
}