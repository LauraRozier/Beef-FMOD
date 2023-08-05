# Beef-FMOD

[FMOD](https://www.fmod.com/) bindings for BeefLang

# Dependencies

To make the lib work you will need to obtain FMOD DLLs, you can do this by downloading the [FMOD Engine](https://www.fmod.com/download#fmodengine).  
After downloading and installing the API files you will will have to copy the following files:
- x86
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/api/core/lib/x86/fmod.dll to $(ProjectDir)/dist/win32/fmod.dll
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/api/fsbank/lib/x86/fsbank.dll to $(ProjectDir)/dist/win32/fsbank.dll
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/api/fsbank/lib/x86/libfsbvorbis.dll to $(ProjectDir)/dist/win32/libfsbvorbis.dll
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/api/fsbank/lib/x86/opus.dll to $(ProjectDir)/dist/win32/opus.dll
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/api/studio/lib/x86/fmodstudio.dll to $(ProjectDir)/dist/win32/fmodstudio.dll
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/plugins/resonance_audio/lib/x86/resonanceaudio.dll to $(ProjectDir)/dist/win32/resonanceaudio.dll
- x64
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/api/core/lib/x64/fmod.dll to $(ProjectDir)/dist/win64/fmod.dll
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/api/fsbank/lib/x64/fsbank.dll to $(ProjectDir)/dist/win64/fsbank.dll
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/api/fsbank/lib/x64/libfsbvorbis64.dll to $(ProjectDir)/dist/win64/libfsbvorbis64.dll
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/api/fsbank/lib/x64/opus.dll to $(ProjectDir)/dist/win64/opus.dll
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/api/studio/lib/x64/fmodstudio.dll to $(ProjectDir)/dist/win64/fmodstudio.dll
  - <FMOD Engine Install Dir>/FMOD Studio API Windows/plugins/resonance_audio/lib/x64/resonanceaudio.dll to $(ProjectDir)/dist/win64/resonanceaudio.dll

## Quick Start *(using Beef IDE)*

1. **Download** Beef-FMOD and copy it into BeefLibs inside your Beef IDE root directory.
3. In the Beef IDE, add Beef-FMOD to your workspace (Add From Installed)
4. In the Beef IDE, add Beef-FMOD to your project (Properties > Dependencies)
5. Have fun!
