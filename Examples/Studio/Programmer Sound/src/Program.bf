namespace ProgrammerSound;

using Beef_FMOD;
using Common;
using System;

static class Program
{
	struct ProgrammerSoundContext
	{
	    public FMOD.System CoreSystem;
	    public FMOD_STUDIO.System System;
	    public StringView DialogueString;
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
	
	    // Available banks
	    uint32 bankIndex = 0;
	    StringView[3] banks = .( "Dialogue_EN.bank", "Dialogue_JP.bank", "Dialogue_CN.bank" );

		String bankFileLocalized = scope .();
	    FMOD_STUDIO.Bank localizedBank = .(null);
		Common_MediaPath(banks[bankIndex], bankFileLocalized);
	    ERRCHECK!(system.LoadBankFile(bankFileLocalized, .NORMAL, out localizedBank));
	
	    FMOD_STUDIO.EventDescription eventDescription = .(null);
	    ERRCHECK!(system.GetEvent("event:/Character/Dialogue", out eventDescription));
	
	    FMOD_STUDIO.EventInstance eventInstance = .(null);
	    ERRCHECK!(eventDescription.CreateInstance(out eventInstance));
	
	    // Dialogue keys available
	    // These keys are shared amongst all audio tables
	    uint32 dialogueIndex = 0;
	    StringView[3] dialogue = .( "welcome", "main menu", "goodbye" );
	
	    ProgrammerSoundContext programmerSoundContext;
	    programmerSoundContext.System = system;
	    programmerSoundContext.CoreSystem = coreSystem;
	    programmerSoundContext.DialogueString = dialogue[dialogueIndex];
	
	    ERRCHECK!(eventInstance.SetUserData(&programmerSoundContext));
	    ERRCHECK!(eventInstance.SetCallback(=> programmerSoundCallback, .CREATE_PROGRAMMER_SOUND | .DESTROY_PROGRAMMER_SOUND));

		String btnAct1Text = scope .();
		Common_BtnStr(.BTN_ACTION1, btnAct1Text);
		String btnAct2Text = scope .();
		Common_BtnStr(.BTN_ACTION2, btnAct2Text);
		String btnMoreText = scope .();
		Common_BtnStr(.BTN_MORE, btnMoreText);
		String btnQuitText = scope .();
		Common_BtnStr(.BTN_QUIT, btnQuitText);
	
	    repeat
	    {
	        Common_Update();
	
	        if (Common_BtnDown(.BTN_ACTION1))
	        {
	            ERRCHECK!(localizedBank.Unload());
	
	            bankIndex = (bankIndex < 2) ? bankIndex + 1 : 0;
				Common_MediaPath(banks[bankIndex], bankFileLocalized);
	            ERRCHECK!(system.LoadBankFile(bankFileLocalized, .NORMAL, out localizedBank));
	        }
	
	        if (Common_BtnDown(.BTN_ACTION2))
	        {
	            dialogueIndex = (dialogueIndex < 2) ? dialogueIndex + 1 : 0;
	            programmerSoundContext.DialogueString = dialogue[dialogueIndex];
	        }
	
	        if (Common_BtnDown(.BTN_MORE))
	            ERRCHECK!(eventInstance.Start());
	
	        ERRCHECK!(system.Update());
	
	        Common_Draw("==================================================");
	        Common_Draw("Programmer Sound Example.");
	        Common_Draw("Copyright (c) Firelight Technologies 2012-2023.");
	        Common_Draw("==================================================");
	        Common_Draw("");
	        Common_Draw("Press {0} to change language", btnAct1Text);
	        Common_Draw("Press {0} to change dialogue", btnAct2Text);
	        Common_Draw("Press {0} to play the event",  btnMoreText);
	        Common_Draw("");
	        Common_Draw("Language:");
	        Common_Draw("  {0} English",  bankIndex == 0 ? ">" : " ");
	        Common_Draw("  {0} Japanese", bankIndex == 1 ? ">" : " ");
	        Common_Draw("  {0} Chinese",  bankIndex == 2 ? ">" : " ");
	        Common_Draw("");
	        Common_Draw("Dialogue:");
	        Common_Draw("  {0} Welcome to the FMOD Studio tutorial", dialogueIndex == 0 ? ">" : " ");
	        Common_Draw("  {0} This is the main menu",               dialogueIndex == 1 ? ">" : " ");
	        Common_Draw("  {0} Goodbye",                             dialogueIndex == 2 ? ">" : " ");
	        Common_Draw("");
	        Common_Draw("Press {0} to quit", btnQuitText);
	
	        Common_Sleep(50);
	    } while (!Common_BtnDown(.BTN_QUIT));
	
	    ERRCHECK!(system.Release());
	    Common_Close();
		return 0;
	}

	static mixin CHECK_RESULT(FMOD.RESULT res)
    {
        if (res != .OK)
            return res;
    }

	static FMOD.RESULT programmerSoundCallback(FMOD_STUDIO.EVENT_CALLBACK_TYPE type, void* event, void* parameters)
	{
	    FMOD_STUDIO.EventInstance eventInstance = .(event);

	    if (type == .CREATE_PROGRAMMER_SOUND)
	    {
	        FMOD_STUDIO.PROGRAMMER_SOUND_PROPERTIES* props = (FMOD_STUDIO.PROGRAMMER_SOUND_PROPERTIES*)parameters;

	        // Get our context from the event instance user data
			void* contextPtr = null;
	        CHECK_RESULT!(eventInstance.GetUserData(out contextPtr));
	        ProgrammerSoundContext* context = (ProgrammerSoundContext*)contextPtr;

	        // Find the audio file in the audio table with the key
	        FMOD_STUDIO.SOUND_INFO info;
	        CHECK_RESULT!(context.System.GetSoundInfo(context.DialogueString, out info));

	        FMOD.Sound sound = .(null);
	        CHECK_RESULT!(context.CoreSystem.CreateSound(info.NameOrData, .LOOP_NORMAL | .CREATECOMPRESSEDSAMPLE | .NONBLOCKING | info.Mode, ref info.ExInfo, out sound));

	        // Pass the sound to FMOD
	        props.Sound = sound.handle;
	        props.SubSoundIndex = info.SubSoundIndex;
	    }
	    else if (type == .DESTROY_PROGRAMMER_SOUND)
	    {
	        FMOD_STUDIO.PROGRAMMER_SOUND_PROPERTIES* props = (FMOD_STUDIO.PROGRAMMER_SOUND_PROPERTIES*)parameters;
	        // Obtain the sound
	        FMOD.Sound sound = .(props.Sound);
	        // Release the sound
	        CHECK_RESULT!(sound.Release());
	    }

	    return .OK;
	}
}