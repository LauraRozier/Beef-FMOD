/* ======================================================================================== */
/* FMOD Core API - C header file.                                                           */
/* Copyright (c), Firelight Technologies Pty, Ltd. 2004-2023.                               */
/*                                                                                          */
/* Use this header in conjunction with fmod_common.h (which contains all the constants /    */
/* callbacks) to develop using the C interface                                              */
/*                                                                                          */
/* For more detail visit:                                                                   */
/* https://fmod.com/docs/2.02/api/core-api.html                                             */
/* ======================================================================================== */
namespace Beef_FMOD;

using System;

public struct FMOD
{
    public struct VERSION
    {
		/// 0xaaaabbcc -> aaaa = product version, bb = major version, cc = minor version.
        public const int32 Number = 0x00020216;
		
#if BF_PLATFORM_WINDOWS
		#if BF_32_BIT || BF_64_BIT
			public const String DLL = "fmod.dll";
		#else
			#error Unsupported CPU
		#endif
#endif
    }

	public const uint32 MAX_CHANNEL_WIDTH   = 32;
	public const uint32 MAX_SYSTEMS         = 8;
	public const uint32 MAX_LISTENERS       = 8;
	public const uint32 REVERB_MAXINSTANCES = 4;

    public enum DEBUG_FLAGS : uint32
    {
        NONE                    = 0x00000000,
        ERROR                   = 0x00000001,
        WARNING                 = 0x00000002,
        LOG                     = 0x00000004,

        TYPE_MEMORY             = 0x00000100,
        TYPE_FILE               = 0x00000200,
        TYPE_CODEC              = 0x00000400,
        TYPE_TRACE              = 0x00000800,

        DISPLAY_TIMESTAMPS      = 0x00010000,
        DISPLAY_LINENUMBERS     = 0x00020000,
        DISPLAY_THREAD          = 0x00040000
    }

    public enum MEMORY_TYPE : uint32
    {
        NORMAL                  = 0x00000000,
        STREAM_FILE             = 0x00000001,
        STREAM_DECODE           = 0x00000002,
        SAMPLEDATA              = 0x00000004,
        DSP_BUFFER              = 0x00000008,
        PLUGIN                  = 0x00000010,
        PERSISTENT              = 0x00200000,
        ALL                     = 0xFFFFFFFF
    }

    public enum INITFLAGS : uint32
    {
        NORMAL                     = 0x00000000,
        STREAM_FROM_UPDATE         = 0x00000001,
        MIX_FROM_UPDATE            = 0x00000002,
        _3D_RIGHTHANDED            = 0x00000004,
        CLIP_OUTPUT                = 0x00000008,
        CHANNEL_LOWPASS            = 0x00000100,
        CHANNEL_DISTANCEFILTER     = 0x00000200,
        PROFILE_ENABLE             = 0x00010000,
        VOL0_BECOMES_VIRTUAL       = 0x00020000,
        GEOMETRY_USECLOSEST        = 0x00040000,
        PREFER_DOLBY_DOWNMIX       = 0x00080000,
        THREAD_UNSAFE              = 0x00100000,
        PROFILE_METER_ALL          = 0x00200000,
        MEMORY_TRACKING            = 0x00400000
	}

    public enum DRIVER_STATE : uint32
    {
        CONNECTED = 0x00000001,
        DEFAULT   = 0x00000002,
    }

    public enum TIMEUNIT : uint32
    {
        MS          = 0x00000001,
        PCM         = 0x00000002,
        PCMBYTES    = 0x00000004,
        RAWBYTES    = 0x00000008,
        PCMFRACTION = 0x00000010,
        MODORDER    = 0x00000100,
        MODROW      = 0x00000200,
        MODPATTERN  = 0x00000400
    }

    public enum SYSTEM_CALLBACK_TYPE : uint32
    {
        DEVICELISTCHANGED      = 0x00000001,
        DEVICELOST             = 0x00000002,
        MEMORYALLOCATIONFAILED = 0x00000004,
        THREADCREATED          = 0x00000008,
        BADDSPCONNECTION       = 0x00000010,
        PREMIX                 = 0x00000020,
        POSTMIX                = 0x00000040,
        ERROR                  = 0x00000080,
        MIDMIX                 = 0x00000100,
        THREADDESTROYED        = 0x00000200,
        PREUPDATE              = 0x00000400,
        POSTUPDATE             = 0x00000800,
        RECORDLISTCHANGED      = 0x00001000,
        BUFFEREDNOMIX          = 0x00002000,
        DEVICEREINITIALIZE     = 0x00004000,
        OUTPUTUNDERRUN         = 0x00008000,
        RECORDPOSITIONCHANGED  = 0x00010000,
        ALL                    = 0xFFFFFFFF,
    }

    public enum MODE : uint32
    {
        DEFAULT                   = 0x00000000,
        LOOP_OFF                  = 0x00000001,
        LOOP_NORMAL               = 0x00000002,
        LOOP_BIDI                 = 0x00000004,
        _2D                       = 0x00000008,
        _3D                       = 0x00000010,
        CREATESTREAM              = 0x00000080,
        CREATESAMPLE              = 0x00000100,
        CREATECOMPRESSEDSAMPLE    = 0x00000200,
        OPENUSER                  = 0x00000400,
        OPENMEMORY                = 0x00000800,
        OPENMEMORY_POINT          = 0x10000000,
        OPENRAW                   = 0x00001000,
        OPENONLY                  = 0x00002000,
        ACCURATETIME              = 0x00004000,
        MPEGSEARCH                = 0x00008000,
        NONBLOCKING               = 0x00010000,
        UNIQUE                    = 0x00020000,
        _3D_HEADRELATIVE          = 0x00040000,
        _3D_WORLDRELATIVE         = 0x00080000,
        _3D_INVERSEROLLOFF        = 0x00100000,
        _3D_LINEARROLLOFF         = 0x00200000,
        _3D_LINEARSQUAREROLLOFF   = 0x00400000,
        _3D_INVERSETAPEREDROLLOFF = 0x00800000,
        _3D_CUSTOMROLLOFF         = 0x04000000,
        _3D_IGNOREGEOMETRY        = 0x40000000,
        IGNORETAGS                = 0x02000000,
        LOWMEM                    = 0x08000000,
        VIRTUAL_PLAYFROMSTART     = 0x80000000
    }

	[AllowDuplicates]
    public enum CHANNELMASK : uint32
    {
        FRONT_LEFT             = 0x00000001,
        FRONT_RIGHT            = 0x00000002,
        FRONT_CENTER           = 0x00000004,
        LOW_FREQUENCY          = 0x00000008,
        SURROUND_LEFT          = 0x00000010,
        SURROUND_RIGHT         = 0x00000020,
        BACK_LEFT              = 0x00000040,
        BACK_RIGHT             = 0x00000080,
        BACK_CENTER            = 0x00000100,

        MONO                   = .FRONT_LEFT,
        STEREO                 = .FRONT_LEFT | .FRONT_RIGHT,
        LRC                    = .FRONT_LEFT | .FRONT_RIGHT | .FRONT_CENTER,
        QUAD                   = .FRONT_LEFT | .FRONT_RIGHT | .SURROUND_LEFT | .SURROUND_RIGHT,
        SURROUND               = .FRONT_LEFT | .FRONT_RIGHT | .FRONT_CENTER  | .SURROUND_LEFT  | .SURROUND_RIGHT,
        _5POINT1               = .FRONT_LEFT | .FRONT_RIGHT | .FRONT_CENTER  | .LOW_FREQUENCY  | .SURROUND_LEFT  | .SURROUND_RIGHT,
        _5POINT1_REARS         = .FRONT_LEFT | .FRONT_RIGHT | .FRONT_CENTER  | .LOW_FREQUENCY  | .BACK_LEFT      | .BACK_RIGHT,
        _7POINT0               = .FRONT_LEFT | .FRONT_RIGHT | .FRONT_CENTER  | .SURROUND_LEFT  | .SURROUND_RIGHT | .BACK_LEFT      | .BACK_RIGHT,
        _7POINT1               = .FRONT_LEFT | .FRONT_RIGHT | .FRONT_CENTER  | .LOW_FREQUENCY  | .SURROUND_LEFT  | .SURROUND_RIGHT | .BACK_LEFT  | .BACK_RIGHT
    }

	public enum PORT_INDEX : uint64
	{
	    NONE               = 0xFFFFFFFFFFFFFFFF,
	    FLAG_VR_CONTROLLER = 0x1000000000000000
	}

	[AllowDuplicates]
	public enum THREAD_PRIORITY : int32
	{
        /* Platform specific priority range */
        PLATFORM_MIN        = -32 * 1024,
        PLATFORM_MAX        =  32 * 1024,

        /* Platform agnostic priorities, maps internally to platform specific value */
        DEFAULT             = PLATFORM_MIN - 1,
        LOW                 = PLATFORM_MIN - 2,
        MEDIUM              = PLATFORM_MIN - 3,
        HIGH                = PLATFORM_MIN - 4,
        VERY_HIGH           = PLATFORM_MIN - 5,
        EXTREME             = PLATFORM_MIN - 6,
        CRITICAL            = PLATFORM_MIN - 7,

        /* Thread defaults */
        MIXER               = .EXTREME,
        FEEDER              = .CRITICAL,
        STREAM              = .VERY_HIGH,
        FILE                = .HIGH,
        NONBLOCKING         = .HIGH,
        RECORD              = .HIGH,
        GEOMETRY            = .LOW,
        PROFILER            = .MEDIUM,
        STUDIO_UPDATE       = .MEDIUM,
        STUDIO_LOAD_BANK    = .MEDIUM,
        STUDIO_LOAD_SAMPLE  = .MEDIUM,
        CONVOLUTION1        = .VERY_HIGH,
        CONVOLUTION2        = .VERY_HIGH
	}

	[AllowDuplicates]
	public enum THREAD_STACK_SIZE : uint32
	{
        DEFAULT             = 0,
        MIXER               = 80  * 1024,
        FEEDER              = 16  * 1024,
        STREAM              = 96  * 1024,
        FILE                = 64  * 1024,
        NONBLOCKING         = 112 * 1024,
        RECORD              = 16  * 1024,
        GEOMETRY            = 48  * 1024,
        PROFILER            = 128 * 1024,
        STUDIO_UPDATE       = 96  * 1024,
        STUDIO_LOAD_BANK    = 96  * 1024,
        STUDIO_LOAD_SAMPLE  = 96  * 1024,
        CONVOLUTION1        = 16  * 1024,
        CONVOLUTION2        = 16  * 1024
	}

	[AllowDuplicates]
	public enum THREAD_AFFINITY : uint64
	{
        /* Platform agnostic thread groupings */
        GROUP_DEFAULT       = 0x4000000000000000,
        GROUP_A             = 0x4000000000000001,
        GROUP_B             = 0x4000000000000002,
        GROUP_C             = 0x4000000000000003,

        /* Thread defaults */
        MIXER               = .GROUP_A,
        FEEDER              = .GROUP_C,
        STREAM              = .GROUP_C,
        FILE                = .GROUP_C,
        NONBLOCKING         = .GROUP_C,
        RECORD              = .GROUP_C,
        GEOMETRY            = .GROUP_C,
        PROFILER            = .GROUP_C,
        STUDIO_UPDATE       = .GROUP_B,
        STUDIO_LOAD_BANK    = .GROUP_C,
        STUDIO_LOAD_SAMPLE  = .GROUP_C,
        CONVOLUTION1        = .GROUP_C,
        CONVOLUTION2        = .GROUP_C,

        /* Core mask, valid up to 1 << 61 */
        CORE_ALL            = 0,
        CORE_0              = 1 << 0,
        CORE_1              = 1 << 1,
        CORE_2              = 1 << 2,
        CORE_3              = 1 << 3,
        CORE_4              = 1 << 4,
        CORE_5              = 1 << 5,
        CORE_6              = 1 << 6,
        CORE_7              = 1 << 7,
        CORE_8              = 1 << 8,
        CORE_9              = 1 << 9,
        CORE_10             = 1 << 10,
        CORE_11             = 1 << 11,
        CORE_12             = 1 << 12,
        CORE_13             = 1 << 13,
        CORE_14             = 1 << 14,
        CORE_15             = 1 << 15
	}

	public enum THREAD_TYPE : int32
	{
        MIXER,
        FEEDER,
        STREAM,
        FILE,
        NONBLOCKING,
        RECORD,
        GEOMETRY,
        PROFILER,
        STUDIO_UPDATE,
        STUDIO_LOAD_BANK,
        STUDIO_LOAD_SAMPLE,
        CONVOLUTION1,
        CONVOLUTION2,
        MAX
	}

	public enum RESULT : int32
	{
	    OK,
		ERR_BADCOMMAND,
		ERR_CHANNEL_ALLOC,
		ERR_CHANNEL_STOLEN,
		ERR_DMA,
		ERR_DSP_CONNECTION,
		ERR_DSP_DONTPROCESS,
		ERR_DSP_FORMAT,
		ERR_DSP_INUSE,
		ERR_DSP_NOTFOUND,
		ERR_DSP_RESERVED,
		ERR_DSP_SILENCE,
		ERR_DSP_TYPE,
		ERR_FILE_BAD,
		ERR_FILE_COULDNOTSEEK,
		ERR_FILE_DISKEJECTED,
		ERR_FILE_EOF,
		ERR_FILE_ENDOFDATA,
		ERR_FILE_NOTFOUND,
		ERR_FORMAT,
		ERR_HEADER_MISMATCH,
		ERR_HTTP,
		ERR_HTTP_ACCESS,
		ERR_HTTP_PROXY_AUTH,
		ERR_HTTP_SERVER_ERROR,
		ERR_HTTP_TIMEOUT,
		ERR_INITIALIZATION,
		ERR_INITIALIZED,
		ERR_INTERNAL,
		ERR_INVALID_FLOAT,
		ERR_INVALID_HANDLE,
		ERR_INVALID_PARAM,
		ERR_INVALID_POSITION,
		ERR_INVALID_SPEAKER,
		ERR_INVALID_SYNCPOINT,
		ERR_INVALID_THREAD,
		ERR_INVALID_VECTOR,
		ERR_MAXAUDIBLE,
		ERR_MEMORY,
		ERR_MEMORY_CANTPOINT,
		ERR_NEEDS3D,
		ERR_NEEDSHARDWARE,
		ERR_NET_CONNECT,
		ERR_NET_SOCKET_ERROR,
		ERR_NET_URL,
		ERR_NET_WOULD_BLOCK,
		ERR_NOTREADY,
		ERR_OUTPUT_ALLOCATED,
		ERR_OUTPUT_CREATEBUFFER,
		ERR_OUTPUT_DRIVERCALL,
		ERR_OUTPUT_FORMAT,
		ERR_OUTPUT_INIT,
		ERR_OUTPUT_NODRIVERS,
		ERR_PLUGIN,
		ERR_PLUGIN_MISSING,
		ERR_PLUGIN_RESOURCE,
		ERR_PLUGIN_VERSION,
		ERR_RECORD,
		ERR_REVERB_CHANNELGROUP,
		ERR_REVERB_INSTANCE,
		ERR_SUBSOUNDS,
		ERR_SUBSOUND_ALLOCATED,
		ERR_SUBSOUND_CANTMOVE,
		ERR_TAGNOTFOUND,
		ERR_TOOMANYCHANNELS,
		ERR_TRUNCATED,
		ERR_UNIMPLEMENTED,
		ERR_UNINITIALIZED,
		ERR_UNSUPPORTED,
		ERR_VERSION,
		ERR_EVENT_ALREADY_LOADED,
		ERR_EVENT_LIVEUPDATE_BUSY,
		ERR_EVENT_LIVEUPDATE_MISMATCH,
		ERR_EVENT_LIVEUPDATE_TIMEOUT,
		ERR_EVENT_NOTFOUND,
		ERR_STUDIO_UNINITIALIZED,
		ERR_STUDIO_NOT_LOADED,
		ERR_INVALID_STRING,
		ERR_ALREADY_LOCKED,
		ERR_NOT_LOCKED,
		ERR_RECORD_DISCONNECTED,
		ERR_TOOMANYSAMPLES
	}

	public enum CHANNELCONTROL_TYPE : int32
	{
        CHANNEL,
        CHANNELGROUP,
        MAX
	}

	public enum OUTPUTTYPE : int32
	{
        AUTODETECT,

        UNKNOWN,
        NOSOUND,
        WAVWRITER,
        NOSOUND_NRT,
        WAVWRITER_NRT,

        WASAPI,
        ASIO,
        PULSEAUDIO,
        ALSA,
        COREAUDIO,
        AUDIOTRACK,
        OPENSL,
        AUDIOOUT,
        AUDIO3D,
        WEBAUDIO,
        NNAUDIO,
        WINSONIC,
        AAUDIO,
        AUDIOWORKLET,
        PHASE,

        MAX
	}

	public enum DEBUG_MODE : int32
	{
        TTY,
        FILE,
        CALLBACK
	}

	public enum SPEAKERMODE : int32
	{
        DEFAULT,
        RAW,
        MONO,
        STEREO,
        QUAD,
        SURROUND,
        _5POINT1,
        _7POINT1,
        _7POINT1POINT4,

        MAX
	}

	public enum SPEAKER : int32
	{
        NONE = -1,
        FRONT_LEFT,
        FRONT_RIGHT,
        FRONT_CENTER,
        LOW_FREQUENCY,
        SURROUND_LEFT,
        SURROUND_RIGHT,
        BACK_LEFT,
        BACK_RIGHT,
        TOP_FRONT_LEFT,
        TOP_FRONT_RIGHT,
        TOP_BACK_LEFT,
        TOP_BACK_RIGHT,

