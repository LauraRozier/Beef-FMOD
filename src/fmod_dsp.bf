/* ======================================================================================== */
/* FMOD Core API - DSP header file.                                                         */
/* Copyright (c), Firelight Technologies Pty, Ltd. 2004-2023.                               */
/*                                                                                          */
/* Use this header if you are wanting to develop your own DSP plugin to use with FMODs      */
/* dsp system.  With this header you can make your own DSP plugin that FMOD can             */
/* register and use.  See the documentation and examples on how to make a working plugin.   */
/*                                                                                          */
/* For more detail visit:                                                                   */
/* https://fmod.com/docs/2.02/api/plugin-api-dsp.html                                       */
/* =========================================================================================*/
namespace Beef_FMOD;

using System;

public struct FMOD_DSP
{
	/*
	    DSP Constants
	*/
	public const uint32 PLUGIN_SDK_VERSION               = 110;
	public const uint32 GETPARAM_VALUESTR_LENGTH         = 32;
	public const uint32 LOUDNESS_METER_HISTOGRAM_SAMPLES = 66;

	public enum PROCESS_OPERATION : int32
	{
		PROCESS_PERFORM = 0,
		PROCESS_QUERY
	}

	public enum PAN_SURROUND_FLAGS : int32
	{
		DEFAULT             = 0,
		ROTATION_NOT_BIASED = 1
	}

	public enum PARAMETER_TYPE : int32
	{
		FLOAT = 0,
		INT,
		BOOL,
		DATA,
		MAX
	}

	public enum PARAMETER_FLOAT_MAPPING_TYPE : int32
	{
		LINEAR = 0,
		AUTO,
		PIECEWISE_LINEAR
	}

	public enum PARAMETER_DATA_TYPE : int32
	{
		USER               = 0,
		OVERALLGAIN        = -1,
		ATTRIBUTES3D       = -2,
		SIDECHAIN          = -3,
		FFT                = -4,
		ATTRIBUTES3D_MULTI = -5,
		ATTENUATION_RANGE  = -6
	}

	public enum TYPE : int32
	{
	    UNKNOWN,
	    MIXER,
	    OSCILLATOR,
	    LOWPASS,
	    ITLOWPASS,
	    HIGHPASS,
	    ECHO,
	    FADER,
	    FLANGE,
	    DISTORTION,
	    NORMALIZE,
	    LIMITER,
	    PARAMEQ,
	    PITCHSHIFT,
	    CHORUS,
	    VSTPLUGIN,
	    WINAMPPLUGIN,
	    ITECHO,
	    COMPRESSOR,
	    SFXREVERB,
	    LOWPASS_SIMPLE,
	    DELAY,
	    TREMOLO,
	    LADSPAPLUGIN,
	    SEND,
	    RETURN,
	    HIGHPASS_SIMPLE,
	    PAN,
	    THREE_EQ,
	    FFT,
	    LOUDNESS_METER,
	    ENVELOPEFOLLOWER,
	    CONVOLUTIONREVERB,
	    CHANNELMIX,
	    TRANSCEIVER,
	    OBJECTPAN,
	    MULTIBAND_EQ,
	    MAX
	}

	public enum DSP_PROCESS_OPERATION
	{
	    PROCESS_PERFORM = 0,
	    PROCESS_QUERY
	}

	/*
	    ===================================================================================================

	    FMOD built in effect parameters.  
	    Use DSP::setParameter with these enums for the 'index' parameter.

	    ===================================================================================================
	*/
	public enum OSCILLATOR : int32
	{
		TYPE,
		RATE
	}

	public enum LOWPASS : int32
	{
        CUTOFF,
        RESONANCE
	}

	public enum ITLOWPASS : int32
	{
        CUTOFF,
        RESONANCE
	}

	public enum HIGHPASS : int32
	{
        CUTOFF,
        RESONANCE
	}

	public enum ECHO : int32
	{
        DELAY,
        FEEDBACK,
        DRYLEVEL,
        WETLEVEL
	}

	public enum FADER : int32
	{
        GAIN,
        OVERALL_GAIN,
	}

