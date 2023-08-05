namespace EventParameter;

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
		ERRCHECK!(FMOD_STUDIO.System.Create(out system) );
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

		FMOD_STUDIO.EventDescription eventDescription = .(null);
		ERRCHECK!(system.GetEvent("event:/Character/Player Footsteps", out eventDescription));

		// Find the parameter once and then set by handle
		// Or we can just find by name every time but by handle is more efficient if we are setting lots of parameters
		FMOD_STUDIO.PARAMETER_DESCRIPTION paramDesc = .();
		ERRCHECK!(eventDescription.GetParameterDescriptionByName("Surface", out paramDesc));
		FMOD_STUDIO.PARAMETER_ID surfaceID = paramDesc.Id;

		FMOD_STUDIO.EventInstance eventInstance = .(null);
		ERRCHECK!(eventDescription.CreateInstance(out eventInstance));

		// Make the event audible to start with
		float surfaceParameterValue = 1.0f;
		ERRCHECK!(eventInstance.SetParameterByID(surfaceID, surfaceParameterValue));
		
		String btnMoreText = scope .();
		Common_BtnStr(.BTN_MORE, btnMoreText);
		String btnAct1Text = scope .();
		Common_BtnStr(.BTN_ACTION1, btnAct1Text);
		String btnAct2Text = scope .();
		Common_BtnStr(.BTN_ACTION2, btnAct2Text);
		String btnQuitText = scope .();
		Common_BtnStr(.BTN_QUIT, btnQuitText);

		repeat
		{
		    Common_Update();

		    if (Common_BtnDown(.BTN_MORE))
		    {
		        ERRCHECK!(eventInstance.Start());
		    }

		    if (Common_BtnDown(.BTN_ACTION1))
		    {
		        surfaceParameterValue = Math.Max(paramDesc.Minimum, surfaceParameterValue - 1.0f);
		        ERRCHECK!(eventInstance.SetParameterByID(surfaceID, surfaceParameterValue));
		    }

		    if (Common_BtnDown(.BTN_ACTION2))
		    {
		        surfaceParameterValue = Math.Min(surfaceParameterValue + 1.0f, paramDesc.Maximum);
		        ERRCHECK!(eventInstance.SetParameterByID(surfaceID, surfaceParameterValue));
		    }

		    ERRCHECK!(system.Update());

		    float userValue = 0.0f;
		    float finalValue = 0.0f;
		    ERRCHECK!(eventInstance.GetParameterByID(surfaceID, out userValue, out finalValue));

		    Common_Draw("==================================================");
		    Common_Draw("Event Parameter Example.");
		    Common_Draw("Copyright (c) Firelight Technologies 2012-2023.");
		    Common_Draw("==================================================");
		    Common_Draw("");
		    Common_Draw("Surface Parameter = (user: {0:N1}, final: {1:N1})", userValue, finalValue);
		    Common_Draw("");
		    Common_Draw("Surface Parameter:");
		    Common_Draw("Press {0} to play event", btnMoreText);
		    Common_Draw("Press {0} to decrease value", btnAct1Text);
		    Common_Draw("Press {0} to increase value", btnAct2Text);
		    Common_Draw("");
		    Common_Draw("Press {0} to quit", btnQuitText);

		    Common_Sleep(50);
		} while (!Common_BtnDown(.BTN_QUIT));

		ERRCHECK!(system.Release());
		Common_Close();
		return 0;
	}
}