        MAX
	}

	public enum CHANNELORDER : int32
	{
        DEFAULT,
        WAVEFORMAT,
        PROTOOLS,
        ALLMONO,
        ALLSTEREO,
        ALSA,

        MAX
	}

	public enum PLUGINTYPE : int32
	{
        OUTPUT,
        CODEC,
        DSP,

        MAX
	}

	public enum SOUND_TYPE : int32
	{
        UNKNOWN,
        AIFF,
        ASF,
        DLS,
        FLAC,
        FSB,
        IT,
        MIDI,
        MOD,
        MPEG,
        OGGVORBIS,
        PLAYLIST,
        RAW,
        S3M,
        USER,
        WAV,
        XM,
        XMA,
        AUDIOQUEUE,
        AT9,
        VORBIS,
        MEDIA_FOUNDATION,
        MEDIACODEC,
        FADPCM,
        OPUS,

        MAX
	}

	public enum SOUND_FORMAT : int32
	{
        NONE,
        PCM8,
        PCM16,
        PCM24,
        PCM32,
        PCMFLOAT,
        BITSTREAM,

        MAX
	}

	public enum OPENSTATE : int32
	{
        READY = 0,
        LOADING,
        ERROR,
        CONNECTING,
        BUFFERING,
        SEEKING,
        PLAYING,
        SETPOSITION,

        MAX
	}

	public enum SOUNDGROUP_BEHAVIOR : int32
	{
        BEHAVIOR_FAIL,
        BEHAVIOR_MUTE,
        BEHAVIOR_STEALLOWEST,

        MAX
	}

	public enum CHANNELCONTROL_CALLBACK_TYPE : int32
	{
        END,
        VIRTUALVOICE,
        SYNCPOINT,
        OCCLUSION,

        MAX
	}

	public enum CHANNELCONTROL_DSP_INDEX : int32
	{
		HEAD  = -1,
		FADER = -2,
		TAIL  = -3
	}

	public enum ERRORCALLBACK_INSTANCETYPE : int32
	{
        NONE,
        SYSTEM,
        CHANNEL,
        CHANNELGROUP,
        CHANNELCONTROL,
        SOUND,
        SOUNDGROUP,
        DSP,
        DSPCONNECTION,
        GEOMETRY,
        REVERB3D,
        STUDIO_SYSTEM,
        STUDIO_EVENTDESCRIPTION,
        STUDIO_EVENTINSTANCE,
        STUDIO_PARAMETERINSTANCE,
        STUDIO_BUS,
        STUDIO_VCA,
        STUDIO_BANK,
        STUDIO_COMMANDREPLAY
	}

	public enum DSP_RESAMPLER : int32
	{
        DEFAULT,
        NOINTERP,
        LINEAR,
        CUBIC,
        SPLINE,

        MAX
	}

	public enum DSP_CALLBACK_TYPE : int32
	{
        DATAPARAMETERRELEASE,

        MAX
	}

	public enum DSPCONNECTION_TYPE : int32
	{
        STANDARD,
        SIDECHAIN,
        SEND,
        SEND_SIDECHAIN,

        MAX
	}

	public enum TAGTYPE : int32
	{
        UNKNOWN = 0,
        ID3V1,
        ID3V2,
        VORBISCOMMENT,
        SHOUTCAST,
        ICECAST,
        ASF,
        MIDI,
        PLAYLIST,
        FMOD,
        USER,

        MAX
	}

	public enum TAGDATATYPE : int32
	{
        BINARY = 0,
        INT,
        FLOAT,
        STRING,
        STRING_UTF16,
        STRING_UTF16BE,
        STRING_UTF8,

        MAX
	}

	public enum PORT_TYPE : int32
	{
        MUSIC,
        COPYRIGHT_MUSIC,
        VOICE,
        CONTROLLER,
        PERSONAL,
        VIBRATION,
        AUX,

        MAX
	}

	/*
	    FMOD callbacks
	*/
	[CallingConvention(.Stdcall)]
	public function RESULT DEBUG_CALLBACK(DEBUG_FLAGS flags, [MangleConst]char8* file, int32 line, [MangleConst]char8* func, [MangleConst]char8* message);
	[CallingConvention(.Stdcall)]
	public function RESULT SYSTEM_CALLBACK(void* system, SYSTEM_CALLBACK_TYPE type, void* commandData1, void* commandData2, void* userData);
	[CallingConvention(.Stdcall)]
	public function RESULT CHANNELCONTROL_CALLBACK(void* channelControl, CHANNELCONTROL_TYPE controlType, CHANNELCONTROL_CALLBACK_TYPE callbackType, void* commandData1, void* commandData2);
	[CallingConvention(.Stdcall)]
	public function RESULT DSP_CALLBACK(void* dsp, DSP_CALLBACK_TYPE type, void* data);
	[CallingConvention(.Stdcall)]
	public function RESULT SOUND_NONBLOCK_CALLBACK(void* sound, RESULT result);
	[CallingConvention(.Stdcall)]
	public function RESULT SOUND_PCMREAD_CALLBACK(void* sound, void* data, uint32 dataLen);
	[CallingConvention(.Stdcall)]
	public function RESULT SOUND_PCMSETPOS_CALLBACK(void* sound, int32 subSound, uint32 position, TIMEUNIT posType);
	[CallingConvention(.Stdcall)]
	public function RESULT FILE_OPEN_CALLBACK([MangleConst]char8* name, uint32* fileSize, void** handle, void* userData);
	[CallingConvention(.Stdcall)]
	public function RESULT FILE_CLOSE_CALLBACK(void* handle, void* userData);
	[CallingConvention(.Stdcall)]
	public function RESULT FILE_READ_CALLBACK(void* handle, void* buffer, uint32 sizeBytes, uint32* bytesRead, void* userData);
	[CallingConvention(.Stdcall)]
	public function RESULT FILE_SEEK_CALLBACK(void* handle, uint32 pos, void* userData);
	[CallingConvention(.Stdcall)]
	public function RESULT FILE_ASYNCREAD_CALLBACK(void* info, void* userData);
	[CallingConvention(.Stdcall)]
	public function RESULT FILE_ASYNCCANCEL_CALLBACK(void* info, void* userData);
	[CallingConvention(.Stdcall)]
	public function void FILE_ASYNCDONE_FUNC(void* info, RESULT result);
	[CallingConvention(.Stdcall)]
	public function void* MEMORY_ALLOC_CALLBACK(uint32 size, MEMORY_TYPE type, [MangleConst]char8* sourceStr);
	[CallingConvention(.Stdcall)]
	public function void* MEMORY_REALLOC_CALLBACK(void* ptr, uint32 size, MEMORY_TYPE type, [MangleConst]char8* sourceStr);
	[CallingConvention(.Stdcall)]
	public function void MEMORY_FREE_CALLBACK(void* ptr, MEMORY_TYPE type, [MangleConst]char8* sourceStr);
	[CallingConvention(.Stdcall)]
	public function float CB_3D_ROLLOFF_CALLBACK(void* channelControl, float distance);

	/*
	    FMOD structs
	*/
	[CRepr]
	public struct ASYNCREADINFO
	{
		public void*               Handle;
		public uint32              Offset;
		public uint32              SizeBytes;
		public int32               Priority;
		public void*               UserData;
		public void*               Buffer;
		public uint32              BytesRead;
		public FILE_ASYNCDONE_FUNC Done;
	}

	[CRepr]
	public struct VECTOR
	{
		public float X;
		public float Y;
		public float Z;
	}

	[CRepr]
	public struct ATTRIBUTES_3D
	{
		public VECTOR Position;
		public VECTOR Velocity;
		public VECTOR Forward;
		public VECTOR Up;
	}

	[CRepr]
	public struct GUID
	{
		public uint32   Data1;
		public uint16   Data2;
		public uint16   Data3;
		public uint8[8] Data4;
	}

	[CRepr]
	public struct PLUGINLIST
	{
		public PLUGINTYPE Type;
		public void*      Description;
	}

	[CRepr]
	public struct ADVANCEDSETTINGS
	{
		public int32         CbSize;
		public int32         MaxMPEGCodecs;
		public int32         MaxADPCMCodecs;
		public int32         MaxXMACCodecs;
		public int32         MaxVorbisCodecs;
		public int32         MaxAT9Codecs;
		public int32         MaxFADPCMCodecs;
		public int32         MaxPCMCodecs;
		public int32         ASIONumChannels;
		public char8*[]      ASIOChannelList;
		public SPEAKER[]     ASIOSpeakerList;
		public float         Vol0VirtualVol;
		public uint32        DefaultDecodeBufferSize;
		public uint16        ProfilePort;
		public uint32        GeometryMaxFadeTime;
		public float         DistanceFilterCenterFreq;
		public int32         Reverb3DInstance;
		public int32         DSPBufferPoolSize;
		public DSP_RESAMPLER ResamplerMethod;
		public uint32        RandomSeed;
		public int32         MaxConvolutionThreads;
		public int32         MaxOpusCodecs;
	}

	[CRepr]
	public struct TAG
	{
		public TAGTYPE     Type;
		public TAGDATATYPE DataType;
		public char8*      Name;
		public void*       Data;
		public uint32      DataLen;
		public bool        Updated;
	}

	[CRepr]
	public struct CREATESOUNDEXINFO
	{
		public int32                     CbSize;
		public uint32                    Length;
		public uint32                    FileOffset;
		public int32                     NumChannels;
		public int32                     DefaultFrequency;
		public SOUND_FORMAT              Format;
		public uint32                    DecodeBufferSize;
		public int32                     InitialSubSound;
		public int32                     NumSubSounds;
		public int32*                    InclusionList;
		public int32                     InclusionListNum;
		public SOUND_PCMREAD_CALLBACK    PCMReadCallback_internal;
		private void*                    PCMSetPosCallback_internal;
		private void*                    PCMNonBlockingCallback_internal;
		public char8*                    DlsName;
		public char8*                    EncryptionKey;
		public int32                     MaxPolyphony;
		public void*                     UserData;
		public SOUND_TYPE                SuggestedSoundType;
		private void*                    FileUserOpen_internal;
		private void*                    FileUserClose_internal;
		private void*                    FileUserRead_internal;
		private void*                    FileUserSeek_internal;
		private void*                    FileUserAsyncRead_internal;
		private void*                    FileUserAsyncCancel_internal;
		public void*                     FileUserData;
		public int32                     FileBufferSize;
		public CHANNELORDER              ChannelOrder;
		public void*                     InitialSoundGroup;
		public uint32                    InitialSeekPosition;
		public TIMEUNIT                  InitialSeekPosType;
		public int32                     IgnoreSetFileSystem;
		public uint32                    AudioQueuePolicy;
		public uint32                    MinMIDIGranularity;
		public int32                     NonBlockThreadId;
		public GUID*                     FSBGuid;
	}

	[CRepr]
	public struct REVERB_PROPERTIES
	{
	    public float DecayTime;
	    public float EarlyDelay;
	    public float LateDelay;
	    public float HFReference;
	    public float HFDecayRatio;
	    public float Diffusion;
	    public float Density;
	    public float LowShelfFrequency;
	    public float LowShelfGain;
	    public float HighCut;
	    public float EarlyLateMix;
	    public float WetLevel;

		public this(float decayTime, float earlyDelay, float lateDelay, float hfReference,
            float hfDecayRatio, float diffusion, float density, float lowShelfFrequency, float lowShelfGain,
            float highCut, float earlyLateMix, float wetLevel)
		{
            DecayTime = decayTime;
            EarlyDelay = earlyDelay;
            LateDelay = lateDelay;
            HFReference = hfReference;
            HFDecayRatio = hfDecayRatio;
            Diffusion = diffusion;
            Density = density;
            LowShelfFrequency = lowShelfFrequency;
            LowShelfGain = lowShelfGain;
            HighCut = highCut;
            EarlyLateMix = earlyLateMix;
            WetLevel = wetLevel;
		}

		/* Preset for REVERB_PROPERTIES */
		public static REVERB_PROPERTIES OFF()              => .(  1000,    7,  11, 5000, 100, 100, 100, 250, 0,    20,  96, -80.0f );
		public static REVERB_PROPERTIES GENERIC()          => .(  1500,    7,  11, 5000,  83, 100, 100, 250, 0, 14500,  96,  -8.0f );
		public static REVERB_PROPERTIES PADDEDCELL()       => .(   170,    1,   2, 5000,  10, 100, 100, 250, 0,   160,  84,  -7.8f );
		public static REVERB_PROPERTIES ROOM()             => .(   400,    2,   3, 5000,  83, 100, 100, 250, 0,  6050,  88,  -9.4f );
		public static REVERB_PROPERTIES BATHROOM()         => .(  1500,    7,  11, 5000,  54, 100,  60, 250, 0,  2900,  83,   0.5f );
		public static REVERB_PROPERTIES LIVINGROOM()       => .(   500,    3,   4, 5000,  10, 100, 100, 250, 0,   160,  58, -19.0f );
		public static REVERB_PROPERTIES STONEROOM()        => .(  2300,   12,  17, 5000,  64, 100, 100, 250, 0,  7800,  71,  -8.5f );
		public static REVERB_PROPERTIES AUDITORIUM()       => .(  4300,   20,  30, 5000,  59, 100, 100, 250, 0,  5850,  64, -11.7f );
		public static REVERB_PROPERTIES CONCERTHALL()      => .(  3900,   20,  29, 5000,  70, 100, 100, 250, 0,  5650,  80,  -9.8f );
		public static REVERB_PROPERTIES CAVE()             => .(  2900,   15,  22, 5000, 100, 100, 100, 250, 0, 20000,  59, -11.3f );
		public static REVERB_PROPERTIES ARENA()            => .(  7200,   20,  30, 5000,  33, 100, 100, 250, 0,  4500,  80,  -9.6f );
		public static REVERB_PROPERTIES HANGAR()           => .( 10000,   20,  30, 5000,  23, 100, 100, 250, 0,  3400,  72,  -7.4f );
		public static REVERB_PROPERTIES CARPETTEDHALLWAY() => .(   300,    2,  30, 5000,  10, 100, 100, 250, 0,   500,  56, -24.0f );
		public static REVERB_PROPERTIES HALLWAY()          => .(  1500,    7,  11, 5000,  59, 100, 100, 250, 0,  7800,  87,  -5.5f );
		public static REVERB_PROPERTIES STONECORRIDOR()    => .(   270,   13,  20, 5000,  79, 100, 100, 250, 0,  9000,  86,  -6.0f );
		public static REVERB_PROPERTIES ALLEY()            => .(  1500,    7,  11, 5000,  86, 100, 100, 250, 0,  8300,  80,  -9.8f );
		public static REVERB_PROPERTIES FOREST()           => .(  1500,  162,  88, 5000,  54,  79, 100, 250, 0,   760,  94, -12.3f );
		public static REVERB_PROPERTIES CITY()             => .(  1500,    7,  11, 5000,  67,  50, 100, 250, 0,  4050,  66, -26.0f );
		public static REVERB_PROPERTIES MOUNTAINS()        => .(  1500,  300, 100, 5000,  21,  27, 100, 250, 0,  1220,  82, -24.0f );
		public static REVERB_PROPERTIES QUARRY()           => .(  1500,   61,  25, 5000,  83, 100, 100, 250, 0,  3400, 100,  -5.0f );
		public static REVERB_PROPERTIES PLAIN()            => .(  1500,  179, 100, 5000,  50,  21, 100, 250, 0,  1670,  65, -28.0f );
		public static REVERB_PROPERTIES PARKINGLOT()       => .(  1700,    8,  12, 5000, 100, 100, 100, 250, 0, 20000,  56, -19.5f );
		public static REVERB_PROPERTIES SEWERPIPE()        => .(  2800,   14,  21, 5000,  14,  80,  60, 250, 0,  3400,  66,   1.2f );
		public static REVERB_PROPERTIES UNDERWATER()       => .(  1500,    7,  11, 5000,  10, 100, 100, 250, 0,   500,  92,   7.0f );
	}

	[CRepr]
	public struct ERRORCALLBACK_INFO
	{
		public RESULT                     Result;
		public ERRORCALLBACK_INSTANCETYPE InstanceType;
		public void*                      Instance;
		public readonly char8*            FunctionName;
		public readonly char8*            FunctionParams;
	}

	[CRepr]
	public struct CPU_USAGE
	{
		public float DSP;
		public float Stream;
		public float Geometry;
		public float Update;
		public float Convolution1;
		public float Convolution2;
	}

	[CRepr]
	public struct DSP_DATA_PARAMETER_INFO
	{
		public void*  Data;
		public uint32 Length;
		public int32  Index;
	}

    /*
        FMOD System factory functions.  Use this to create an FMOD System Instance.
        Below you will see System init/close to get started.
    */
    public struct Factory
    {
        public static RESULT System_Create(out System system) =>
			FMOD5_System_Create(out system.handle, VERSION.Number);

		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_System_Create(out void* system, uint32 headerversion);
    }

    /*
        FMOD global system functions (optional).
    */
    public struct Memory
    {
        public static RESULT Initialize(void* poolmem, int32 poollen, MEMORY_ALLOC_CALLBACK useralloc, MEMORY_REALLOC_CALLBACK userrealloc, MEMORY_FREE_CALLBACK userfree, MEMORY_TYPE memtypeflags = .ALL) =>
            FMOD5_Memory_Initialize(poolmem, poollen, useralloc, userrealloc, userfree, memtypeflags);

