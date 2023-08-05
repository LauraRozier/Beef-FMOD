namespace Beef_FMOD;

using System;

public struct FSBANK
{
#if BF_PLATFORM_WINDOWS
	#if BF_32_BIT || BF_64_BIT
		const String FSBANK_LIB = "fsbank.dll";
	#else
		#error Unsupported CPU
	#endif
#endif

	/*
	    FSBank types
	*/
	public enum INITFLAGS : uint32
	{
		NORMAL                = 0x00000000,
		IGNOREERRORS          = 0x00000001,
		WARNINGSASERRORS      = 0x00000002,
		CREATEINCLUDEHEADER   = 0x00000004,
		DONTLOADCACHEFILES    = 0x00000008,
		GENERATEPROGRESSITEMS = 0x00000010
	}

	public enum BUILDFLAGS: uint32
	{
		DEFAULT             = 0x00000000,
		DISABLESYNCPOINTS   = 0x00000001,
		DONTLOOP            = 0x00000002,
		FILTERHIGHFREQ      = 0x00000004,
		DISABLESEEKING      = 0x00000008,
		OPTIMIZESAMPLERATE  = 0x00000010,
		FSB5_DONTWRITENAMES = 0x00000080,
		NOGUID              = 0x00000100,
		WRITEPEAKVOLUME     = 0x00000200,

		OVERRIDE_MASK         = .DISABLESYNCPOINTS | .DONTLOOP | .FILTERHIGHFREQ | .DISABLESEEKING | .OPTIMIZESAMPLERATE | .WRITEPEAKVOLUME,
		CACHE_VALIDATION_MASK = .DONTLOOP | .FILTERHIGHFREQ | .OPTIMIZESAMPLERATE,
	}

	[CRepr]
	public enum RESULT : int32
	{
		OK,
		ErrCacheChunkNotFound,
		ErrCanceled,
		ErrCannotContinue,
		ErrEncoder,
		ErrEncoderInit,
		ErrEncoderNotSupported,
		ErrFileOS,
		ErrFileNotFound,
		ErrFMOD,
		ErrInitialized,
		ErrInvalidFormat,
		ErrInvalidParam,
		ErrMemory,
		ErrUninitialized,
		ErrWriterFormat,
		WarnCannotLoop,
		WarnIgnoredFilterHighFreq,
		WarnIgnoredDisableSeeking,
		WarnForcedDontWriteNames,
		ErrEncoderFileNotFound,
		ErrEncoderFileBad
	}

	[CRepr]
	public enum FORMAT : int32
	{
		PCM,
		XMA,
		AT9,
		VORBIS,
		FADPCM,
		OPUS,

		MAX
	}

	[CRepr]
	public enum FSBVERSION : int32
	{
		FSB5,

		MAX
	}

	[CRepr]
	public enum STATE : int32
	{
		DECODING,
		ANALYSING,
		PREPROCESSING,
		ENCODING,
		WRITING,
		FINISHED,
		FAILED,
		WARNING
	}

	[CRepr]
	public struct SUBSOUND
	{
		public char8*[]   Filenames;
		public void*[]    FileData;
		public uint32[]   FileDataLengths;
		public uint32     NumFiles;
		public BUILDFLAGS OverrideFlags;
		public uint32     OverrideQuality;
		public float      DesiredSampleRate;
		public float      PercentOptimizedRate;
	}

	[CRepr]
	public struct PROGRESSITEM
	{
		public int32 SubSoundIndex;
		public int32 ThreadIndex;
		public STATE State;
		public void* StateData;
	}

	[CRepr]
	public struct STATEDATA_FAILED
	{
		public RESULT     ErrorCode;
		public char8[256] ErrorString;
	}

	[CRepr]
	public struct STATEDATA_WARNING
	{
		public RESULT     WarnCode;
		public char8[256] WarningString;
	}

	[CallingConvention(.Stdcall)]
	public function void* MEMORY_ALLOC_CALLBACK(uint32 size, uint32 type, char8* sourceStr);
	[CallingConvention(.Stdcall)]
	public function void* MEMORY_REALLOC_CALLBACK(void* ptr, uint32 size, uint32 type, char8* sourceStr);
	[CallingConvention(.Stdcall)]
	public function void MEMORY_FREE_CALLBACK(void* ptr, uint32 type, char8* sourceStr);