	public enum FLANGE : int32
	{
        MIX,
        DEPTH,
        RATE
	}

	public enum DISTORTION : int32
	{
        LEVEL
	}

	public enum NORMALIZE : int32
	{
        FADETIME,
        THRESHOLD,
        MAXAMP
	}

	public enum LIMITER : int32
	{
        RELEASETIME,
        CEILING,
        MAXIMIZERGAIN,
        MODE
	}

	public enum PARAMEQ : int32
	{
        CENTER,
        BANDWIDTH,
        GAIN
	}

	public enum MULTIBAND_EQ : int32
	{
        A_FILTER,
        A_FREQUENCY,
        A_Q,
        A_GAIN,
        B_FILTER,
        B_FREQUENCY,
        B_Q,
        B_GAIN,
        C_FILTER,
        C_FREQUENCY,
        C_Q,
        C_GAIN,
        D_FILTER,
        D_FREQUENCY,
        D_Q,
        D_GAIN,
        E_FILTER,
        E_FREQUENCY,
        E_Q,
        E_GAIN
	}

	public enum MULTIBAND_EQ_FILTER_TYPE : int32
	{
        DISABLED,
        LOWPASS_12DB,
        LOWPASS_24DB,
        LOWPASS_48DB,
        HIGHPASS_12DB,
        HIGHPASS_24DB,
        HIGHPASS_48DB,
        LOWSHELF,
        HIGHSHELF,
        PEAKING,
        BANDPASS,
        NOTCH,
        ALLPASS
	}

	public enum PITCHSHIFT : int32
	{
        PITCH,
        FFTSIZE,
        OVERLAP,
        MAXCHANNELS
	}

	public enum CHORUS : int32
	{
        MIX,
        RATE,
        DEPTH
	}

	public enum ITECHO : int32
	{
        WETDRYMIX,
        FEEDBACK,
        LEFTDELAY,
        RIGHTDELAY,
        PANDELAY
	}

	public enum COMPRESSOR : int32
	{
        THRESHOLD,
        RATIO,
        ATTACK,
        RELEASE,
        GAINMAKEUP,
        USESIDECHAIN,
        LINKED
	}

	public enum SFXREVERB : int32
	{
        DECAYTIME,
        EARLYDELAY,
        LATEDELAY,
        HFREFERENCE,
        HFDECAYRATIO,
        DIFFUSION,
        DENSITY,
        LOWSHELFFREQUENCY,
        LOWSHELFGAIN,
        HIGHCUT,
        EARLYLATEMIX,
        WETLEVEL,
        DRYLEVEL
	}

	public enum LOWPASS_SIMPLE : int32
	{
		CUTOFF
	}

	public enum DELAY : int32
	{
        CH0,
        CH1,
        CH2,
        CH3,
        CH4,
        CH5,
        CH6,
        CH7,
        CH8,
        CH9,
        CH10,
        CH11,
        CH12,
        CH13,
        CH14,
        CH15,
        MAXDELAY,
	}

	public enum TREMOLO : int32
	{
        FREQUENCY,
        DEPTH,
        SHAPE,
        SKEW,
        DUTY,
        SQUARE,
        PHASE,
        SPREAD
	}

	public enum SEND : int32
	{
        RETURNID,
        LEVEL
	}

	public enum RETURN : int32
	{
        ID,
        INPUT_SPEAKER_MODE
	}

	public enum HIGHPASS_SIMPLE : int32
	{
		CUTOFF
	}

	public enum PAN_2D_STEREO_MODE_TYPE : int32
	{
        DISTRIBUTED,
        DISCRETE
	}

	public enum PAN_MODE_TYPE : int32
	{
        MONO,
        STEREO,
        SURROUND
	}

	public enum PAN_3D_ROLLOFF_TYPE : int32
	{
        LINEARSQUARED,
        LINEAR,
        INVERSE,
        INVERSETAPERED,
        CUSTOM
	}

	public enum PAN_3D_EXTENT_MODE_TYPE : int32
	{
        AUTO,
        USER,
        OFF
	}