        public static RESULT GetStats(out int32 currentalloced, out int32 maxalloced, bool blocking = true) =>
            FMOD5_Memory_GetStats(out currentalloced, out maxalloced, blocking);

        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Memory_Initialize(void* poolmem, int32 poollen, MEMORY_ALLOC_CALLBACK useralloc, MEMORY_REALLOC_CALLBACK userrealloc, MEMORY_FREE_CALLBACK userfree, MEMORY_TYPE memtypeflags);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Memory_GetStats(out int32 currentalloced, out int32 maxalloced, bool blocking);
    }

    public struct Debug
    {
        public static RESULT Initialize(DEBUG_FLAGS flags, DEBUG_MODE mode = .TTY, DEBUG_CALLBACK callback = null, String filename = null) =>
			FMOD5_Debug_Initialize(flags, mode, callback, filename?.CStr());

		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Debug_Initialize(DEBUG_FLAGS flags, DEBUG_MODE mode, DEBUG_CALLBACK callback, char8* filename);
    }

    public struct Thread
    {
        public static RESULT SetAttributes(THREAD_TYPE type, THREAD_AFFINITY affinity = .GROUP_DEFAULT, THREAD_PRIORITY priority = .DEFAULT, THREAD_STACK_SIZE stacksize = .DEFAULT) =>
        	FMOD5_Thread_SetAttributes(type, affinity, priority, stacksize);

        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Thread_SetAttributes(THREAD_TYPE type, THREAD_AFFINITY affinity, THREAD_PRIORITY priority, THREAD_STACK_SIZE stacksize);
    }

    /*
        'System' API.
    */
	public struct System
	{
        public void* handle;

		public this(void* ptr) { handle = ptr; }
        public bool HasHandle() => handle != null;
        public void ClearHandle() mut { handle = null; }

		public RESULT Release() =>
			FMOD5_System_Release(handle);

		// Setup functions.
		public RESULT SetOutput(OUTPUTTYPE output) =>
			FMOD5_System_SetOutput(handle, output);
		public RESULT GetOutput(out OUTPUTTYPE output) =>
			FMOD5_System_GetOutput(handle, out output);
		public RESULT GetNumDrivers(out int32 numdrivers) =>
			FMOD5_System_GetNumDrivers(handle, out numdrivers);
		public RESULT GetDriverInfo(int32 id, String name, int32 namelen, out Guid guid, out int32 systemrate, out SPEAKERMODE speakermode, out int32 speakermodechannels)
		{
			name.Clear();
		    char8* stringMem = new char8[namelen]*;

		    RESULT result = FMOD5_System_GetDriverInfo(handle, id, stringMem, namelen, out guid, out systemrate, out speakermode, out speakermodechannels);
			name.Append(stringMem);

		    delete stringMem;
		    return result;
		}
		public RESULT GetDriverInfo(int32 id, out Guid guid, out int32 systemrate, out SPEAKERMODE speakermode, out int32 speakermodechannels) =>
			FMOD5_System_GetDriverInfo(handle, id, null, 0, out guid, out systemrate, out speakermode, out speakermodechannels);
		public RESULT SetDriver(int32 driver) =>
			FMOD5_System_SetDriver(handle, driver);
		public RESULT GetDriver(out int32 driver) =>
			FMOD5_System_GetDriver(handle, out driver);
		public RESULT SetSoftwareChannels(int32 numsoftwarechannels) =>
			FMOD5_System_SetSoftwareChannels(handle, numsoftwarechannels);
		public RESULT GetSoftwareChannels(out int32 numsoftwarechannels) =>
			FMOD5_System_GetSoftwareChannels(handle, out numsoftwarechannels);
		public RESULT SetSoftwareFormat(int32 samplerate, SPEAKERMODE speakermode, int32 numrawspeakers) =>
			FMOD5_System_SetSoftwareFormat(handle, samplerate, speakermode, numrawspeakers);
		public RESULT GetSoftwareFormat(out int32 samplerate, out SPEAKERMODE speakermode, out int32 numrawspeakers) =>
			FMOD5_System_GetSoftwareFormat(handle, out samplerate, out speakermode, out numrawspeakers);
		public RESULT SetDSPBufferSize(uint32 bufferlength, int32 numbuffers) =>
			FMOD5_System_SetDSPBufferSize(handle, bufferlength, numbuffers);
		public RESULT GetDSPBufferSize(out uint32 bufferlength, out int32 numbuffers) =>
			FMOD5_System_GetDSPBufferSize(handle, out bufferlength, out numbuffers);
		public RESULT SetFileSystem(FILE_OPEN_CALLBACK useropen, FILE_CLOSE_CALLBACK userclose, FILE_READ_CALLBACK userread, FILE_SEEK_CALLBACK userseek, FILE_ASYNCREAD_CALLBACK userasyncread, FILE_ASYNCCANCEL_CALLBACK userasynccancel, int32 blockalign) =>
			FMOD5_System_SetFileSystem(handle, useropen, userclose, userread, userseek, userasyncread, userasynccancel, blockalign);
		public RESULT AttachFileSystem(FILE_OPEN_CALLBACK useropen, FILE_CLOSE_CALLBACK userclose, FILE_READ_CALLBACK userread, FILE_SEEK_CALLBACK userseek) =>
			FMOD5_System_AttachFileSystem(handle, useropen, userclose, userread, userseek);
		public RESULT SetAdvancedSettings(ref ADVANCEDSETTINGS settings)
		{
		    settings.CbSize = sizeof(ADVANCEDSETTINGS);
		    return FMOD5_System_SetAdvancedSettings(handle, ref settings);
		}
		public RESULT GetAdvancedSettings(ref ADVANCEDSETTINGS settings)
		{
		    settings.CbSize = sizeof(ADVANCEDSETTINGS);
		    return FMOD5_System_GetAdvancedSettings(handle, ref settings);
		}
		public RESULT SetCallback(SYSTEM_CALLBACK callback, SYSTEM_CALLBACK_TYPE callbackmask = .ALL) =>
			FMOD5_System_SetCallback(handle, callback, callbackmask);

		// Plug-in support.
		public RESULT SetPluginPath(StringView path) =>
			FMOD5_System_SetPluginPath(handle, path.ToScopeCStr!());
		public RESULT LoadPlugin(StringView filename, out uint32 plugHandle, uint32 priority = 0) =>
			FMOD5_System_LoadPlugin(handle, filename.ToScopeCStr!(), out plugHandle, priority);
		public RESULT UnloadPlugin(uint32 plugHandle) =>
			FMOD5_System_UnloadPlugin(handle, plugHandle);
		public RESULT GetNumNestedPlugins(uint32 plugHandle, out int32 count) =>
			FMOD5_System_GetNumNestedPlugins(handle, plugHandle, out count);
		public RESULT GetNestedPlugin(uint32 plugHandle, int32 index, out uint32 nestedhandle) =>
			FMOD5_System_GetNestedPlugin(handle, plugHandle, index, out nestedhandle);
		public RESULT GetNumPlugins(PLUGINTYPE plugintype, out int32 numplugins) =>
			FMOD5_System_GetNumPlugins(handle, plugintype, out numplugins);
		public RESULT GetPluginHandle(PLUGINTYPE plugintype, int32 index, out uint32 plugHandle) =>
			FMOD5_System_GetPluginHandle(handle, plugintype, index, out plugHandle);
		public RESULT GetPluginInfo(uint32 plugHandle, out PLUGINTYPE plugintype, String name, int32 namelen, out uint32 version)
		{
			name.Clear();
		    char8* stringMem = new char8[namelen]*;

		    RESULT result = FMOD5_System_GetPluginInfo(handle, plugHandle, out plugintype, stringMem, namelen, out version);
		    name.Append(stringMem);
		    
			delete stringMem;
		    return result;
		}
		public RESULT GetPluginInfo(uint32 plugHandle, out PLUGINTYPE plugintype, out uint32 version) =>
			FMOD5_System_GetPluginInfo(handle, plugHandle, out plugintype, null, 0, out version);
		public RESULT SetOutputByPlugin(uint32 plugHandle) =>
			FMOD5_System_SetOutputByPlugin(handle, plugHandle);
		public RESULT GetOutputByPlugin(out uint32 plugHandle) =>
			FMOD5_System_GetOutputByPlugin(handle, out plugHandle);
		public RESULT CreateDSPByPlugin(uint32 plugHandle, out DSP dsp) =>
			FMOD5_System_CreateDSPByPlugin(handle, plugHandle, out dsp.handle);
		public RESULT GetDSPInfoByPlugin(uint32 plugHandle, out void* description) =>
			FMOD5_System_GetDSPInfoByPlugin(handle, plugHandle, out description);
		public RESULT RegisterDSP(ref FMOD_DSP.DESCRIPTION description, out uint32 plugHandle) =>
			FMOD5_System_RegisterDSP(handle, ref description, out plugHandle);

		// Init/Close.
		public RESULT Init(int32 maxchannels, INITFLAGS flags, void* extradriverdata) =>
			FMOD5_System_Init(handle, maxchannels, flags, extradriverdata);
		public RESULT Close() =>
			FMOD5_System_Close(handle);

		// General post-init system functions.
		public RESULT Update() =>
			FMOD5_System_Update(handle);
		public RESULT SetSpeakerPosition(SPEAKER speaker, float x, float y, bool active) =>
			FMOD5_System_SetSpeakerPosition(handle, speaker, x, y, active);
		public RESULT GetSpeakerPosition(SPEAKER speaker, out float x, out float y, out bool active) =>
			FMOD5_System_GetSpeakerPosition(handle, speaker, out x, out y, out active);
		public RESULT SetStreamBufferSize(uint32 filebuffersize, TIMEUNIT filebuffersizetype) =>
			FMOD5_System_SetStreamBufferSize(handle, filebuffersize, filebuffersizetype);
		public RESULT GetStreamBufferSize(out uint32 filebuffersize, out TIMEUNIT filebuffersizetype) =>
			FMOD5_System_GetStreamBufferSize(handle, out filebuffersize, out filebuffersizetype);
		public RESULT Set3DSettings(float dopplerscale, float distancefactor, float rolloffscale) =>
			FMOD5_System_Set3DSettings(handle, dopplerscale, distancefactor, rolloffscale);
		public RESULT Get3DSettings(out float dopplerscale, out float distancefactor, out float rolloffscale) =>
			FMOD5_System_Get3DSettings(handle, out dopplerscale, out distancefactor, out rolloffscale);
		public RESULT Set3DNumListeners(int32 numlisteners) =>
			FMOD5_System_Set3DNumListeners(handle, numlisteners);
		public RESULT Get3DNumListeners(out int32 numlisteners) =>
			FMOD5_System_Get3DNumListeners(handle, out numlisteners);
		public RESULT Set3DListenerAttributes(int32 listener, ref VECTOR pos, ref VECTOR vel, ref VECTOR forward, ref VECTOR up) =>
			FMOD5_System_Set3DListenerAttributes(handle, listener, ref pos, ref vel, ref forward, ref up);
		public RESULT Get3DListenerAttributes(int32 listener, out VECTOR pos, out VECTOR vel, out VECTOR forward, out VECTOR up) =>
			FMOD5_System_Get3DListenerAttributes(handle, listener, out pos, out vel, out forward, out up);
		public RESULT Set3DRolloffCallback(CB_3D_ROLLOFF_CALLBACK callback) =>
			FMOD5_System_Set3DRolloffCallback(handle, callback);
		public RESULT MixerSuspend() =>
			FMOD5_System_MixerSuspend(handle);
		public RESULT MixerResume() =>
			FMOD5_System_MixerResume(handle);
		public RESULT GetDefaultMixMatrix(SPEAKERMODE sourcespeakermode, SPEAKERMODE targetspeakermode, float[] matrix, int32 matrixhop) =>
			FMOD5_System_GetDefaultMixMatrix(handle, sourcespeakermode, targetspeakermode, matrix, matrixhop);
		public RESULT GetSpeakerModeChannels(SPEAKERMODE mode, out int32 channels) =>
			FMOD5_System_GetSpeakerModeChannels(handle, mode, out channels);

		// System information functions.
		public RESULT GetVersion(out uint32 version) =>
			FMOD5_System_GetVersion(handle, out version);
		public RESULT GetOutputHandle(out void* outputHandle) =>
			FMOD5_System_GetOutputHandle(handle, out outputHandle);
		public RESULT GetChannelsPlaying(out int32 channels) =>
			FMOD5_System_GetChannelsPlaying(handle, out channels, null);
		public RESULT GetChannelsPlaying(out int32 channels, out int32 realchannels) =>
			FMOD5_System_GetChannelsPlaying(handle, out channels, out realchannels);
		public RESULT GetCPUUsage(out CPU_USAGE usage) =>
			FMOD5_System_GetCPUUsage(handle, out usage);
		public RESULT GetFileUsage(out int64 sampleBytesRead, out int64 streamBytesRead, out int64 otherBytesRead) =>
			FMOD5_System_GetFileUsage(handle, out sampleBytesRead, out streamBytesRead, out otherBytesRead);

		// Sound/DSP/Channel/FX creation and retrieval.
		public RESULT CreateSound(StringView name, MODE mode, ref CREATESOUNDEXINFO exinfo, out Sound sound) =>
			FMOD5_System_CreateSound(handle, name.ToScopeCStr!(), mode, ref exinfo, out sound.handle);
		public RESULT CreateSound(uint8[] data, MODE mode, ref CREATESOUNDEXINFO exinfo, out Sound sound) =>
			FMOD5_System_CreateSound(handle, data, mode, ref exinfo, out sound.handle);
		public RESULT CreateSound(void* name_or_data, MODE mode, ref CREATESOUNDEXINFO exinfo, out Sound sound) =>
			FMOD5_System_CreateSound(handle, name_or_data, mode, ref exinfo, out sound.handle);
		public RESULT CreateSound(StringView name, MODE mode, out Sound sound)
		{
		    CREATESOUNDEXINFO exinfo = .();
		    exinfo.CbSize = sizeof(CREATESOUNDEXINFO);
		    return CreateSound(name, mode, ref exinfo, out sound);
		}
		public RESULT CreateStream(StringView name, MODE mode, ref CREATESOUNDEXINFO exinfo, out Sound sound) =>
			FMOD5_System_CreateStream(handle, name.ToScopeCStr!(), mode, ref exinfo, out sound.handle);
		public RESULT CreateStream(uint8[] data, MODE mode, ref CREATESOUNDEXINFO exinfo, out Sound sound) =>
			FMOD5_System_CreateStream(handle, data, mode, ref exinfo, out sound.handle);
		public RESULT CreateStream(void* name_or_data, MODE mode, ref CREATESOUNDEXINFO exinfo, out Sound sound) =>
			FMOD5_System_CreateStream(handle, name_or_data, mode, ref exinfo, out sound.handle);
		public RESULT CreateStream(StringView name, MODE mode, out Sound sound)
		{
		    CREATESOUNDEXINFO exinfo = .();
		    exinfo.CbSize = sizeof(CREATESOUNDEXINFO);
		    return CreateStream(name, mode, ref exinfo, out sound);
		}
		public RESULT CreateDSP(ref FMOD_DSP.DESCRIPTION description, out DSP dsp) =>
			FMOD5_System_CreateDSP(handle, ref description, out dsp.handle);
		public RESULT CreateDSPByType(FMOD_DSP.TYPE type, out DSP dsp) =>
			FMOD5_System_CreateDSPByType(handle, type, out dsp.handle);
		public RESULT CreateChannelGroup(StringView name, out ChannelGroup channelgroup) =>
			FMOD5_System_CreateChannelGroup(handle, name.ToScopeCStr!(), out channelgroup.handle);
		public RESULT CreateSoundGroup(StringView name, out SoundGroup soundgroup) =>
			FMOD5_System_CreateSoundGroup(handle, name.ToScopeCStr!(), out soundgroup.handle);
		public RESULT CreateReverb3D(out Reverb3D reverb) =>
			FMOD5_System_CreateReverb3D(handle, out reverb.handle);
		public RESULT PlaySound(Sound sound, ChannelGroup channelgroup, bool paused, out Channel channel) =>
			FMOD5_System_PlaySound(handle, sound.handle, channelgroup.handle, paused, out channel.handle);
		public RESULT PlayDSP(DSP dsp, ChannelGroup channelgroup, bool paused, out Channel channel) =>
			FMOD5_System_PlayDSP(handle, dsp.handle, channelgroup.handle, paused, out channel.handle);
		public RESULT GetChannel(int32 channelid, out Channel channel) =>
			FMOD5_System_GetChannel(handle, channelid, out channel.handle);
		public RESULT GetDSPInfoByType(FMOD_DSP.TYPE type, out void* description) =>
			FMOD5_System_GetDSPInfoByType(handle, type, out description);
		public RESULT GetMasterChannelGroup(out ChannelGroup channelgroup) =>
			FMOD5_System_GetMasterChannelGroup(handle, out channelgroup.handle);
		public RESULT GetMasterSoundGroup(out SoundGroup soundgroup) =>
			FMOD5_System_GetMasterSoundGroup(handle, out soundgroup.handle);

		// Routing to ports.
		public RESULT AttachChannelGroupToPort(PORT_TYPE portType, uint64 portIndex, ChannelGroup channelgroup, bool passThru = false) =>
			FMOD5_System_AttachChannelGroupToPort(handle, portType, portIndex, channelgroup.handle, passThru);
		public RESULT DetachChannelGroupFromPort(ChannelGroup channelgroup) =>
			FMOD5_System_DetachChannelGroupFromPort(handle, channelgroup.handle);

		// Reverb api.
		public RESULT SetReverbProperties(int32 instance, ref REVERB_PROPERTIES prop) =>
			FMOD5_System_SetReverbProperties(handle, instance, ref prop);
		public RESULT GetReverbProperties(int32 instance, out REVERB_PROPERTIES prop) =>
			FMOD5_System_GetReverbProperties(handle, instance, out prop);