	[Import(FSBANK_LIB), CLink, CallingConvention(.Stdcall)]
	public extern static RESULT FSBank_MemoryInit(MEMORY_ALLOC_CALLBACK userAlloc, MEMORY_REALLOC_CALLBACK userRealloc, MEMORY_FREE_CALLBACK userFree);
	[Import(FSBANK_LIB), CLink, CallingConvention(.Stdcall)]
	public extern static RESULT FSBank_Init(FSBVERSION version, INITFLAGS flags, uint32 numSimultaneousJobs, [MangleConst]char8* cacheDirectory);
	[Import(FSBANK_LIB), CLink, CallingConvention(.Stdcall)]
	public extern static RESULT FSBank_Release();
	[Import(FSBANK_LIB), CLink, CallingConvention(.Stdcall)]
	public extern static RESULT FSBank_Build([MangleConst]SUBSOUND* subsounds, uint32 numSubSounds, FORMAT encodeFormat, BUILDFLAGS buildFlags, uint32 quality, [MangleConst]char8* encryptKey, [MangleConst]char8* outputFileName);
	[Import(FSBANK_LIB), CLink, CallingConvention(.Stdcall)]
	public extern static RESULT FSBank_FetchFSBMemory([MangleConst]void** data, uint32* length);
	[Import(FSBANK_LIB), CLink, CallingConvention(.Stdcall)]
	public extern static RESULT FSBank_BuildCancel();
	[Import(FSBANK_LIB), CLink, CallingConvention(.Stdcall)]
	public extern static RESULT FSBank_FetchNextProgressItem([MangleConst]PROGRESSITEM** progressItem);
	[Import(FSBANK_LIB), CLink, CallingConvention(.Stdcall)]
	public extern static RESULT FSBank_ReleaseProgressItem([MangleConst]PROGRESSITEM* progressItem);
	[Import(FSBANK_LIB), CLink, CallingConvention(.Stdcall)]
	public extern static RESULT FSBank_MemoryGetStats(uint32* currentAllocated, uint32* maximumAllocated);

	public static void ErrorString(RESULT result, String outStr)
	{
		switch (result)
		{
		case .OK:                        outStr.Set("No errors.");
		case .ErrCacheChunkNotFound:     outStr.Set("An expected chunk is missing from the cache, perhaps try deleting cache files.");
		case .ErrCanceled:               outStr.Set("The build process was canceled during compilation by the user.");
		case .ErrCannotContinue:         outStr.Set("The build process cannot continue due to previously ignored errors.");
		case .ErrEncoder:                outStr.Set("Encoder for chosen format has encountered an unexpected error.");
		case .ErrEncoderInit:            outStr.Set("Encoder initialization failed.");
		case .ErrEncoderNotSupported:    outStr.Set("Encoder for chosen format is not supported on this platform.");
		case .ErrFileOS:                 outStr.Set("An operating system based file error was encountered.");
		case .ErrFileNotFound:           outStr.Set("A specified file could not be found.");
		case .ErrFMOD:                   outStr.Set("Internal error from FMOD sub-system.");
		case .ErrInitialized:            outStr.Set("Already initialized.");
		case .ErrInvalidFormat:          outStr.Set("The format of the source file is invalid.");
		case .ErrInvalidParam:           outStr.Set("An invalid parameter has been passed to this function.");
		case .ErrMemory:                 outStr.Set("Run out of memory.");
		case .ErrUninitialized:          outStr.Set("Not initialized yet.");
		case .ErrWriterFormat:           outStr.Set("Chosen encode format is not supported by this FSB version.");
		case .WarnCannotLoop:            outStr.Set("Source file is too short for seamless looping. Looping disabled.");
		case .WarnIgnoredFilterHighFreq: outStr.Set("FSBANK.BUILDFLAGS.FILTERHIGHFREQ flag ignored: feature only supported by XMA format.");
		case .WarnIgnoredDisableSeeking: outStr.Set("FSBANK.BUILDFLAGS.DISABLESEEKING flag ignored: feature only supported by XMA format.");
		case .WarnForcedDontWriteNames:  outStr.Set("FSBANK.BUILDFLAGS.FSB5_DONTWRITENAMES flag forced: cannot write names when source is from memory.");
		case .ErrEncoderFileNotFound:    outStr.Set("External encoder dynamic library not found.");
		case .ErrEncoderFileBad:         outStr.Set("External encoder dynamic library could not be loaded, possibly incorrect binary format, incorrect architecture, or file corruption.");
		default:                         outStr.Set("Unknown error.");
		}
	}
}