	public enum PAN : int32
	{
        MODE,
        _2D_STEREO_POSITION,
        _2D_DIRECTION,
        _2D_EXTENT,
        _2D_ROTATION,
        _2D_LFE_LEVEL,
        _2D_STEREO_MODE,
        _2D_STEREO_SEPARATION,
        _2D_STEREO_AXIS,
        ENABLED_SPEAKERS,
        _3D_POSITION,
        _3D_ROLLOFF,
        _3D_MIN_DISTANCE,
        _3D_MAX_DISTANCE,
        _3D_EXTENT_MODE,
        _3D_SOUND_SIZE,
        _3D_MIN_EXTENT,
        _3D_PAN_BLEND,
        LFE_UPMIX_ENABLED,
        OVERALL_GAIN,
        SURROUND_SPEAKER_MODE,
        _2D_HEIGHT_BLEND,
        ATTENUATION_RANGE,
        OVERRIDE_RANGE
	}

	public enum THREE_EQ_CROSSOVERSLOPE_TYPE : int32
	{
        _12DB,
        _24DB,
        _48DB
	}

	public enum THREE_EQ : int32
	{
        LOWGAIN,
        MIDGAIN,
        HIGHGAIN,
        LOWCROSSOVER,
        HIGHCROSSOVER,
        CROSSOVERSLOPE
	}

	public enum FFT_WINDOW : int32
	{
        RECT,
        TRIANGLE,
        HAMMING,
        HANNING,
        BLACKMAN,
        BLACKMANHARRIS
	}

	public enum FFT : int32
	{
        WINDOWSIZE,
        WINDOWTYPE,
        SPECTRUMDATA,
        DOMINANT_FREQ
	}

	public enum LOUDNESS_METER : int32
	{
        STATE,
        WEIGHTING,
        INFO
	}

	public enum LOUDNESS_METER_STATE_TYPE : int32
	{
		RESET_INTEGRATED = -3,
		RESET_MAXPEAK    = -2,
		RESET_ALL        = -1,
		PAUSED           = 0,
		ANALYZING        = 1
	}

	public enum ENVELOPEFOLLOWER : int32
	{
        ATTACK,
        RELEASE,
        ENVELOPE,
        USESIDECHAIN
	}
	
	public enum CONVOLUTION_REVERB : int32
	{
        IR,
        WET,
        DRY,
        LINKED
	}
	
	public enum CHANNELMIX_OUTPUT : int32
	{
        DEFAULT,
        ALLMONO,
        ALLSTEREO,
        ALLQUAD,
        ALL5POINT1,
        ALL7POINT1,
        ALLLFE,
        ALL7POINT1POINT4
	}
	
	public enum CHANNELMIX : int32
	{
        OUTPUTGROUPING,
        GAIN_CH0,
        GAIN_CH1,
        GAIN_CH2,
        GAIN_CH3,
        GAIN_CH4,
        GAIN_CH5,
        GAIN_CH6,
        GAIN_CH7,
        GAIN_CH8,
        GAIN_CH9,
        GAIN_CH10,
        GAIN_CH11,
        GAIN_CH12,
        GAIN_CH13,
        GAIN_CH14,
        GAIN_CH15,
        GAIN_CH16,
        GAIN_CH17,
        GAIN_CH18,
        GAIN_CH19,
        GAIN_CH20,
        GAIN_CH21,
        GAIN_CH22,
        GAIN_CH23,
        GAIN_CH24,
        GAIN_CH25,
        GAIN_CH26,
        GAIN_CH27,
        GAIN_CH28,
        GAIN_CH29,
        GAIN_CH30,
        GAIN_CH31,
        OUTPUT_CH0,
        OUTPUT_CH1,
        OUTPUT_CH2,
        OUTPUT_CH3,
        OUTPUT_CH4,
        OUTPUT_CH5,
        OUTPUT_CH6,
        OUTPUT_CH7,
        OUTPUT_CH8,
        OUTPUT_CH9,
        OUTPUT_CH10,
        OUTPUT_CH11,
        OUTPUT_CH12,
        OUTPUT_CH13,
        OUTPUT_CH14,
        OUTPUT_CH15,
        OUTPUT_CH16,
        OUTPUT_CH17,
        OUTPUT_CH18,
        OUTPUT_CH19,
        OUTPUT_CH20,
        OUTPUT_CH21,
        OUTPUT_CH22,
        OUTPUT_CH23,
        OUTPUT_CH24,
        OUTPUT_CH25,
        OUTPUT_CH26,
        OUTPUT_CH27,
        OUTPUT_CH28,
        OUTPUT_CH29,
        OUTPUT_CH30,
        OUTPUT_CH31
	}
	