		// System level DSP functionality.
		public RESULT LockDSP() =>
			FMOD5_System_LockDSP(handle);
		public RESULT UnlockDSP() =>
			FMOD5_System_UnlockDSP(handle);

		// Recording api
		public RESULT GetRecordNumDrivers(out int32 numdrivers, out int32 numconnected) =>
			FMOD5_System_GetRecordNumDrivers(handle, out numdrivers, out numconnected);
		public RESULT GetRecordDriverInfo(int32 id, String name, int32 namelen, out Guid guid, out int32 systemrate, out SPEAKERMODE speakermode, out int32 speakermodechannels, out DRIVER_STATE state)
		{
		    char8* stringMem = new char8[namelen]*;

		    RESULT result = FMOD5_System_GetRecordDriverInfo(handle, id, stringMem, namelen, out guid, out systemrate, out speakermode, out speakermodechannels, out state);
		    name.Append(stringMem);

		    delete stringMem;
		    return result;
		}
		public RESULT GetRecordDriverInfo(int32 id, out Guid guid, out int32 systemrate, out SPEAKERMODE speakermode, out int32 speakermodechannels, out DRIVER_STATE state) =>
			FMOD5_System_GetRecordDriverInfo(handle, id, null, 0, out guid, out systemrate, out speakermode, out speakermodechannels, out state);
		public RESULT GetRecordPosition(int32 id, out uint32 position) =>
			FMOD5_System_GetRecordPosition(handle, id, out position);
		public RESULT RecordStart(int32 id, Sound sound, bool loop) =>
			FMOD5_System_RecordStart(handle, id, sound.handle, loop);
		public RESULT RecordStop(int32 id) =>
			FMOD5_System_RecordStop(handle, id);
		public RESULT IsRecording(int32 id, out bool recording) =>
			FMOD5_System_IsRecording(handle, id, out recording);

		// Geometry api
		public RESULT CreateGeometry(int32 maxpolygons, int32 maxvertices, out Geometry geometry) =>
			FMOD5_System_CreateGeometry(handle, maxpolygons, maxvertices, out geometry.handle);
		public RESULT SetGeometrySettings(float maxworldsize) =>
			FMOD5_System_SetGeometrySettings(handle, maxworldsize);
		public RESULT GetGeometrySettings(out float maxworldsize) =>
			FMOD5_System_GetGeometrySettings(handle, out maxworldsize);
		public RESULT LoadGeometry(void* data, int32 datasize, out Geometry geometry) =>
			FMOD5_System_LoadGeometry(handle, data, datasize, out geometry.handle);
		public RESULT GetGeometryOcclusion(ref VECTOR listener, ref VECTOR source, out float direct, out float reverb) =>
			FMOD5_System_GetGeometryOcclusion(handle, ref listener, ref source, out direct, out reverb);

		// Network functions
		public RESULT SetNetworkProxy(StringView proxy) =>
			FMOD5_System_SetNetworkProxy(handle, proxy.ToScopeCStr!());
		public RESULT GetNetworkProxy(String proxy, int32 proxylen)
		{
		    char8* stringMem = new char8[proxylen]*;

		    RESULT result = FMOD5_System_GetNetworkProxy(handle, stringMem, proxylen);
		    proxy.Append(stringMem);

		    delete stringMem;
		    return result;
		}
		public RESULT SetNetworkTimeout(int32 timeout) =>
			FMOD5_System_SetNetworkTimeout(handle, timeout);
		public RESULT GetNetworkTimeout(out int32 timeout) =>
			FMOD5_System_GetNetworkTimeout(handle, out timeout);