	public enum TRANSCEIVER_SPEAKERMODE : int32
	{
		AUTO     = -1,
		MONO     = 0,
		STEREO,
		SURROUND
	}
	
	public enum TRANSCEIVER : int32
	{
        TRANSMIT,
        GAIN,
        CHANNEL,
        TRANSMITSPEAKERMODE
	}
	
	public enum OBJECTPAN : int32
	{
        _3D_POSITION,
        _3D_ROLLOFF,
        _3D_MIN_DISTANCE,
        _3D_MAX_DISTANCE,
        _3D_EXTENT_MODE,
        _3D_SOUND_SIZE,
        _3D_MIN_EXTENT,
        OVERALL_GAIN,
        OUTPUTGAIN,
        ATTENUATION_RANGE,
        OVERRIDE_RANGE
	}

	/*
	    DSP Callbacks
	*/
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT CREATE_CALLBACK(ref STATE dsp_state);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT RELEASE_CALLBACK(ref STATE dsp_state);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT RESET_CALLBACK(ref STATE dsp_state);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SETPOSITION_CALLBACK(ref STATE dsp_state, uint32 pos);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT READ_CALLBACK(ref STATE dsp_state, ref float[] inbuffer, ref float[] outbuffer, uint32 length, int32 inchannels, ref int32 outchannels);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SHOULDIPROCESS_CALLBACK(ref STATE dsp_state, bool inputsidle, uint32 length, FMOD.CHANNELMASK inmask, int32 inchannels, FMOD.SPEAKERMODE speakermode);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT PROCESS_CALLBACK(ref STATE dsp_state, uint32 length, ref BUFFER_ARRAY inbufferarray, ref BUFFER_ARRAY outbufferarray, bool inputsidle, DSP_PROCESS_OPERATION op);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SETPARAM_FLOAT_CALLBACK(ref STATE dsp_state, int32 index, float value);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SETPARAM_INT_CALLBACK(ref STATE dsp_state, int32 index, int32 value);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SETPARAM_BOOL_CALLBACK(ref STATE dsp_state, int32 index, bool value);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SETPARAM_DATA_CALLBACK(ref STATE dsp_state, int32 index, void* data, uint32 length);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETPARAM_FLOAT_CALLBACK(ref STATE dsp_state, int32 index, ref float value, char8* valuestr);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETPARAM_INT_CALLBACK(ref STATE dsp_state, int32 index, ref int32 value, char8* valuestr);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETPARAM_BOOL_CALLBACK(ref STATE dsp_state, int32 index, ref bool value, char8* valuestr);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETPARAM_DATA_CALLBACK(ref STATE dsp_state, int32 index, ref void* data, ref uint32 length, char8* valuestr);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SYSTEM_REGISTER_CALLBACK(ref STATE dsp_state);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SYSTEM_DEREGISTER_CALLBACK(ref STATE dsp_state);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SYSTEM_MIX_CALLBACK(ref STATE dsp_state, int32 stage);


	/*
	    DSP Functions
	*/
	[CallingConvention(.Stdcall)]
	public function void* ALLOC_FUNC(uint32 size, FMOD.MEMORY_TYPE type, void* sourcestr);
	[CallingConvention(.Stdcall)]
	public function void* REALLOC_FUNC(void* ptr, uint32 size, FMOD.MEMORY_TYPE type, void* sourcestr);
	[CallingConvention(.Stdcall)]
	public function void FREE_FUNC(void* ptr, FMOD.MEMORY_TYPE type, void* sourcestr);
	[CallingConvention(.Stdcall)]
	public function void LOG_FUNC(FMOD.DEBUG_FLAGS level, void* file, int32 line, void* func, void* str);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETSAMPLERATE_FUNC(ref STATE dsp_state, ref int32 rate);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETBLOCKSIZE_FUNC(ref STATE dsp_state, ref uint32 blocksize);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETSPEAKERMODE_FUNC(ref STATE dsp_state, ref int32 speakermode_mixer, ref int32 speakermode_output);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETCLOCK_FUNC(ref STATE dsp_state, out uint64 clock, out uint32 offset, out uint32 length);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETLISTENERATTRIBUTES_FUNC(ref STATE dsp_state, ref int32 numlisteners, void* attributes);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETUSERDATA_FUNC(ref STATE dsp_state, out void* userdata);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT DFT_FFTREAL_FUNC(ref STATE dsp_state, int32 size, void* signal, void* dft, void* window, int32 signalhop);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT DFT_IFFTREAL_FUNC(ref STATE dsp_state, int32 size, void* dft, void* signal, void* window, int32 signalhop);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT PAN_SUMMONOMATRIX_FUNC(ref STATE dsp_state, int32 sourceSpeakerMode, float lowFrequencyGain, float overallGain, void* matrix);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT PAN_SUMSTEREOMATRIX_FUNC(ref STATE dsp_state, int32 sourceSpeakerMode, float pan, float lowFrequencyGain, float overallGain, int32 matrixHop, void* matrix);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT PAN_SUMSURROUNDMATRIX_FUNC(ref STATE dsp_state, int32 sourceSpeakerMode, int32 targetSpeakerMode, float direction, float extent, float rotation, float lowFrequencyGain, float overallGain, int32 matrixHop, void* matrix, PAN_SURROUND_FLAGS flags);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT PAN_SUMMONOTOSURROUNDMATRIX_FUNC(ref STATE dsp_state, int32 targetSpeakerMode, float direction, float extent, float lowFrequencyGain, float overallGain, int32 matrixHop, void* matrix);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT PAN_SUMSTEREOTOSURROUNDMATRIX_FUNC(ref STATE dsp_state, int32 targetSpeakerMode, float direction, float extent, float rotation, float lowFrequencyGain, float overallGain, int32 matrixHop, void* matrix);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT PAN_GETROLLOFFGAIN_FUNC(ref STATE dsp_state, PAN_3D_ROLLOFF_TYPE rolloff, float distance, float mindistance, float maxdistance, out float gain);

	/*
	    DSP Structures
	*/
	[CRepr]
    public struct BUFFER_ARRAY
    {
        public int32              NumBuffers;
        public int32[]            BufferNumChannels;
        public FMOD.CHANNELMASK[] BufferChannelMask;
        public void*[]            Buffers;
        public FMOD.SPEAKERMODE   SpeakerMode;
    }

	[CRepr]
    public struct COMPLEX
    {
        public float Real;
        public float Imag;
    }

	[CRepr]
	public struct PARAMETER_FLOAT_MAPPING_PIECEWISE_LINEAR
	{
		public int32  NumPoints;
		public float[] PointParamValues;
		public float[] PointPositions;
	}

	[CRepr]
	public struct PARAMETER_FLOAT_MAPPING
	{
		public PARAMETER_FLOAT_MAPPING_TYPE             Type;
		public PARAMETER_FLOAT_MAPPING_PIECEWISE_LINEAR PiecewiseLinearMapping = .();
	}

	[CRepr]
	public struct PARAMETER_DESC_FLOAT
	{
		public float                   Min;
		public float                   Max;
		public float                   DefaultVal;
		public PARAMETER_FLOAT_MAPPING Mapping = .();
	}

	[CRepr]
	public struct PARAMETER_DESC_INT
	{
		public int32    Min;
		public int32    Max;
		public int32    DefaultVal;
		public bool     GoesToInf;
		public char8*[] ValueNames;
	}