		// Userdata set/get
		public RESULT SetUserData(void* userdata) =>
			FMOD5_System_SetUserData(handle, userdata);
		public RESULT GetUserData(out void* userdata) =>
			FMOD5_System_GetUserData(handle, out userdata);

		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_Release(void* system);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetOutput(void* system, OUTPUTTYPE output);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetOutput(void* system, out OUTPUTTYPE output);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetNumDrivers(void* system, out int32 numdrivers);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetDriverInfo(void* system, int32 id, void* name, int32 namelen, out Guid guid, out int32 systemrate, out SPEAKERMODE speakermode, out int32 speakermodechannels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetDriver(void* system, int32 driver);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetDriver(void* system, out int32 driver);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetSoftwareChannels(void* system, int32 numsoftwarechannels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetSoftwareChannels(void* system, out int32 numsoftwarechannels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetSoftwareFormat(void* system, int32 samplerate, SPEAKERMODE speakermode, int32 numrawspeakers);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetSoftwareFormat(void* system, out int32 samplerate, out SPEAKERMODE speakermode, out int32 numrawspeakers);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetDSPBufferSize(void* system, uint32 bufferlength, int32 numbuffers);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetDSPBufferSize(void* system, out uint32 bufferlength, out int32 numbuffers);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetFileSystem(void* system, FILE_OPEN_CALLBACK useropen, FILE_CLOSE_CALLBACK userclose, FILE_READ_CALLBACK userread, FILE_SEEK_CALLBACK userseek, FILE_ASYNCREAD_CALLBACK userasyncread, FILE_ASYNCCANCEL_CALLBACK userasynccancel, int32 blockalign);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_AttachFileSystem(void* system, FILE_OPEN_CALLBACK useropen, FILE_CLOSE_CALLBACK userclose, FILE_READ_CALLBACK userread, FILE_SEEK_CALLBACK userseek);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetAdvancedSettings(void* system, ref ADVANCEDSETTINGS settings);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetAdvancedSettings(void* system, ref ADVANCEDSETTINGS settings);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetCallback(void* system, SYSTEM_CALLBACK callback, SYSTEM_CALLBACK_TYPE callbackmask);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetPluginPath(void* system, char8* path);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_LoadPlugin(void* system, char8* filename, out uint32 handle, uint32 priority);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_UnloadPlugin(void* system, uint32 handle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetNumNestedPlugins(void* system, uint32 handle, out int32 count);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetNestedPlugin(void* system, uint32 handle, int32 index, out uint32 nestedhandle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetNumPlugins(void* system, PLUGINTYPE plugintype, out int32 numplugins);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetPluginHandle(void* system, PLUGINTYPE plugintype, int32 index, out uint32 handle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetPluginInfo(void* system, uint32 handle, out PLUGINTYPE plugintype, void* name, int32 namelen, out uint32 version);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetOutputByPlugin(void* system, uint32 handle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetOutputByPlugin(void* system, out uint32 handle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_CreateDSPByPlugin(void* system, uint32 handle, out void* dsp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetDSPInfoByPlugin(void* system, uint32 handle, out void* description);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_RegisterDSP(void* system, ref FMOD_DSP.DESCRIPTION description, out uint32 handle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_Init(void* system, int32 maxchannels, INITFLAGS flags, void* extradriverdata);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_Close(void* system);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_Update(void* system);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetSpeakerPosition(void* system, SPEAKER speaker, float x, float y, bool active);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetSpeakerPosition(void* system, SPEAKER speaker, out float x, out float y, out bool active);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetStreamBufferSize(void* system, uint32 filebuffersize, TIMEUNIT filebuffersizetype);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetStreamBufferSize(void* system, out uint32 filebuffersize, out TIMEUNIT filebuffersizetype);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_Set3DSettings(void* system, float dopplerscale, float distancefactor, float rolloffscale);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_Get3DSettings(void* system, out float dopplerscale, out float distancefactor, out float rolloffscale);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_Set3DNumListeners(void* system, int32 numlisteners);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_Get3DNumListeners(void* system, out int32 numlisteners);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_Set3DListenerAttributes(void* system, int32 listener, ref VECTOR pos, ref VECTOR vel, ref VECTOR forward, ref VECTOR up);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_Get3DListenerAttributes(void* system, int32 listener, out VECTOR pos, out VECTOR vel, out VECTOR forward, out VECTOR up);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_Set3DRolloffCallback(void* system, CB_3D_ROLLOFF_CALLBACK callback);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_MixerSuspend(void* system);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_MixerResume(void* system);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetDefaultMixMatrix(void* system, SPEAKERMODE sourcespeakermode, SPEAKERMODE targetspeakermode, float[] matrix, int32 matrixhop);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetSpeakerModeChannels(void* system, SPEAKERMODE mode, out int32 channels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetVersion(void* system, out uint32 version);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetOutputHandle(void* system, out void* handle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetChannelsPlaying(void* system, out int32 channels, void* zero);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetChannelsPlaying(void* system, out int32 channels, out int32 realchannels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetCPUUsage(void* system, out CPU_USAGE usage);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetFileUsage(void* system, out int64 sampleBytesRead, out int64 streamBytesRead, out int64 otherBytesRead);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_CreateSound(void* system, uint8[] name_or_data, MODE mode, ref CREATESOUNDEXINFO exinfo, out void* sound);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_CreateSound(void* system, void* name_or_data, MODE mode, ref CREATESOUNDEXINFO exinfo, out void* sound);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_CreateStream(void* system, uint8[] name_or_data, MODE mode, ref CREATESOUNDEXINFO exinfo, out void* sound);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_CreateStream(void* system, void* name_or_data, MODE mode, ref CREATESOUNDEXINFO exinfo, out void* sound);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_CreateDSP(void* system, ref FMOD_DSP.DESCRIPTION description, out void* dsp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_CreateDSPByType(void* system, FMOD_DSP.TYPE type, out void* dsp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_CreateChannelGroup(void* system, char8* name, out void* channelgroup);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_CreateSoundGroup(void* system, char8* name, out void* soundgroup);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_CreateReverb3D(void* system, out void* reverb);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_PlaySound(void* system, void* sound, void* channelgroup, bool paused, out void* channel);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_PlayDSP(void* system, void* dsp, void* channelgroup, bool paused, out void* channel);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetChannel(void* system, int32 channelid, out void* channel);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetDSPInfoByType(void* system, FMOD_DSP.TYPE type, out void* description);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetMasterChannelGroup(void* system, out void* channelgroup);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetMasterSoundGroup(void* system, out void* soundgroup);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_AttachChannelGroupToPort(void* system, PORT_TYPE portType, uint64 portIndex, void* channelgroup, bool passThru);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_DetachChannelGroupFromPort(void* system, void* channelgroup);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetReverbProperties(void* system, int32 instance, ref REVERB_PROPERTIES prop);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetReverbProperties(void* system, int32 instance, out REVERB_PROPERTIES prop);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_LockDSP(void* system);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_UnlockDSP(void* system);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetRecordNumDrivers(void* system, out int32 numdrivers, out int32 numconnected);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetRecordDriverInfo(void* system, int32 id, void* name, int32 namelen, out Guid guid, out int32 systemrate, out SPEAKERMODE speakermode, out int32 speakermodechannels, out DRIVER_STATE state);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetRecordPosition(void* system, int32 id, out uint32 position);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_RecordStart(void* system, int32 id, void* sound, bool loop);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_RecordStop(void* system, int32 id);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_IsRecording(void* system, int32 id, out bool recording);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_CreateGeometry(void* system, int32 maxpolygons, int32 maxvertices, out void* geometry);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetGeometrySettings(void* system, float maxworldsize);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetGeometrySettings(void* system, out float maxworldsize);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_LoadGeometry(void* system, void* data, int32 datasize, out void* geometry);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetGeometryOcclusion(void* system, ref VECTOR listener, ref VECTOR source, out float direct, out float reverb);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetNetworkProxy(void* system, char8* proxy);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetNetworkProxy(void* system, char8* proxy, int32 proxylen);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetNetworkTimeout(void* system, int32 timeout);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetNetworkTimeout(void* system, out int32 timeout);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_SetUserData(void* system, void* userdata);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_System_GetUserData(void* system, out void* userdata);
	}

    /*
        'Sound' API.
    */
    public struct Sound
    {
        public void* handle;

		public this(void* ptr) { handle = ptr; }
        public bool HasHandle() => handle != null;
        public void ClearHandle() mut { handle = null; }

		public RESULT Release() =>
			FMOD5_Sound_Release(handle);
		public RESULT GetSystemObject(out System system) =>
			FMOD5_Sound_GetSystemObject(handle, out system.handle);

		// Standard sound manipulation functions.
		public RESULT Lock(uint32 offset, uint32 length, out void* ptr1, out void* ptr2, out uint32 len1, out uint32 len2) =>
			FMOD5_Sound_Lock(handle, offset, length, out ptr1, out ptr2, out len1, out len2);
		public RESULT Unlock(void* ptr1, void* ptr2, uint32 len1, uint32 len2) =>
			FMOD5_Sound_Unlock(handle, ptr1, ptr2, len1, len2);
		public RESULT SetDefaults(float frequency, int32 priority) =>
			FMOD5_Sound_SetDefaults(handle, frequency, priority);
		public RESULT GetDefaults(out float frequency, out int32 priority) =>
			FMOD5_Sound_GetDefaults(handle, out frequency, out priority);
		public RESULT Set3DMinMaxDistance(float min, float max) =>
			FMOD5_Sound_Set3DMinMaxDistance(handle, min, max);
		public RESULT Get3DMinMaxDistance(out float min, out float max) =>
			FMOD5_Sound_Get3DMinMaxDistance(handle, out min, out max);
		public RESULT Set3DConeSettings(float insideconeangle, float outsideconeangle, float outsidevolume) =>
			FMOD5_Sound_Set3DConeSettings(handle, insideconeangle, outsideconeangle, outsidevolume);
		public RESULT Get3DConeSettings(out float insideconeangle, out float outsideconeangle, out float outsidevolume) =>
			FMOD5_Sound_Get3DConeSettings(handle, out insideconeangle, out outsideconeangle, out outsidevolume);
		public RESULT Set3DCustomRolloff(ref VECTOR points, int32 numpoints) =>
			FMOD5_Sound_Set3DCustomRolloff(handle, ref points, numpoints);
		public RESULT Get3DCustomRolloff(out void* points, out int32 numpoints) =>
			FMOD5_Sound_Get3DCustomRolloff(handle, out points, out numpoints);

		public RESULT GetSubSound(int32 index, out Sound subsound) =>
			FMOD5_Sound_GetSubSound(handle, index, out subsound.handle);
		public RESULT GetSubSoundParent(out Sound parentsound) =>
			FMOD5_Sound_GetSubSoundParent(handle, out parentsound.handle);
		public RESULT GetName(String name, int32 namelen)
		{
		    char8* stringMem = new char8[namelen]*;

		    RESULT result = FMOD5_Sound_GetName(handle, stringMem, namelen);
		    name.Append(stringMem);

		    delete stringMem;
		    return result;
		}
		public RESULT GetLength(out uint32 length, TIMEUNIT lengthtype) =>
			FMOD5_Sound_GetLength(handle, out length, lengthtype);
		public RESULT GetFormat(out SOUND_TYPE type, out SOUND_FORMAT format, out int32 channels, out int32 bits) =>
			FMOD5_Sound_GetFormat(handle, out type, out format, out channels, out bits);
		public RESULT GetNumSubSounds(out int32 numsubsounds) =>
			FMOD5_Sound_GetNumSubSounds(handle, out numsubsounds);
		public RESULT GetNumTags(out int32 numtags, out int32 numtagsupdated) =>
			FMOD5_Sound_GetNumTags(handle, out numtags, out numtagsupdated);
		public RESULT GetTag(StringView name, int32 index, out TAG tag) =>
			FMOD5_Sound_GetTag(handle, name.ToScopeCStr!(), index, out tag);
		public RESULT GetOpenState(out OPENSTATE openstate, out uint32 percentbuffered, out bool starving, out bool diskbusy) =>
			FMOD5_Sound_GetOpenState(handle, out openstate, out percentbuffered, out starving, out diskbusy);
		public RESULT ReadData(uint8[] buffer) =>
			FMOD5_Sound_ReadData(handle, buffer, (uint32)buffer.Count, null);
		public RESULT ReadData(uint8[] buffer, out uint32 read) =>
			FMOD5_Sound_ReadData(handle, buffer, (uint32)buffer.Count, out read);
		[Obsolete("Use Sound.readData(uint8[], out uint32) or Sound.readData(uint8[]) instead.", false)]
		public RESULT ReadData(void* buffer, uint32 length, out uint32 read) =>
			FMOD5_Sound_ReadData(handle, buffer, length, out read);
		public RESULT SeekData(uint32 pcm) =>
			FMOD5_Sound_SeekData(handle, pcm);
		public RESULT SetSoundGroup(SoundGroup soundgroup) =>
			FMOD5_Sound_SetSoundGroup(handle, soundgroup.handle);
		public RESULT GetSoundGroup(out SoundGroup soundgroup) =>
			FMOD5_Sound_GetSoundGroup(handle, out soundgroup.handle);

		// Synchronization point API.  These points can come from markers embedded in wav files, and can also generate channel callbacks.
		public RESULT GetNumSyncPoints(out int32 numsyncpoints) =>
			FMOD5_Sound_GetNumSyncPoints(handle, out numsyncpoints);
		public RESULT GetSyncPoint(int32 index, out void* point) =>
			FMOD5_Sound_GetSyncPoint(handle, index, out point);
		public RESULT GetSyncPointInfo(void* point, String name, int32 namelen, out uint32 offset, TIMEUNIT offsettype)
		{
		    char8* stringMem = new char8[namelen]*;

		    RESULT result = FMOD5_Sound_GetSyncPointInfo(handle, point, stringMem, namelen, out offset, offsettype);
		    name.Append(stringMem);

		    delete stringMem;
		    return result;
		}
		public RESULT GetSyncPointInfo(void* point, out uint32 offset, TIMEUNIT offsettype) =>
			FMOD5_Sound_GetSyncPointInfo(handle, point, null, 0, out offset, offsettype);
		public RESULT AddSyncPoint(uint32 offset, TIMEUNIT offsettype, StringView name, out void* point) =>
			FMOD5_Sound_AddSyncPoint(handle, offset, offsettype, name.ToScopeCStr!(), out point);
		public RESULT DeleteSyncPoint(void* point) =>
			FMOD5_Sound_DeleteSyncPoint(handle, point);

		// Functions also in Channel class but here they are the 'default' to save having to change it in Channel all the time.
		public RESULT SetMode(MODE mode) =>
			FMOD5_Sound_SetMode(handle, mode);
		public RESULT GetMode(out MODE mode) =>
			FMOD5_Sound_GetMode(handle, out mode);
		public RESULT SetLoopCount(int32 loopcount) =>
			FMOD5_Sound_SetLoopCount(handle, loopcount);
		public RESULT GetLoopCount(out int32 loopcount) =>
			FMOD5_Sound_GetLoopCount(handle, out loopcount);
		public RESULT SetLoopPoints(uint32 loopstart, TIMEUNIT loopstarttype, uint32 loopend, TIMEUNIT loopendtype) =>
			FMOD5_Sound_SetLoopPoints(handle, loopstart, loopstarttype, loopend, loopendtype);
		public RESULT GetLoopPoints(out uint32 loopstart, TIMEUNIT loopstarttype, out uint32 loopend, TIMEUNIT loopendtype) =>
			FMOD5_Sound_GetLoopPoints(handle, out loopstart, loopstarttype, out loopend, loopendtype);

		// For MOD/S3M/XM/IT/MID sequenced formats only.
		public RESULT GetMusicNumChannels(out int32 numchannels) =>
			FMOD5_Sound_GetMusicNumChannels(handle, out numchannels);
		public RESULT SetMusicChannelVolume(int32 channel, float volume) =>
			FMOD5_Sound_SetMusicChannelVolume(handle, channel, volume);
		public RESULT GetMusicChannelVolume(int32 channel, out float volume) =>
			FMOD5_Sound_GetMusicChannelVolume(handle, channel, out volume);
		public RESULT SetMusicSpeed(float speed) =>
			FMOD5_Sound_SetMusicSpeed(handle, speed);
		public RESULT GetMusicSpeed(out float speed) =>
			FMOD5_Sound_GetMusicSpeed(handle, out speed);

		// Userdata set/get.
		public RESULT SetUserData(void* userdata) =>
			FMOD5_Sound_SetUserData(handle, userdata);
		public RESULT GetUserData(out void* userdata) =>
			FMOD5_Sound_GetUserData(handle, out userdata);
		
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_Release(void* sound);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetSystemObject(void* sound, out void* system);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_Lock(void* sound, uint32 offset, uint32 length, out void* ptr1, out void* ptr2, out uint32 len1, out uint32 len2);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_Unlock(void* sound, void* ptr1, void* ptr2, uint32 len1, uint32 len2);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_SetDefaults(void* sound, float frequency, int32 priority);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetDefaults(void* sound, out float frequency, out int32 priority);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_Set3DMinMaxDistance(void* sound, float min, float max);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_Get3DMinMaxDistance(void* sound, out float min, out float max);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_Set3DConeSettings(void* sound, float insideconeangle, float outsideconeangle, float outsidevolume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_Get3DConeSettings(void* sound, out float insideconeangle, out float outsideconeangle, out float outsidevolume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_Set3DCustomRolloff(void* sound, ref VECTOR points, int32 numpoints);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_Get3DCustomRolloff(void* sound, out void* points, out int32 numpoints);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetSubSound(void* sound, int32 index, out void* subsound);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetSubSoundParent(void* sound, out void* parentsound);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetName(void* sound, void* name, int32 namelen);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetLength(void* sound, out uint32 length, TIMEUNIT lengthtype);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetFormat(void* sound, out SOUND_TYPE type, out SOUND_FORMAT format, out int32 channels, out int32 bits);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetNumSubSounds(void* sound, out int32 numsubsounds);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetNumTags(void* sound, out int32 numtags, out int32 numtagsupdated);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetTag(void* sound, char8* name, int32 index, out TAG tag);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetOpenState(void* sound, out OPENSTATE openstate, out uint32 percentbuffered, out bool starving, out bool diskbusy);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_ReadData(void* sound, uint8[] buffer, uint32 length, void* zero);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_ReadData(void* sound, uint8[] buffer, uint32 length, out uint32 read);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_ReadData(void* sound, void* buffer, uint32 length, out uint32 read);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_SeekData(void* sound, uint32 pcm);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_SetSoundGroup(void* sound, void* soundgroup);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetSoundGroup(void* sound, out void* soundgroup);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetNumSyncPoints(void* sound, out int32 numsyncpoints);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetSyncPoint(void* sound, int32 index, out void* point);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetSyncPointInfo(void* sound, void* point, void* name, int32 namelen, out uint32 offset, TIMEUNIT offsettype);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_AddSyncPoint(void* sound, uint32 offset, TIMEUNIT offsettype, char8* name, out void* point);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_DeleteSyncPoint(void* sound, void* point);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_SetMode(void* sound, MODE mode);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetMode(void* sound, out MODE mode);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_SetLoopCount(void* sound, int32 loopcount);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetLoopCount(void* sound, out int32 loopcount);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_SetLoopPoints(void* sound, uint32 loopstart, TIMEUNIT loopstarttype, uint32 loopend, TIMEUNIT loopendtype);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetLoopPoints(void* sound, out uint32 loopstart, TIMEUNIT loopstarttype, out uint32 loopend, TIMEUNIT loopendtype);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetMusicNumChannels(void* sound, out int32 numchannels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_SetMusicChannelVolume(void* sound, int32 channel, float volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetMusicChannelVolume(void* sound, int32 channel, out float volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_SetMusicSpeed(void* sound, float speed);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetMusicSpeed(void* sound, out float speed);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_SetUserData(void* sound, void* userdata);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Sound_GetUserData(void* sound, out void* userdata);
	}

    /*
        'ChannelControl' API
    */
    interface IChannelControl
    {
        RESULT GetSystemObject(out System system);

        // General control functionality for Channels and ChannelGroups.
        RESULT Stop();
        RESULT SetPaused(bool paused);
        RESULT GetPaused(out bool paused);
        RESULT SetVolume(float volume);
        RESULT GetVolume(out float volume);
        RESULT SetVolumeRamp(bool ramp);
        RESULT GetVolumeRamp(out bool ramp);
        RESULT GetAudibility(out float audibility);
        RESULT SetPitch(float pitch);
        RESULT GetPitch(out float pitch);
        RESULT SetMute(bool mute);
        RESULT GetMute(out bool mute);
        RESULT SetReverbProperties(int32 instance, float wet);
        RESULT GetReverbProperties(int32 instance, out float wet);
        RESULT SetLowPassGain(float gain);
        RESULT GetLowPassGain(out float gain);
        RESULT SetMode(MODE mode);
        RESULT GetMode(out MODE mode);
        RESULT SetCallback(CHANNELCONTROL_CALLBACK callback);
        RESULT IsPlaying(out bool isplaying);

        // Note all 'set' functions alter a final matrix, this is why the only get function is getMixMatrix, to avoid other get functions returning incorrect/obsolete values.
        RESULT SetPan(float pan);
        RESULT SetMixLevelsOutput(float frontleft, float frontright, float center, float lfe, float surroundleft, float surroundright, float backleft, float backright);
        RESULT SetMixLevelsInput(float[] levels, int32 numlevels);
        RESULT SetMixMatrix(float[] matrix, int32 outchannels, int32 inchannels, int32 inchannel_hop);
        RESULT GetMixMatrix(float[] matrix, out int32 outchannels, out int32 inchannels, int32 inchannel_hop);

        // Clock based functionality.
        RESULT GetDSPClock(out uint64 dspclock, out uint64 parentclock);
        RESULT SetDelay(uint64 dspclock_start, uint64 dspclock_end, bool stopchannels);
        RESULT GetDelay(out uint64 dspclock_start, out uint64 dspclock_end);
        RESULT GetDelay(out uint64 dspclock_start, out uint64 dspclock_end, out bool stopchannels);
        RESULT AddFadePoint(uint64 dspclock, float volume);
        RESULT SetFadePointRamp(uint64 dspclock, float volume);
        RESULT RemoveFadePoints(uint64 dspclock_start, uint64 dspclock_end);
        RESULT GetFadePoints(ref uint32 numpoints, uint64[] point_dspclock, float[] point_volume);

        // DSP effects.
        RESULT GetDSP(int32 index, out DSP dsp);
        RESULT AddDSP(int32 index, DSP dsp);
        RESULT RemoveDSP(DSP dsp);
        RESULT GetNumDSPs(out int32 numdsps);
        RESULT SetDSPIndex(DSP dsp, int32 index);
        RESULT GetDSPIndex(DSP dsp, out int32 index);

        // 3D functionality.
        RESULT Set3DAttributes(ref VECTOR pos, ref VECTOR vel);
        RESULT Get3DAttributes(out VECTOR pos, out VECTOR vel);
        RESULT Set3DMinMaxDistance(float mindistance, float maxdistance);
        RESULT Get3DMinMaxDistance(out float mindistance, out float maxdistance);
        RESULT Set3DConeSettings(float insideconeangle, float outsideconeangle, float outsidevolume);
        RESULT Get3DConeSettings(out float insideconeangle, out float outsideconeangle, out float outsidevolume);
        RESULT Set3DConeOrientation(ref VECTOR orientation);
        RESULT Get3DConeOrientation(out VECTOR orientation);
        RESULT Set3DCustomRolloff(ref VECTOR points, int32 numpoints);
        RESULT Get3DCustomRolloff(out void* points, out int32 numpoints);
        RESULT Set3DOcclusion(float directocclusion, float reverbocclusion);
        RESULT Get3DOcclusion(out float directocclusion, out float reverbocclusion);
        RESULT Set3DSpread(float angle);
        RESULT Get3DSpread(out float angle);
        RESULT Set3DLevel(float level);
        RESULT Get3DLevel(out float level);
        RESULT Set3DDopplerLevel(float level);
        RESULT Get3DDopplerLevel(out float level);
        RESULT Set3DDistanceFilter(bool custom, float customLevel, float centerFreq);
        RESULT Get3DDistanceFilter(out bool custom, out float customLevel, out float centerFreq);

        // Userdata set/get.
        RESULT SetUserData(void* userdata);
        RESULT GetUserData(out void* userdata);
	}

	/*
        'Channel' API
    */
    public struct Channel : IChannelControl
    {
        public void* handle;

		public this(void* ptr) { handle = ptr; }
        public bool HasHandle() => handle != null;
        public void ClearHandle() mut { handle = null; }

		// Channel specific control functionality.
		public RESULT SetFrequency(float frequency) =>
			FMOD5_Channel_SetFrequency(handle, frequency);
		public RESULT GetFrequency(out float frequency) =>
			FMOD5_Channel_GetFrequency(handle, out frequency);
		public RESULT SetPriority(int32 priority) =>
			FMOD5_Channel_SetPriority(handle, priority);
		public RESULT GetPriority(out int32 priority) =>
			FMOD5_Channel_GetPriority(handle, out priority);
		public RESULT SetPosition(uint32 position, TIMEUNIT postype) =>
			FMOD5_Channel_SetPosition(handle, position, postype);
		public RESULT GetPosition(out uint32 position, TIMEUNIT postype) =>
			FMOD5_Channel_GetPosition(handle, out position, postype);
		public RESULT SetChannelGroup(ChannelGroup channelgroup) =>
			FMOD5_Channel_SetChannelGroup(handle, channelgroup.handle);
		public RESULT GetChannelGroup(out ChannelGroup channelgroup) =>
			FMOD5_Channel_GetChannelGroup(handle, out channelgroup.handle);
		public RESULT SetLoopCount(int32 loopcount) =>
			FMOD5_Channel_SetLoopCount(handle, loopcount);
		public RESULT GetLoopCount(out int32 loopcount) =>
			FMOD5_Channel_GetLoopCount(handle, out loopcount);
		public RESULT SetLoopPoints(uint32 loopstart, TIMEUNIT loopstarttype, uint32 loopend, TIMEUNIT loopendtype) =>
			FMOD5_Channel_SetLoopPoints(handle, loopstart, loopstarttype, loopend, loopendtype);
		public RESULT GetLoopPoints(out uint32 loopstart, TIMEUNIT loopstarttype, out uint32 loopend, TIMEUNIT loopendtype) =>
			FMOD5_Channel_GetLoopPoints(handle, out loopstart, loopstarttype, out loopend, loopendtype);

		// Information only functions.
		public RESULT IsVirtual(out bool isvirtual) =>
			FMOD5_Channel_IsVirtual(handle, out isvirtual);
		public RESULT GetCurrentSound(out Sound sound) =>
			FMOD5_Channel_GetCurrentSound(handle, out sound.handle);
		public RESULT GetIndex(out int32 index) =>
			FMOD5_Channel_GetIndex(handle, out index);

		public RESULT GetSystemObject(out System system) =>
			FMOD5_Channel_GetSystemObject(handle, out system.handle);

		// General control functionality for Channels and ChannelGroups.
		public RESULT Stop() =>
			FMOD5_Channel_Stop(handle);
		public RESULT SetPaused(bool paused) =>
			FMOD5_Channel_SetPaused(handle, paused);
		public RESULT GetPaused(out bool paused) =>
			FMOD5_Channel_GetPaused(handle, out paused);
		public RESULT SetVolume(float volume) =>
			FMOD5_Channel_SetVolume(handle, volume);
		public RESULT GetVolume(out float volume) =>
			FMOD5_Channel_GetVolume(handle, out volume);
		public RESULT SetVolumeRamp(bool ramp) =>
			FMOD5_Channel_SetVolumeRamp(handle, ramp);
		public RESULT GetVolumeRamp(out bool ramp) =>
			FMOD5_Channel_GetVolumeRamp(handle, out ramp);
		public RESULT GetAudibility(out float audibility) =>
			FMOD5_Channel_GetAudibility(handle, out audibility);
		public RESULT SetPitch(float pitch) =>
			FMOD5_Channel_SetPitch(handle, pitch);
		public RESULT GetPitch(out float pitch) =>
			FMOD5_Channel_GetPitch(handle, out pitch);
		public RESULT SetMute(bool mute) =>
			FMOD5_Channel_SetMute(handle, mute);
		public RESULT GetMute(out bool mute) =>
			FMOD5_Channel_GetMute(handle, out mute);
		public RESULT SetReverbProperties(int32 instance, float wet) =>
			FMOD5_Channel_SetReverbProperties(handle, instance, wet);
		public RESULT GetReverbProperties(int32 instance, out float wet) =>
			FMOD5_Channel_GetReverbProperties(handle, instance, out wet);
		public RESULT SetLowPassGain(float gain) =>
			FMOD5_Channel_SetLowPassGain(handle, gain);
		public RESULT GetLowPassGain(out float gain) =>
			FMOD5_Channel_GetLowPassGain(handle, out gain);
		public RESULT SetMode(MODE mode) =>
			FMOD5_Channel_SetMode(handle, mode);
		public RESULT GetMode(out MODE mode) =>
			FMOD5_Channel_GetMode(handle, out mode);
		public RESULT SetCallback(CHANNELCONTROL_CALLBACK callback) =>
			FMOD5_Channel_SetCallback(handle, callback);
		public RESULT IsPlaying(out bool isplaying) =>
			FMOD5_Channel_IsPlaying(handle, out isplaying);

		// Note all 'set' functions alter a final matrix, this is why the only get function is getMixMatrix, to avoid other get functions returning incorrect/obsolete values.
		public RESULT SetPan(float pan) =>
			FMOD5_Channel_SetPan(handle, pan);
		public RESULT SetMixLevelsOutput(float frontleft, float frontright, float center, float lfe, float surroundleft, float surroundright, float backleft, float backright) =>
			FMOD5_Channel_SetMixLevelsOutput(handle, frontleft, frontright, center, lfe, surroundleft, surroundright, backleft, backright);
		public RESULT SetMixLevelsInput(float[] levels, int32 numlevels) =>
			FMOD5_Channel_SetMixLevelsInput(handle, levels, numlevels);
		public RESULT SetMixMatrix(float[] matrix, int32 outchannels, int32 inchannels, int32 inchannel_hop = 0) =>
			FMOD5_Channel_SetMixMatrix(handle, matrix, outchannels, inchannels, inchannel_hop);
		public RESULT GetMixMatrix(float[] matrix, out int32 outchannels, out int32 inchannels, int32 inchannel_hop = 0) =>
			FMOD5_Channel_GetMixMatrix(handle, matrix, out outchannels, out inchannels, inchannel_hop);

		// Clock based functionality.
		public RESULT GetDSPClock(out uint64 dspclock, out uint64 parentclock) =>
			FMOD5_Channel_GetDSPClock(handle, out dspclock, out parentclock);
		public RESULT SetDelay(uint64 dspclock_start, uint64 dspclock_end, bool stopchannels = true) =>
			FMOD5_Channel_SetDelay(handle, dspclock_start, dspclock_end, stopchannels);
		public RESULT GetDelay(out uint64 dspclock_start, out uint64 dspclock_end) =>
			FMOD5_Channel_GetDelay(handle, out dspclock_start, out dspclock_end, null);
		public RESULT GetDelay(out uint64 dspclock_start, out uint64 dspclock_end, out bool stopchannels) =>
			FMOD5_Channel_GetDelay(handle, out dspclock_start, out dspclock_end, out stopchannels);
		public RESULT AddFadePoint(uint64 dspclock, float volume) =>
			FMOD5_Channel_AddFadePoint(handle, dspclock, volume);
		public RESULT SetFadePointRamp(uint64 dspclock, float volume) =>
			FMOD5_Channel_SetFadePointRamp(handle, dspclock, volume);
		public RESULT RemoveFadePoints(uint64 dspclock_start, uint64 dspclock_end) =>
			FMOD5_Channel_RemoveFadePoints(handle, dspclock_start, dspclock_end);
		public RESULT GetFadePoints(ref uint32 numpoints, uint64[] point_dspclock, float[] point_volume) =>
			FMOD5_Channel_GetFadePoints(handle, ref numpoints, point_dspclock, point_volume);

		// DSP effects.
		public RESULT GetDSP(int32 index, out DSP dsp) =>
			FMOD5_Channel_GetDSP(handle, index, out dsp.handle);
		public RESULT AddDSP(int32 index, DSP dsp) =>
			FMOD5_Channel_AddDSP(handle, index, dsp.handle);
		public RESULT RemoveDSP(DSP dsp) =>
			FMOD5_Channel_RemoveDSP(handle, dsp.handle);
		public RESULT GetNumDSPs(out int32 numdsps) =>
			FMOD5_Channel_GetNumDSPs(handle, out numdsps);
		public RESULT SetDSPIndex(DSP dsp, int32 index) =>
			FMOD5_Channel_SetDSPIndex(handle, dsp.handle, index);
		public RESULT GetDSPIndex(DSP dsp, out int32 index) =>
			FMOD5_Channel_GetDSPIndex(handle, dsp.handle, out index);

		// 3D functionality.
		public RESULT Set3DAttributes(ref VECTOR pos, ref VECTOR vel) =>
			FMOD5_Channel_Set3DAttributes(handle, ref pos, ref vel);
		public RESULT Get3DAttributes(out VECTOR pos, out VECTOR vel) =>
			FMOD5_Channel_Get3DAttributes(handle, out pos, out vel);
		public RESULT Set3DMinMaxDistance(float mindistance, float maxdistance) =>
			FMOD5_Channel_Set3DMinMaxDistance(handle, mindistance, maxdistance);
		public RESULT Get3DMinMaxDistance(out float mindistance, out float maxdistance) =>
			FMOD5_Channel_Get3DMinMaxDistance(handle, out mindistance, out maxdistance);
		public RESULT Set3DConeSettings(float insideconeangle, float outsideconeangle, float outsidevolume) =>
			FMOD5_Channel_Set3DConeSettings(handle, insideconeangle, outsideconeangle, outsidevolume);
		public RESULT Get3DConeSettings(out float insideconeangle, out float outsideconeangle, out float outsidevolume) =>
			FMOD5_Channel_Get3DConeSettings(handle, out insideconeangle, out outsideconeangle, out outsidevolume);
		public RESULT Set3DConeOrientation(ref VECTOR orientation) =>
			FMOD5_Channel_Set3DConeOrientation(handle, ref orientation);
		public RESULT Get3DConeOrientation(out VECTOR orientation) =>
			FMOD5_Channel_Get3DConeOrientation(handle, out orientation);
		public RESULT Set3DCustomRolloff(ref VECTOR points, int32 numpoints) =>
			FMOD5_Channel_Set3DCustomRolloff(handle, ref points, numpoints);
		public RESULT Get3DCustomRolloff(out void* points, out int32 numpoints) =>
			FMOD5_Channel_Get3DCustomRolloff(handle, out points, out numpoints);
		public RESULT Set3DOcclusion(float directocclusion, float reverbocclusion) =>
			FMOD5_Channel_Set3DOcclusion(handle, directocclusion, reverbocclusion);
		public RESULT Get3DOcclusion(out float directocclusion, out float reverbocclusion) =>
			FMOD5_Channel_Get3DOcclusion(handle, out directocclusion, out reverbocclusion);
		public RESULT Set3DSpread(float angle) =>
			FMOD5_Channel_Set3DSpread(handle, angle);
		public RESULT Get3DSpread(out float angle) =>
			FMOD5_Channel_Get3DSpread(handle, out angle);
		public RESULT Set3DLevel(float level) =>
			FMOD5_Channel_Set3DLevel(handle, level);
		public RESULT Get3DLevel(out float level) =>
			FMOD5_Channel_Get3DLevel(handle, out level);
		public RESULT Set3DDopplerLevel(float level) =>
			FMOD5_Channel_Set3DDopplerLevel(handle, level);
		public RESULT Get3DDopplerLevel(out float level) =>
			FMOD5_Channel_Get3DDopplerLevel(handle, out level);
		public RESULT Set3DDistanceFilter(bool custom, float customLevel, float centerFreq) =>
			FMOD5_Channel_Set3DDistanceFilter(handle, custom, customLevel, centerFreq);
		public RESULT Get3DDistanceFilter(out bool custom, out float customLevel, out float centerFreq) =>
			FMOD5_Channel_Get3DDistanceFilter(handle, out custom, out customLevel, out centerFreq);

		// Userdata set/get.
		public RESULT SetUserData(void* userdata) =>
			FMOD5_Channel_SetUserData(handle, userdata);
		public RESULT GetUserData(out void* userdata) =>
			FMOD5_Channel_GetUserData(handle, out userdata);

		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetFrequency(void* channel, float frequency);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetFrequency(void* channel, out float frequency);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetPriority(void* channel, int32 priority);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetPriority(void* channel, out int32 priority);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetPosition(void* channel, uint32 position, TIMEUNIT postype);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetPosition(void* channel, out uint32 position, TIMEUNIT postype);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetChannelGroup(void* channel, void* channelgroup);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetChannelGroup(void* channel, out void* channelgroup);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetLoopCount(void* channel, int32 loopcount);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetLoopCount(void* channel, out int32 loopcount);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetLoopPoints(void* channel, uint32 loopstart, TIMEUNIT loopstarttype, uint32 loopend, TIMEUNIT loopendtype);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetLoopPoints(void* channel, out uint32 loopstart, TIMEUNIT loopstarttype, out uint32 loopend, TIMEUNIT loopendtype);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_IsVirtual(void* channel, out bool isvirtual);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetCurrentSound(void* channel, out void* sound);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetIndex(void* channel, out int32 index);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetSystemObject(void* channel, out void* system);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Stop(void* channel);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetPaused(void* channel, bool paused);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetPaused(void* channel, out bool paused);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetVolume(void* channel, float volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetVolume(void* channel, out float volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetVolumeRamp(void* channel, bool ramp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetVolumeRamp(void* channel, out bool ramp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetAudibility(void* channel, out float audibility);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetPitch(void* channel, float pitch);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetPitch(void* channel, out float pitch);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetMute(void* channel, bool mute);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetMute(void* channel, out bool mute);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetReverbProperties(void* channel, int32 instance, float wet);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetReverbProperties(void* channel, int32 instance, out float wet);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetLowPassGain(void* channel, float gain);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetLowPassGain(void* channel, out float gain);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetMode(void* channel, MODE mode);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetMode(void* channel, out MODE mode);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetCallback(void* channel, CHANNELCONTROL_CALLBACK callback);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_IsPlaying(void* channel, out bool isplaying);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetPan(void* channel, float pan);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetMixLevelsOutput(void* channel, float frontleft, float frontright, float center, float lfe, float surroundleft, float surroundright, float backleft, float backright);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetMixLevelsInput(void* channel, float[] levels, int32 numlevels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetMixMatrix(void* channel, float[] matrix, int32 outchannels, int32 inchannels, int32 inchannel_hop);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetMixMatrix(void* channel, float[] matrix, out int32 outchannels, out int32 inchannels, int32 inchannel_hop);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetDSPClock(void* channel, out uint64 dspclock, out uint64 parentclock);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetDelay(void* channel, uint64 dspclock_start, uint64 dspclock_end, bool stopchannels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetDelay(void* channel, out uint64 dspclock_start, out uint64 dspclock_end, void* zero);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetDelay(void* channel, out uint64 dspclock_start, out uint64 dspclock_end, out bool stopchannels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_AddFadePoint(void* channel, uint64 dspclock, float volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetFadePointRamp(void* channel, uint64 dspclock, float volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_RemoveFadePoints(void* channel, uint64 dspclock_start, uint64 dspclock_end);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetFadePoints(void* channel, ref uint32 numpoints, uint64[] point_dspclock, float[] point_volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetDSP(void* channel, int32 index, out void* dsp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_AddDSP(void* channel, int32 index, void* dsp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_RemoveDSP(void* channel, void* dsp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetNumDSPs(void* channel, out int32 numdsps);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetDSPIndex(void* channel, void* dsp, int32 index);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetDSPIndex(void* channel, void* dsp, out int32 index);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Set3DAttributes(void* channel, ref VECTOR pos, ref VECTOR vel);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Get3DAttributes(void* channel, out VECTOR pos, out VECTOR vel);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Set3DMinMaxDistance(void* channel, float mindistance, float maxdistance);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Get3DMinMaxDistance(void* channel, out float mindistance, out float maxdistance);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Set3DConeSettings(void* channel, float insideconeangle, float outsideconeangle, float outsidevolume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Get3DConeSettings(void* channel, out float insideconeangle, out float outsideconeangle, out float outsidevolume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Set3DConeOrientation(void* channel, ref VECTOR orientation);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Get3DConeOrientation(void* channel, out VECTOR orientation);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Set3DCustomRolloff(void* channel, ref VECTOR points, int32 numpoints);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Get3DCustomRolloff(void* channel, out void* points, out int32 numpoints);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Set3DOcclusion(void* channel, float directocclusion, float reverbocclusion);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Get3DOcclusion(void* channel, out float directocclusion, out float reverbocclusion);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Set3DSpread(void* channel, float angle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Get3DSpread(void* channel, out float angle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Set3DLevel(void* channel, float level);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Get3DLevel(void* channel, out float level);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Set3DDopplerLevel(void* channel, float level);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Get3DDopplerLevel(void* channel, out float level);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Set3DDistanceFilter(void* channel, bool custom, float customLevel, float centerFreq);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_Get3DDistanceFilter(void* channel, out bool custom, out float customLevel, out float centerFreq);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_SetUserData(void* channel, void* userdata);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Channel_GetUserData(void* channel, out void* userdata);
	}

	/*
        'ChannelGroup' API
    */
    public struct ChannelGroup : IChannelControl
    {
        public void* handle;

		public this(void* ptr) { handle = ptr; }
        public bool HasHandle() => handle != null;
        public void ClearHandle() mut { handle = null; }

		public RESULT Release() =>
			FMOD5_ChannelGroup_Release(handle);

		// Nested channel groups.
		public RESULT AddGroup(ChannelGroup group, bool propagatedspclock = true) =>
			FMOD5_ChannelGroup_AddGroup(handle, group.handle, propagatedspclock, null);
		public RESULT AddGroup(ChannelGroup group, bool propagatedspclock, out DSPConnection connection) =>
			FMOD5_ChannelGroup_AddGroup(handle, group.handle, propagatedspclock, out connection.handle);
		public RESULT GetNumGroups(out int32 numgroups) =>
			FMOD5_ChannelGroup_GetNumGroups(handle, out numgroups);
		public RESULT GetGroup(int32 index, out ChannelGroup group) =>
			FMOD5_ChannelGroup_GetGroup(handle, index, out group.handle);
		public RESULT GetParentGroup(out ChannelGroup group) =>
			FMOD5_ChannelGroup_GetParentGroup(handle, out group.handle);

		// Information only functions.
		public RESULT GetName(String name, int32 namelen)
		{
		    char8* stringMem = new char8[namelen]*;

		    RESULT result = FMOD5_ChannelGroup_GetName(handle, stringMem, namelen);
		    name.Append(stringMem);
		    
			delete stringMem;
		    return result;
		}
		public RESULT GetNumChannels(out int32 numchannels) =>
			FMOD5_ChannelGroup_GetNumChannels(handle, out numchannels);
		public RESULT GetChannel(int32 index, out Channel channel) =>
			FMOD5_ChannelGroup_GetChannel(handle, index, out channel.handle);

		public RESULT GetSystemObject(out System system) =>
			FMOD5_ChannelGroup_GetSystemObject(handle, out system.handle);

		// General control functionality for Channels and ChannelGroups.
		public RESULT Stop() =>
			FMOD5_ChannelGroup_Stop(handle);
		public RESULT SetPaused(bool paused) =>
			FMOD5_ChannelGroup_SetPaused(handle, paused);
		public RESULT GetPaused(out bool paused) =>
			FMOD5_ChannelGroup_GetPaused(handle, out paused);
		public RESULT SetVolume(float volume) =>
			FMOD5_ChannelGroup_SetVolume(handle, volume);
		public RESULT GetVolume(out float volume) =>
			FMOD5_ChannelGroup_GetVolume(handle, out volume);
		public RESULT SetVolumeRamp(bool ramp) =>
			FMOD5_ChannelGroup_SetVolumeRamp(handle, ramp);
		public RESULT GetVolumeRamp(out bool ramp) =>
			FMOD5_ChannelGroup_GetVolumeRamp(handle, out ramp);
		public RESULT GetAudibility(out float audibility) =>
			FMOD5_ChannelGroup_GetAudibility(handle, out audibility);
		public RESULT SetPitch(float pitch) =>
			FMOD5_ChannelGroup_SetPitch(handle, pitch);
		public RESULT GetPitch(out float pitch) =>
			FMOD5_ChannelGroup_GetPitch(handle, out pitch);
		public RESULT SetMute(bool mute) =>
			FMOD5_ChannelGroup_SetMute(handle, mute);
		public RESULT GetMute(out bool mute) =>
			FMOD5_ChannelGroup_GetMute(handle, out mute);
		public RESULT SetReverbProperties(int32 instance, float wet) =>
			FMOD5_ChannelGroup_SetReverbProperties(handle, instance, wet);
		public RESULT GetReverbProperties(int32 instance, out float wet) =>
			FMOD5_ChannelGroup_GetReverbProperties(handle, instance, out wet);
		public RESULT SetLowPassGain(float gain) =>
			FMOD5_ChannelGroup_SetLowPassGain(handle, gain);
		public RESULT GetLowPassGain(out float gain) =>
			FMOD5_ChannelGroup_GetLowPassGain(handle, out gain);
		public RESULT SetMode(MODE mode) =>
			FMOD5_ChannelGroup_SetMode(handle, mode);
		public RESULT GetMode(out MODE mode) =>
			FMOD5_ChannelGroup_GetMode(handle, out mode);
		public RESULT SetCallback(CHANNELCONTROL_CALLBACK callback) =>
			FMOD5_ChannelGroup_SetCallback(handle, callback);
		public RESULT IsPlaying(out bool isplaying) =>
			FMOD5_ChannelGroup_IsPlaying(handle, out isplaying);

		// Note all 'set' functions alter a final matrix, this is why the only get function is getMixMatrix, to avoid other get functions returning incorrect/obsolete values.
		public RESULT SetPan(float pan) =>
			FMOD5_ChannelGroup_SetPan(handle, pan);
		public RESULT SetMixLevelsOutput(float frontleft, float frontright, float center, float lfe, float surroundleft, float surroundright, float backleft, float backright) =>
			FMOD5_ChannelGroup_SetMixLevelsOutput(handle, frontleft, frontright, center, lfe, surroundleft, surroundright, backleft, backright);
		public RESULT SetMixLevelsInput(float[] levels, int32 numlevels) =>
			FMOD5_ChannelGroup_SetMixLevelsInput(handle, levels, numlevels);
		public RESULT SetMixMatrix(float[] matrix, int32 outchannels, int32 inchannels, int32 inchannel_hop) =>
			FMOD5_ChannelGroup_SetMixMatrix(handle, matrix, outchannels, inchannels, inchannel_hop);
		public RESULT GetMixMatrix(float[] matrix, out int32 outchannels, out int32 inchannels, int32 inchannel_hop) =>
			FMOD5_ChannelGroup_GetMixMatrix(handle, matrix, out outchannels, out inchannels, inchannel_hop);

		// Clock based functionality.
		public RESULT GetDSPClock(out uint64 dspclock, out uint64 parentclock) =>
			FMOD5_ChannelGroup_GetDSPClock(handle, out dspclock, out parentclock);
		public RESULT SetDelay(uint64 dspclock_start, uint64 dspclock_end, bool stopchannels) =>
			FMOD5_ChannelGroup_SetDelay(handle, dspclock_start, dspclock_end, stopchannels);
		public RESULT GetDelay(out uint64 dspclock_start, out uint64 dspclock_end) =>
			FMOD5_ChannelGroup_GetDelay(handle, out dspclock_start, out dspclock_end, null);
		public RESULT GetDelay(out uint64 dspclock_start, out uint64 dspclock_end, out bool stopchannels) =>
			FMOD5_ChannelGroup_GetDelay(handle, out dspclock_start, out dspclock_end, out stopchannels);
		public RESULT AddFadePoint(uint64 dspclock, float volume) =>
			FMOD5_ChannelGroup_AddFadePoint(handle, dspclock, volume);
		public RESULT SetFadePointRamp(uint64 dspclock, float volume) =>
			FMOD5_ChannelGroup_SetFadePointRamp(handle, dspclock, volume);
		public RESULT RemoveFadePoints(uint64 dspclock_start, uint64 dspclock_end) =>
			FMOD5_ChannelGroup_RemoveFadePoints(handle, dspclock_start, dspclock_end);
		public RESULT GetFadePoints(ref uint32 numpoints, uint64[] point_dspclock, float[] point_volume) =>
			FMOD5_ChannelGroup_GetFadePoints(handle, ref numpoints, point_dspclock, point_volume);

		// DSP effects.
		public RESULT GetDSP(int32 index, out DSP dsp) =>
			FMOD5_ChannelGroup_GetDSP(handle, index, out dsp.handle);
		public RESULT AddDSP(int32 index, DSP dsp) =>
			FMOD5_ChannelGroup_AddDSP(handle, index, dsp.handle);
		public RESULT RemoveDSP(DSP dsp) =>
			FMOD5_ChannelGroup_RemoveDSP(handle, dsp.handle);
		public RESULT GetNumDSPs(out int32 numdsps) =>
			FMOD5_ChannelGroup_GetNumDSPs(handle, out numdsps);
		public RESULT SetDSPIndex(DSP dsp, int32 index) =>
			FMOD5_ChannelGroup_SetDSPIndex(handle, dsp.handle, index);
		public RESULT GetDSPIndex(DSP dsp, out int32 index) =>
			FMOD5_ChannelGroup_GetDSPIndex(handle, dsp.handle, out index);

		// 3D functionality.
		public RESULT Set3DAttributes(ref VECTOR pos, ref VECTOR vel) =>
			FMOD5_ChannelGroup_Set3DAttributes(handle, ref pos, ref vel);
		public RESULT Get3DAttributes(out VECTOR pos, out VECTOR vel) =>
			FMOD5_ChannelGroup_Get3DAttributes(handle, out pos, out vel);
		public RESULT Set3DMinMaxDistance(float mindistance, float maxdistance) =>
			FMOD5_ChannelGroup_Set3DMinMaxDistance(handle, mindistance, maxdistance);
		public RESULT Get3DMinMaxDistance(out float mindistance, out float maxdistance) =>
			FMOD5_ChannelGroup_Get3DMinMaxDistance(handle, out mindistance, out maxdistance);
		public RESULT Set3DConeSettings(float insideconeangle, float outsideconeangle, float outsidevolume) =>
			FMOD5_ChannelGroup_Set3DConeSettings(handle, insideconeangle, outsideconeangle, outsidevolume);
		public RESULT Get3DConeSettings(out float insideconeangle, out float outsideconeangle, out float outsidevolume) =>
			FMOD5_ChannelGroup_Get3DConeSettings(handle, out insideconeangle, out outsideconeangle, out outsidevolume);
		public RESULT Set3DConeOrientation(ref VECTOR orientation) =>
			FMOD5_ChannelGroup_Set3DConeOrientation(handle, ref orientation);
		public RESULT Get3DConeOrientation(out VECTOR orientation) =>
			FMOD5_ChannelGroup_Get3DConeOrientation(handle, out orientation);
		public RESULT Set3DCustomRolloff(ref VECTOR points, int32 numpoints) =>
			FMOD5_ChannelGroup_Set3DCustomRolloff(handle, ref points, numpoints);
		public RESULT Get3DCustomRolloff(out void* points, out int32 numpoints) =>
			FMOD5_ChannelGroup_Get3DCustomRolloff(handle, out points, out numpoints);
		public RESULT Set3DOcclusion(float directocclusion, float reverbocclusion) =>
			FMOD5_ChannelGroup_Set3DOcclusion(handle, directocclusion, reverbocclusion);
		public RESULT Get3DOcclusion(out float directocclusion, out float reverbocclusion) =>
			FMOD5_ChannelGroup_Get3DOcclusion(handle, out directocclusion, out reverbocclusion);
		public RESULT Set3DSpread(float angle) =>
			FMOD5_ChannelGroup_Set3DSpread(handle, angle);	
		public RESULT Get3DSpread(out float angle) =>
			FMOD5_ChannelGroup_Get3DSpread(handle, out angle);
		public RESULT Set3DLevel(float level) =>
			FMOD5_ChannelGroup_Set3DLevel(handle, level);
		public RESULT Get3DLevel(out float level) =>
			FMOD5_ChannelGroup_Get3DLevel(handle, out level);
		public RESULT Set3DDopplerLevel(float level) =>
			FMOD5_ChannelGroup_Set3DDopplerLevel(handle, level);
		public RESULT Get3DDopplerLevel(out float level) =>
			FMOD5_ChannelGroup_Get3DDopplerLevel(handle, out level);
		public RESULT Set3DDistanceFilter(bool custom, float customLevel, float centerFreq) =>
			FMOD5_ChannelGroup_Set3DDistanceFilter(handle, custom, customLevel, centerFreq);
		public RESULT Get3DDistanceFilter(out bool custom, out float customLevel, out float centerFreq) =>
			FMOD5_ChannelGroup_Get3DDistanceFilter(handle, out custom, out customLevel, out centerFreq);

		// Userdata set/get.
		public RESULT SetUserData(void* userdata) =>
			FMOD5_ChannelGroup_SetUserData(handle, userdata);
		public RESULT GetUserData(out void* userdata) =>
			FMOD5_ChannelGroup_GetUserData(handle, out userdata);

		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Release(void* channelgroup);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_AddGroup(void* channelgroup, void* group, bool propagatedspclock, void* zero);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_AddGroup(void* channelgroup, void* group, bool propagatedspclock, out void* connection);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetNumGroups(void* channelgroup, out int32 numgroups);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetGroup(void* channelgroup, int32 index, out void* group);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetParentGroup(void* channelgroup, out void* group);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetName(void* channelgroup, void* name, int32 namelen);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetNumChannels(void* channelgroup, out int32 numchannels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetChannel(void* channelgroup, int32 index, out void* channel);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetSystemObject(void* channelgroup, out void* system);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Stop(void* channelgroup);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetPaused(void* channelgroup, bool paused);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetPaused(void* channelgroup, out bool paused);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetVolume(void* channelgroup, float volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetVolume(void* channelgroup, out float volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetVolumeRamp(void* channelgroup, bool ramp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetVolumeRamp(void* channelgroup, out bool ramp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetAudibility(void* channelgroup, out float audibility);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetPitch(void* channelgroup, float pitch);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetPitch(void* channelgroup, out float pitch);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetMute(void* channelgroup, bool mute);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetMute(void* channelgroup, out bool mute);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetReverbProperties(void* channelgroup, int32 instance, float wet);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetReverbProperties(void* channelgroup, int32 instance, out float wet);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetLowPassGain(void* channelgroup, float gain);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetLowPassGain(void* channelgroup, out float gain);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetMode(void* channelgroup, MODE mode);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetMode(void* channelgroup, out MODE mode);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetCallback(void* channelgroup, CHANNELCONTROL_CALLBACK callback);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_IsPlaying(void* channelgroup, out bool isplaying);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetPan(void* channelgroup, float pan);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetMixLevelsOutput(void* channelgroup, float frontleft, float frontright, float center, float lfe, float surroundleft, float surroundright, float backleft, float backright);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetMixLevelsInput(void* channelgroup, float[] levels, int32 numlevels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetMixMatrix(void* channelgroup, float[] matrix, int32 outchannels, int32 inchannels, int32 inchannel_hop);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetMixMatrix(void* channelgroup, float[] matrix, out int32 outchannels, out int32 inchannels, int32 inchannel_hop);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetDSPClock(void* channelgroup, out uint64 dspclock, out uint64 parentclock);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetDelay(void* channelgroup, uint64 dspclock_start, uint64 dspclock_end, bool stopchannels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetDelay(void* channelgroup, out uint64 dspclock_start, out uint64 dspclock_end, void* zero);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetDelay(void* channelgroup, out uint64 dspclock_start, out uint64 dspclock_end, out bool stopchannels);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_AddFadePoint(void* channelgroup, uint64 dspclock, float volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetFadePointRamp(void* channelgroup, uint64 dspclock, float volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_RemoveFadePoints(void* channelgroup, uint64 dspclock_start, uint64 dspclock_end);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetFadePoints(void* channelgroup, ref uint32 numpoints, uint64[] point_dspclock, float[] point_volume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetDSP(void* channelgroup, int32 index, out void* dsp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_AddDSP(void* channelgroup, int32 index, void* dsp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_RemoveDSP(void* channelgroup, void* dsp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetNumDSPs(void* channelgroup, out int32 numdsps);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetDSPIndex(void* channelgroup, void* dsp, int32 index);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetDSPIndex(void* channelgroup, void* dsp, out int32 index);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Set3DAttributes(void* channelgroup, ref VECTOR pos, ref VECTOR vel);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Get3DAttributes(void* channelgroup, out VECTOR pos, out VECTOR vel);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Set3DMinMaxDistance(void* channelgroup, float mindistance, float maxdistance);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Get3DMinMaxDistance(void* channelgroup, out float mindistance, out float maxdistance);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Set3DConeSettings(void* channelgroup, float insideconeangle, float outsideconeangle, float outsidevolume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Get3DConeSettings(void* channelgroup, out float insideconeangle, out float outsideconeangle, out float outsidevolume);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Set3DConeOrientation(void* channelgroup, ref VECTOR orientation);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Get3DConeOrientation(void* channelgroup, out VECTOR orientation);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Set3DCustomRolloff(void* channelgroup, ref VECTOR points, int32 numpoints);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Get3DCustomRolloff(void* channelgroup, out void* points, out int32 numpoints);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Set3DOcclusion(void* channelgroup, float directocclusion, float reverbocclusion);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Get3DOcclusion(void* channelgroup, out float directocclusion, out float reverbocclusion);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Set3DSpread(void* channelgroup, float angle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Get3DSpread(void* channelgroup, out float angle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Set3DLevel(void* channelgroup, float level);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Get3DLevel(void* channelgroup, out float level);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Set3DDopplerLevel(void* channelgroup, float level);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Get3DDopplerLevel(void* channelgroup, out float level);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Set3DDistanceFilter(void* channelgroup, bool custom, float customLevel, float centerFreq);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_Get3DDistanceFilter(void* channelgroup, out bool custom, out float customLevel, out float centerFreq);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_SetUserData(void* channelgroup, void* userdata);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_ChannelGroup_GetUserData(void* channelgroup, out void* userdata);
	}

	/*
        'SoundGroup' API
    */
    public struct SoundGroup
    {
        public void* handle;

		public this(void* ptr) { handle = ptr; }
        public bool HasHandle() => handle != null;
        public void ClearHandle() mut { handle = null; }

		public RESULT Release() =>
			FMOD5_SoundGroup_Release(handle);

		public RESULT GetSystemObject(out System system) =>
			FMOD5_SoundGroup_GetSystemObject(handle, out system.handle);

		// SoundGroup control functions.
		public RESULT SetMaxAudible(int32 maxaudible) =>
			FMOD5_SoundGroup_SetMaxAudible(handle, maxaudible);
		public RESULT GetMaxAudible(out int32 maxaudible) =>
			FMOD5_SoundGroup_GetMaxAudible(handle, out maxaudible);
		public RESULT SetMaxAudibleBehavior(SOUNDGROUP_BEHAVIOR behavior) =>
			FMOD5_SoundGroup_SetMaxAudibleBehavior(handle, behavior);
		public RESULT GetMaxAudibleBehavior(out SOUNDGROUP_BEHAVIOR behavior) =>
			FMOD5_SoundGroup_GetMaxAudibleBehavior(handle, out behavior);
		public RESULT SetMuteFadeSpeed(float speed) =>
			FMOD5_SoundGroup_SetMuteFadeSpeed(handle, speed);
		public RESULT GetMuteFadeSpeed(out float speed) =>
			FMOD5_SoundGroup_GetMuteFadeSpeed(handle, out speed);
		public RESULT SetVolume(float volume) =>
			FMOD5_SoundGroup_SetVolume(handle, volume);
		public RESULT GetVolume(out float volume) =>
			FMOD5_SoundGroup_GetVolume(handle, out volume);
		public RESULT Stop() =>
			FMOD5_SoundGroup_Stop(handle);

		// Information only functions.
		public RESULT GetName(String name, int32 namelen)
		{
		    char8* stringMem = new char8[namelen]*;

		    RESULT result = FMOD5_SoundGroup_GetName(handle, stringMem, namelen);
		    name.Append(stringMem);

		    delete stringMem;
		    return result;
		}
		public RESULT GetNumSounds(out int32 numsounds) =>
			FMOD5_SoundGroup_GetNumSounds(handle, out numsounds);
		public RESULT GetSound(int32 index, out Sound sound) =>
			FMOD5_SoundGroup_GetSound(handle, index, out sound.handle);
		public RESULT GetNumPlaying(out int32 numplaying) =>
			FMOD5_SoundGroup_GetNumPlaying(handle, out numplaying);

		// Userdata set/get.
		public RESULT SetUserData(void* userdata) =>
			FMOD5_SoundGroup_SetUserData(handle, userdata);
		public RESULT GetUserData(out void* userdata) =>
			FMOD5_SoundGroup_GetUserData(handle, out userdata);

        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_Release(void* soundgroup);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_GetSystemObject(void* soundgroup, out void* system);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_SetMaxAudible(void* soundgroup, int32 maxaudible);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_GetMaxAudible(void* soundgroup, out int32 maxaudible);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_SetMaxAudibleBehavior(void* soundgroup, SOUNDGROUP_BEHAVIOR behavior);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_GetMaxAudibleBehavior(void* soundgroup, out SOUNDGROUP_BEHAVIOR behavior);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_SetMuteFadeSpeed(void* soundgroup, float speed);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_GetMuteFadeSpeed(void* soundgroup, out float speed);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_SetVolume(void* soundgroup, float volume);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_GetVolume(void* soundgroup, out float volume);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_Stop(void* soundgroup);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_GetName(void* soundgroup, void* name, int32 namelen);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_GetNumSounds(void* soundgroup, out int32 numsounds);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_GetSound(void* soundgroup, int32 index, out void* sound);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_GetNumPlaying(void* soundgroup, out int32 numplaying);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_SetUserData(void* soundgroup, void* userdata);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_SoundGroup_GetUserData(void* soundgroup, out void* userdata);
	}

	/*
        'DSP' API
    */
    public struct DSP
    {
        public void* handle;

		public this(void* ptr) { handle = ptr; }
        public bool HasHandle() => handle != null;
        public void ClearHandle() mut { handle = null; }

		public RESULT Release() =>
			FMOD5_DSP_Release(handle);
		public RESULT GetSystemObject(out System system) =>
			FMOD5_DSP_GetSystemObject(handle, out system.handle);

		// Connection / disconnection / input and output enumeration.
		public RESULT AddInput(DSP input) =>
			FMOD5_DSP_AddInput(handle, input.handle, null, .STANDARD);
		public RESULT AddInput(DSP input, out DSPConnection connection, DSPCONNECTION_TYPE type = .STANDARD) =>
			FMOD5_DSP_AddInput(handle, input.handle, out connection.handle, type);
		public RESULT DisconnectFrom(DSP target, DSPConnection connection) =>
			FMOD5_DSP_DisconnectFrom(handle, target.handle, connection.handle);
		public RESULT DisconnectAll(bool inputs, bool outputs) =>
			FMOD5_DSP_DisconnectAll(handle, inputs, outputs);
		public RESULT GetNumInputs(out int32 numinputs) =>
			FMOD5_DSP_GetNumInputs(handle, out numinputs);
		public RESULT GetNumOutputs(out int32 numoutputs) =>
			FMOD5_DSP_GetNumOutputs(handle, out numoutputs);
		public RESULT GetInput(int32 index, out DSP input, out DSPConnection inputconnection) =>
			FMOD5_DSP_GetInput(handle, index, out input.handle, out inputconnection.handle);
		public RESULT GetOutput(int32 index, out DSP output, out DSPConnection outputconnection) =>
			FMOD5_DSP_GetOutput(handle, index, out output.handle, out outputconnection.handle);

		// DSP unit control.
		public RESULT SetActive(bool active) =>
			FMOD5_DSP_SetActive(handle, active);
		public RESULT GetActive(out bool active) =>
			FMOD5_DSP_GetActive(handle, out active);
		public RESULT SetBypass(bool bypass) =>
			FMOD5_DSP_SetBypass(handle, bypass);
		public RESULT GetBypass(out bool bypass) =>
			FMOD5_DSP_GetBypass(handle, out bypass);
		public RESULT SetWetDryMix(float prewet, float postwet, float dry) =>
			FMOD5_DSP_SetWetDryMix(handle, prewet, postwet, dry);
		public RESULT GetWetDryMix(out float prewet, out float postwet, out float dry) =>
			FMOD5_DSP_GetWetDryMix(handle, out prewet, out postwet, out dry);
		public RESULT SetChannelFormat(CHANNELMASK channelmask, int32 numchannels, SPEAKERMODE source_speakermode) =>
			FMOD5_DSP_SetChannelFormat(handle, channelmask, numchannels, source_speakermode);
		public RESULT GetChannelFormat(out CHANNELMASK channelmask, out int32 numchannels, out SPEAKERMODE source_speakermode) =>
			FMOD5_DSP_GetChannelFormat(handle, out channelmask, out numchannels, out source_speakermode);
		public RESULT GetOutputChannelFormat(CHANNELMASK inmask, int32 inchannels, SPEAKERMODE inspeakermode, out CHANNELMASK outmask, out int32 outchannels, out SPEAKERMODE outspeakermode) =>
			FMOD5_DSP_GetOutputChannelFormat(handle, inmask, inchannels, inspeakermode, out outmask, out outchannels, out outspeakermode);
		public RESULT Reset() =>
			FMOD5_DSP_Reset(handle);
		public RESULT SetCallback(DSP_CALLBACK callback) =>
			FMOD5_DSP_SetCallback(handle, callback);

		// DSP parameter control.
		public RESULT SetParameterFloat(int32 index, float value) =>
			FMOD5_DSP_SetParameterFloat(handle, index, value);
		public RESULT SetParameterInt(int32 index, int32 value) =>
			FMOD5_DSP_SetParameterInt(handle, index, value);
		public RESULT SetParameterBool(int32 index, bool value) =>
			FMOD5_DSP_SetParameterBool(handle, index, value);
		public RESULT SetParameterData(int32 index, uint8[] data) =>
			FMOD5_DSP_SetParameterData(handle, index, &data[0], (uint32)data.Count);
		public RESULT GetParameterFloat(int32 index, out float value) =>
			FMOD5_DSP_GetParameterFloat(handle, index, out value, null, 0);
		public RESULT GetParameterInt(int32 index, out int32 value) =>
			FMOD5_DSP_GetParameterInt(handle, index, out value, null, 0);
		public RESULT GetParameterBool(int32 index, out bool value) =>
			FMOD5_DSP_GetParameterBool(handle, index, out value, null, 0);
		public RESULT GetParameterData(int32 index, out void* data, out uint32 length) =>
			FMOD5_DSP_GetParameterData(handle, index, out data, out length, null, 0);
		public RESULT GetNumParameters(out int32 numparams) =>
			FMOD5_DSP_GetNumParameters(handle, out numparams);
		public RESULT GetParameterInfo(int32 index, out FMOD_DSP.PARAMETER_DESC desc) =>
			FMOD5_DSP_GetParameterInfo(handle, index, out desc);
		public RESULT GetDataParameterIndex(int32 datatype, out int32 index) =>
			FMOD5_DSP_GetDataParameterIndex(handle, datatype, out index);
		public RESULT ShowConfigDialog(void* hwnd, bool show) =>
			FMOD5_DSP_ShowConfigDialog(handle, hwnd, show);

		//  DSP attributes.
		public RESULT GetInfo(String name, out uint32 version, out int32 channels, out int32 configwidth, out int32 configheight)
		{
		    char8* nameMem = new char8[32]*;

		    RESULT result = FMOD5_DSP_GetInfo(handle, nameMem, out version, out channels, out configwidth, out configheight);
		    name.Append(nameMem);

		    delete nameMem;
		    return result;
		}
		public RESULT GetInfo(out uint32 version, out int32 channels, out int32 configwidth, out int32 configheight) =>
			FMOD5_DSP_GetInfo(handle, null, out version, out channels, out configwidth, out configheight);
		public RESULT GetType(out FMOD_DSP.TYPE type) =>
			FMOD5_DSP_GetType(handle, out type);
		public RESULT GetIdle(out bool idle) =>
			FMOD5_DSP_GetIdle(handle, out idle);

		// Userdata set/get.
		public RESULT SetUserData(void* userdata) =>
			FMOD5_DSP_SetUserData(handle, userdata);
		public RESULT GetUserData(out void* userdata) =>
			FMOD5_DSP_GetUserData(handle, out userdata);

		// Metering.
		public RESULT SetMeteringEnabled(bool inputEnabled, bool outputEnabled) =>
			FMOD5_DSP_SetMeteringEnabled(handle, inputEnabled, outputEnabled);
		public RESULT GetMeteringEnabled(out bool inputEnabled, out bool outputEnabled) =>
			FMOD5_DSP_GetMeteringEnabled(handle, out inputEnabled, out outputEnabled);
		public RESULT GetMeteringInfo(void* zero, out FMOD_DSP.METERING_INFO outputInfo) =>
			FMOD5_DSP_GetMeteringInfo(handle, zero, out outputInfo);
		public RESULT GetMeteringInfo(out FMOD_DSP.METERING_INFO inputInfo, void* zero) =>
			FMOD5_DSP_GetMeteringInfo(handle, out inputInfo, zero);
		public RESULT GetMeteringInfo(out FMOD_DSP.METERING_INFO inputInfo, out FMOD_DSP.METERING_INFO outputInfo) =>
			FMOD5_DSP_GetMeteringInfo(handle, out inputInfo, out outputInfo);

		public RESULT GetCPUUsage(out uint32 exclusive, out uint32 inclusive) =>
			FMOD5_DSP_GetCPUUsage(handle, out exclusive, out inclusive);
		
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_Release(void* dsp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetSystemObject(void* dsp, out void* system);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_AddInput(void* dsp, void* input, void* zero, DSPCONNECTION_TYPE type);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_AddInput(void* dsp, void* input, out void* connection, DSPCONNECTION_TYPE type);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_DisconnectFrom(void* dsp, void* target, void* connection);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_DisconnectAll(void* dsp, bool inputs, bool outputs);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetNumInputs(void* dsp, out int32 numinputs);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetNumOutputs(void* dsp, out int32 numoutputs);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetInput(void* dsp, int32 index, out void* input, out void* inputconnection);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetOutput(void* dsp, int32 index, out void* output, out void* outputconnection);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_SetActive(void* dsp, bool active);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetActive(void* dsp, out bool active);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_SetBypass(void* dsp, bool bypass);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetBypass(void* dsp, out bool bypass);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_SetWetDryMix(void* dsp, float prewet, float postwet, float dry);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetWetDryMix(void* dsp, out float prewet, out float postwet, out float dry);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_SetChannelFormat(void* dsp, CHANNELMASK channelmask, int32 numchannels, SPEAKERMODE source_speakermode);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetChannelFormat(void* dsp, out CHANNELMASK channelmask, out int32 numchannels, out SPEAKERMODE source_speakermode);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetOutputChannelFormat(void* dsp, CHANNELMASK inmask, int32 inchannels, SPEAKERMODE inspeakermode, out CHANNELMASK outmask, out int32 outchannels, out SPEAKERMODE outspeakermode);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_Reset(void* dsp);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_SetCallback(void* dsp, DSP_CALLBACK callback);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_SetParameterFloat(void* dsp, int32 index, float value);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_SetParameterInt(void* dsp, int32 index, int32 value);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_SetParameterBool(void* dsp, int32 index, bool value);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_SetParameterData(void* dsp, int32 index, void* data, uint32 length);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetParameterFloat(void* dsp, int32 index, out float value, void* valuestr, int32 valuestrlen);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetParameterInt(void* dsp, int32 index, out int32 value, void* valuestr, int32 valuestrlen);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetParameterBool(void* dsp, int32 index, out bool value, void* valuestr, int32 valuestrlen);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetParameterData(void* dsp, int32 index, out void* data, out uint32 length, void* valuestr, int32 valuestrlen);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetNumParameters(void* dsp, out int32 numparams);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetParameterInfo(void* dsp, int32 index, out FMOD_DSP.PARAMETER_DESC desc);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetDataParameterIndex(void* dsp, int32 datatype, out int32 index);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_ShowConfigDialog(void* dsp, void* hwnd, bool show);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetInfo(void* dsp, void* name, out uint32 version, out int32 channels, out int32 configwidth, out int32 configheight);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetType(void* dsp, out FMOD_DSP.TYPE type);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetIdle(void* dsp, out bool idle);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_SetUserData(void* dsp, void* userdata);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_DSP_GetUserData(void* dsp, out void* userdata);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		public static extern RESULT FMOD5_DSP_SetMeteringEnabled(void* dsp, bool inputEnabled, bool outputEnabled);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		public static extern RESULT FMOD5_DSP_GetMeteringEnabled(void* dsp, out bool inputEnabled, out bool outputEnabled);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		public static extern RESULT FMOD5_DSP_GetMeteringInfo(void* dsp, void* zero, out FMOD_DSP.METERING_INFO outputInfo);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		public static extern RESULT FMOD5_DSP_GetMeteringInfo(void* dsp, out FMOD_DSP.METERING_INFO inputInfo, void* zero);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		public static extern RESULT FMOD5_DSP_GetMeteringInfo(void* dsp, out FMOD_DSP.METERING_INFO inputInfo, out FMOD_DSP.METERING_INFO outputInfo);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		public static extern RESULT FMOD5_DSP_GetCPUUsage(void* dsp, out uint32 exclusive, out uint32 inclusive);
	}

	/*
        'DSPConnection' API
    */
    public struct DSPConnection
    {
        public void* handle;

		public this(void* ptr) { handle = ptr; }
        public bool HasHandle() => handle != null;
        public void ClearHandle() mut { handle = null; }

        public RESULT GetInput(out DSP input) =>
			FMOD5_DSPConnection_GetInput(handle, out input.handle);
        public RESULT GetOutput(out DSP output) =>
			FMOD5_DSPConnection_GetOutput(handle, out output.handle);
        public RESULT SetMix(float volume) =>
			FMOD5_DSPConnection_SetMix(handle, volume);
        public RESULT GetMix(out float volume) =>
			FMOD5_DSPConnection_GetMix(handle, out volume);
        public RESULT SetMixMatrix(float[] matrix, int32 outchannels, int32 inchannels, int32 inchannel_hop = 0) =>
			FMOD5_DSPConnection_SetMixMatrix(handle, matrix, outchannels, inchannels, inchannel_hop);
        public RESULT GetMixMatrix(float[] matrix, out int32 outchannels, out int32 inchannels, int32 inchannel_hop = 0) =>
			FMOD5_DSPConnection_GetMixMatrix(handle, matrix, out outchannels, out inchannels, inchannel_hop);
        public RESULT GetType(out DSPCONNECTION_TYPE type) =>
			FMOD5_DSPConnection_GetType(handle, out type);

		// Userdata set/get.
        public RESULT SetUserData(void* userdata) =>
			FMOD5_DSPConnection_SetUserData(handle, userdata);
        public RESULT GetUserData(out void* userdata) =>
			FMOD5_DSPConnection_GetUserData(handle, out userdata);

        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_DSPConnection_GetInput(void* dspconnection, out void* input);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_DSPConnection_GetOutput(void* dspconnection, out void* output);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_DSPConnection_SetMix(void* dspconnection, float volume);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_DSPConnection_GetMix(void* dspconnection, out float volume);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_DSPConnection_SetMixMatrix(void* dspconnection, float[] matrix, int32 outchannels, int32 inchannels, int32 inchannel_hop);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_DSPConnection_GetMixMatrix(void* dspconnection, float[] matrix, out int32 outchannels, out int32 inchannels, int32 inchannel_hop);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_DSPConnection_GetType(void* dspconnection, out DSPCONNECTION_TYPE type);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_DSPConnection_SetUserData(void* dspconnection, void* userdata);
        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_DSPConnection_GetUserData(void* dspconnection, out void* userdata);
	}

	/*
        'Geometry' API
    */
    public struct Geometry
    {
        public void* handle;

		public this(void* ptr) { handle = ptr; }
        public bool HasHandle() => handle != null;
        public void ClearHandle() mut { handle = null; }
		
		public RESULT Release() =>
			FMOD5_Geometry_Release(handle);

		// Polygon manipulation.
		public RESULT AddPolygon(float directocclusion, float reverbocclusion, bool doublesided, int32 numvertices, VECTOR[] vertices, out int32 polygonindex) =>
			FMOD5_Geometry_AddPolygon(handle, directocclusion, reverbocclusion, doublesided, numvertices, vertices, out polygonindex);
		public RESULT GetNumPolygons(out int32 numpolygons) =>
			FMOD5_Geometry_GetNumPolygons(handle, out numpolygons);
		public RESULT GetMaxPolygons(out int32 maxpolygons, out int32 maxvertices) =>
			FMOD5_Geometry_GetMaxPolygons(handle, out maxpolygons, out maxvertices);
		public RESULT GetPolygonNumVertices(int32 index, out int32 numvertices) =>
			FMOD5_Geometry_GetPolygonNumVertices(handle, index, out numvertices);
		public RESULT SetPolygonVertex(int32 index, int32 vertexindex, ref VECTOR vertex) =>
			FMOD5_Geometry_SetPolygonVertex(handle, index, vertexindex, ref vertex);
		public RESULT GetPolygonVertex(int32 index, int32 vertexindex, out VECTOR vertex) =>
			FMOD5_Geometry_GetPolygonVertex(handle, index, vertexindex, out vertex);
		public RESULT SetPolygonAttributes(int32 index, float directocclusion, float reverbocclusion, bool doublesided) =>
			FMOD5_Geometry_SetPolygonAttributes(handle, index, directocclusion, reverbocclusion, doublesided);
		public RESULT GetPolygonAttributes(int32 index, out float directocclusion, out float reverbocclusion, out bool doublesided) =>
			FMOD5_Geometry_GetPolygonAttributes(handle, index, out directocclusion, out reverbocclusion, out doublesided);

		// Object manipulation.
		public RESULT SetActive(bool active) =>
			FMOD5_Geometry_SetActive(handle, active);
		public RESULT GetActive(out bool active) =>
			FMOD5_Geometry_GetActive(handle, out active);
		public RESULT SetRotation(ref VECTOR forward, ref VECTOR up) =>
			FMOD5_Geometry_SetRotation(handle, ref forward, ref up);
		public RESULT GetRotation(out VECTOR forward, out VECTOR up) =>
			FMOD5_Geometry_GetRotation(handle, out forward, out up);
		public RESULT SetPosition(ref VECTOR position) =>
			FMOD5_Geometry_SetPosition(handle, ref position);
		public RESULT GetPosition(out VECTOR position) =>
			FMOD5_Geometry_GetPosition(handle, out position);
		public RESULT SetScale(ref VECTOR scale) =>
			FMOD5_Geometry_SetScale(handle, ref scale);
		public RESULT GetScale(out VECTOR scale) =>
			FMOD5_Geometry_GetScale(handle, out scale);
		public RESULT Save(void* data, out int32 datasize) =>
			FMOD5_Geometry_Save(handle, data, out datasize);

		// Userdata set/get.
		public RESULT SetUserData(void* userdata) =>
			FMOD5_Geometry_SetUserData(handle, userdata);
		public RESULT getUserData(out void* userdata) =>
			FMOD5_Geometry_GetUserData(handle, out userdata);

        [Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_Release(void* geometry);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_AddPolygon(void* geometry, float directocclusion, float reverbocclusion, bool doublesided, int32 numvertices, VECTOR[] vertices, out int32 polygonindex);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_GetNumPolygons(void* geometry, out int32 numpolygons);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_GetMaxPolygons(void* geometry, out int32 maxpolygons, out int32 maxvertices);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_GetPolygonNumVertices(void* geometry, int32 index, out int32 numvertices);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_SetPolygonVertex(void* geometry, int32 index, int32 vertexindex, ref VECTOR vertex);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_GetPolygonVertex(void* geometry, int32 index, int32 vertexindex, out VECTOR vertex);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_SetPolygonAttributes(void* geometry, int32 index, float directocclusion, float reverbocclusion, bool doublesided);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_GetPolygonAttributes(void* geometry, int32 index, out float directocclusion, out float reverbocclusion, out bool doublesided);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_SetActive(void* geometry, bool active);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_GetActive(void* geometry, out bool active);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_SetRotation(void* geometry, ref VECTOR forward, ref VECTOR up);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_GetRotation(void* geometry, out VECTOR forward, out VECTOR up);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_SetPosition(void* geometry, ref VECTOR position);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_GetPosition(void* geometry, out VECTOR position);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_SetScale(void* geometry, ref VECTOR scale);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_GetScale(void* geometry, out VECTOR scale);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_Save(void* geometry, void* data, out int32 datasize);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_SetUserData(void* geometry, void* userdata);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
        private static extern RESULT FMOD5_Geometry_GetUserData(void* geometry, out void* userdata);
	}

	/*
        'Reverb3D' API
    */
    public struct Reverb3D
    {
        public void* handle;

		public this(void* ptr) { handle = ptr; }
        public bool HasHandle() => handle != null;
        public void ClearHandle() mut { handle = null; }

		public RESULT Release() =>
			FMOD5_Reverb3D_Release(handle);

		// Reverb manipulation.
		public RESULT Set3DAttributes(ref VECTOR position, float mindistance, float maxdistance) =>
			FMOD5_Reverb3D_Set3DAttributes(handle, ref position, mindistance, maxdistance);
		public RESULT Get3DAttributes(ref VECTOR position, ref float mindistance, ref float maxdistance) =>
			FMOD5_Reverb3D_Get3DAttributes(handle, ref position, ref mindistance, ref maxdistance);
		public RESULT SetProperties(ref REVERB_PROPERTIES properties) =>
			FMOD5_Reverb3D_SetProperties(handle, ref properties);
		public RESULT GetProperties(ref REVERB_PROPERTIES properties) =>
			FMOD5_Reverb3D_GetProperties(handle, ref properties);
		public RESULT SetActive(bool active) =>
			FMOD5_Reverb3D_SetActive(handle, active);
		public RESULT GetActive(out bool active) =>
			FMOD5_Reverb3D_GetActive(handle, out active);

		// Userdata set/get.
		public RESULT SetUserData(void* userdata) =>
			FMOD5_Reverb3D_SetUserData(handle, userdata);
		public RESULT GetUserData(out void* userdata) =>
			FMOD5_Reverb3D_GetUserData(handle, out userdata);

		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Reverb3D_Release(void* reverb3d);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Reverb3D_Set3DAttributes(void* reverb3d, ref VECTOR position, float mindistance, float maxdistance);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Reverb3D_Get3DAttributes(void* reverb3d, ref VECTOR position, ref float mindistance, ref float maxdistance);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Reverb3D_SetProperties(void* reverb3d, ref REVERB_PROPERTIES properties);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Reverb3D_GetProperties(void* reverb3d, ref REVERB_PROPERTIES properties);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Reverb3D_SetActive(void* reverb3d, bool active);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Reverb3D_GetActive(void* reverb3d, out bool active);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Reverb3D_SetUserData(void* reverb3d, void* userdata);
		[Import(VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern RESULT FMOD5_Reverb3D_GetUserData(void* reverb3d, out void* userdata);
	}
}