	[CRepr]
	public struct PARAMETER_DESC_BOOL
	{
		public bool     DefaultVal;
		public char8*[] ValueNames;
	}

	[CRepr]
	public struct PARAMETER_DESC_DATA
	{
		public int32 DataType;
	}

	[CRepr]
	public struct PARAMETER_DESC
	{
		public PARAMETER_TYPE Type;
		public char8[16]      Name  = .(0,);
		public char8[16]      Label = .(0,);
		public char8*         Description;
		public ParameterDescU Desc  = .();

		[Union]
		public struct ParameterDescU
		{
			public PARAMETER_DESC_FLOAT FloatDesc;
			public PARAMETER_DESC_INT   IntDesc;
			public PARAMETER_DESC_BOOL  BoolDesc;
			public PARAMETER_DESC_DATA  DataDesc;
		}
	}

	[CRepr]
	public struct PARAMETER_OVERALLGAIN
	{
		public float LinearGain;
		public float LinearGainAdditive;
	}

	[CRepr]
	public struct PARAMETER_3DATTRIBUTES
	{
		public FMOD.ATTRIBUTES_3D Relative;
		public FMOD.ATTRIBUTES_3D Absolute;
	}

	[CRepr]
	public struct PARAMETER_3DATTRIBUTES_MULTI
	{
	    public int32                                  NumListeners;
	    public FMOD.ATTRIBUTES_3D[FMOD.MAX_LISTENERS] Relative = .();
	    public float[FMOD.MAX_LISTENERS]              Weight   = .();
	    public FMOD.ATTRIBUTES_3D                     Absolute;
	}

	[CRepr]
	public struct PARAMETER_ATTENUATION_RANGE
	{
	    public float Min;
	    public float Max;
	}

	[CRepr]
	public struct PARAMETER_SIDECHAIN
	{
	    public bool SidechainEnable;
	}

	[CRepr]
	public struct PARAMETER_FFT
	{
	    public int32       Length;
	    public int32       NumChannels;
	    private float*[32] SpectrumInternal = .();

        public void GetSpectrum(ref float[][] buffer)
        {
            int32 bufferLength = Math.Min((int32)buffer.Count, NumChannels);

            for (int32 i = 0; i < bufferLength; ++i)
                GetSpectrum(i, ref buffer[i]);
        }

        public void GetSpectrum(int32 channel, ref float[] buffer)
        {
            int32 bufferLength = Math.Min((int32)buffer.Count, Length);
			Internal.MemCpy(&buffer[0], SpectrumInternal[channel], bufferLength);
        }
	}

	[CRepr]
	public struct DESCRIPTION
	{
        public uint32                     PluginSDKVersion;
        public char8[32]                  Name = .(0,);
        public uint32                     Version;
        public int32                      NumInputBuffers;
        public int32                      NumOutputBuffers;
        public CREATE_CALLBACK            Create;
        public RELEASE_CALLBACK           Release;
        public RESET_CALLBACK             Reset;
        public READ_CALLBACK              Read;
        public PROCESS_CALLBACK           Process;
        public SETPOSITION_CALLBACK       SetPosition;

        public int32                      NumParameters;
        public PARAMETER_DESC**           ParamDesc;
        public SETPARAM_FLOAT_CALLBACK    SetParameterFloat;
        public SETPARAM_INT_CALLBACK      SetParameterInt;
        public SETPARAM_BOOL_CALLBACK     SetParameterBool;
        public SETPARAM_DATA_CALLBACK     SetParameterData;
        public GETPARAM_FLOAT_CALLBACK    GetParameterFloat;
        public GETPARAM_INT_CALLBACK      GetParameterInt;
        public GETPARAM_BOOL_CALLBACK     GetParameterBool;
        public GETPARAM_DATA_CALLBACK     GetParameterData;
        public SHOULDIPROCESS_CALLBACK    ShouldIProcess;
        public void*                      UserData;

        public SYSTEM_REGISTER_CALLBACK   SysRegister;
        public SYSTEM_DEREGISTER_CALLBACK SysDeregister;
        public SYSTEM_MIX_CALLBACK        SysMix;
	}

	[CRepr]
	public struct STATE_DFT_FUNCTIONS
	{
		public DFT_FFTREAL_FUNC  FFTReal;
		public DFT_IFFTREAL_FUNC InverseFFTReal;
	}

	[CRepr]
    public struct STATE_PAN_FUNCTIONS
    {
        public PAN_SUMMONOMATRIX_FUNC             SumMonoMatrix;
        public PAN_SUMSTEREOMATRIX_FUNC           SumStereoMatrix;
        public PAN_SUMSURROUNDMATRIX_FUNC         SumSurroundMatrix;
        public PAN_SUMMONOTOSURROUNDMATRIX_FUNC   SumMonoToSurroundMatrix;
        public PAN_SUMSTEREOTOSURROUNDMATRIX_FUNC SumStereoToSurroundMatrix;
        public PAN_GETROLLOFFGAIN_FUNC            GetRolloffGain;
    }

	[CRepr]
    public struct STATE_FUNCTIONS
    {
        public ALLOC_FUNC                 Alloc;
        public REALLOC_FUNC               Realloc;
        public FREE_FUNC                  Free;
        public GETSAMPLERATE_FUNC         GetSamplerate;
        public GETBLOCKSIZE_FUNC          GetBlockSize;
        public STATE_DFT_FUNCTIONS*       DFT;
        public STATE_PAN_FUNCTIONS*       Pan;
        public GETSPEAKERMODE_FUNC        GetSpeakerMode;
        public GETCLOCK_FUNC              GetClock;
        public GETLISTENERATTRIBUTES_FUNC GetListenerAttributes;
        public LOG_FUNC                   Log;
        public GETUSERDATA_FUNC           GetUserData;
    }

	[CRepr]
	public struct STATE
	{
	    public void*            Instance;
	    public void*            PluginData;
	    public FMOD.CHANNELMASK ChannelMask;
	    public FMOD.SPEAKERMODE SourceSpeakerMode;
	    public void*            SidechainData;
	    public int32            SidechainChannels;
	    public STATE_FUNCTIONS* Functions;
	    public int32            SystemObject;
	}

	[CRepr]
    public struct METERING_INFO
    {
        public int32     NumSamples;
        public float[32] PeakLevel = .(0,);
        public float[32] RmsLevel  = .(0,);
        public int16     NumChannels;
    }

	[CRepr]
	public struct LOUDNESS_METER_INFO_TYPE
	{
		public float                                   MomentaryLoudness;
		public float                                   ShortTermLoudness;
		public float                                   IntegratedLoudness;
		public float                                   Loudness10thPercentile;
		public float                                   Loudness95thPercentile;
		public float[LOUDNESS_METER_HISTOGRAM_SAMPLES] LoudnessHistogram = .();
		public float                                   MaxTruePeak;
		public float                                   MaxMomentaryLoudness;
	}

	[CRepr]
	public struct LOUDNESS_METER_WEIGHTING_TYPE
	{
		public float[32] ChannelWeight = .(0,);
	}

	public static mixin INIT_PARAMDESC_FLOAT(out PARAMETER_DESC paramstruct, StringView name, StringView label, char8* description, float min, float max, float defaultval)
	{
		paramstruct = .{
			Type        = .FLOAT,
			Description = description
		};
		Internal.MemCpy(&paramstruct.Name[0],  name.Ptr,  Math.Min(15, name.Length));
		Internal.MemCpy(&paramstruct.Label[0], label.Ptr, Math.Min(15, label.Length));
		paramstruct.Desc.FloatDesc.Min          = min;
		paramstruct.Desc.FloatDesc.Max          = max;
		paramstruct.Desc.FloatDesc.DefaultVal   = defaultval;
		paramstruct.Desc.FloatDesc.Mapping.Type = .AUTO;
	}

	public static mixin INIT_PARAMDESC_FLOAT_WITH_MAPPING(out PARAMETER_DESC paramstruct, StringView name, StringView label, char8* description, float defaultval, float[] values, float[] positions)
	{
		paramstruct = .{
			Type        = .FLOAT,
			Description = description
		};
		Internal.MemCpy(&paramstruct.Name[0],  name.Ptr,  Math.Min(15, name.Length));
		Internal.MemCpy(&paramstruct.Label[0], label.Ptr, Math.Min(15, label.Length));
		paramstruct.Desc.FloatDesc.Min                                             = values[0];
		paramstruct.Desc.FloatDesc.Max                                             = values[values.Count - 1];
		paramstruct.Desc.FloatDesc.DefaultVal                                      = defaultval;
		paramstruct.Desc.FloatDesc.Mapping.Type                                    = .PIECEWISE_LINEAR;
		paramstruct.Desc.FloatDesc.Mapping.PiecewiseLinearMapping.NumPoints        = (int32)values.Count;
		paramstruct.Desc.FloatDesc.Mapping.PiecewiseLinearMapping.PointParamValues = values;
		paramstruct.Desc.FloatDesc.Mapping.PiecewiseLinearMapping.PointPositions   = positions;
	}

	public static mixin INIT_PARAMDESC_INT(out PARAMETER_DESC paramstruct, StringView name, StringView label, char8* description, int32 min, int32 max, int32 defaultval, bool goestoinf, char8*[] valuenames)
	{
		paramstruct = .{
			Type        = .INT,
			Description = description
		};
		Internal.MemCpy(&paramstruct.Name[0],  name.Ptr,  Math.Min(15, name.Length));
		Internal.MemCpy(&paramstruct.Label[0], label.Ptr, Math.Min(15, label.Length));
		paramstruct.Desc.IntDesc.Min        = min;
		paramstruct.Desc.IntDesc.Max        = max;
		paramstruct.Desc.IntDesc.DefaultVal = defaultval;
		paramstruct.Desc.IntDesc.GoesToInf  = goestoinf;
		paramstruct.Desc.IntDesc.ValueNames = valuenames;
	}

	public static mixin INIT_PARAMDESC_INT_ENUMERATED(out PARAMETER_DESC paramstruct, StringView name, StringView label, char8* description, int32 defaultval, char8*[] valuenames)
	{
		paramstruct = .{
			Type        = .INT,
			Description = description
		};
		Internal.MemCpy(&paramstruct.Name[0],  name.Ptr,  Math.Min(15, name.Length));
		Internal.MemCpy(&paramstruct.Label[0], label.Ptr, Math.Min(15, label.Length));
		paramstruct.Desc.IntDesc.Min        = 0;
		paramstruct.Desc.IntDesc.Max        = (int32)valuenames.Count - 1;
		paramstruct.Desc.IntDesc.DefaultVal = defaultval;
		paramstruct.Desc.IntDesc.GoesToInf  = false;
		paramstruct.Desc.IntDesc.ValueNames = valuenames;
	}

	public static mixin INIT_PARAMDESC_BOOL(out PARAMETER_DESC paramstruct, StringView name, StringView label, char8* description, bool defaultval, char8*[] valuenames)
	{
		paramstruct = .{
			Type        = .BOOL,
			Description = description
		};
		Internal.MemCpy(&paramstruct.Name[0],  name.Ptr,  Math.Min(15, name.Length));
		Internal.MemCpy(&paramstruct.Label[0], label.Ptr, Math.Min(15, label.Length));
		paramstruct.Desc.BoolDesc.DefaultVal = defaultval;
		paramstruct.Desc.BoolDesc.ValueNames = valuenames;
	}

	public static mixin INIT_PARAMDESC_DATA(out PARAMETER_DESC paramstruct, StringView name, StringView label, char8* description, int32 datatype)
	{
		paramstruct = .{
			Type        = .DATA,
			Description = description
		};
		Internal.MemCpy(&paramstruct.Name[0],  name.Ptr,  Math.Min(15, name.Length));
		Internal.MemCpy(&paramstruct.Label[0], label.Ptr, Math.Min(15, label.Length));
		paramstruct.Desc.DataDesc.DataType = datatype;
	}
}
