/*==============================================================================
Plugin Example
Copyright (c), Firelight Technologies Pty, Ltd 2004-2023.

This example shows how to created a plugin effect.
==============================================================================*/
namespace fmod_noise;

using Beef_FMOD;
using System;

public static
{
	[Export, CLink, CallingConvention(.Stdcall)]
	public static FMOD_DSP.DESCRIPTION* FMODGetDSPDescription()
	{
	    FMOD_DSP.INIT_PARAMDESC_FLOAT!(
			out fmod_noise.p_level,
			"Level\0",
			"dB\0",
			"Gain in dB.  -80 to 10.  Default = 0\0",
			fmod_noise.FMOD_NOISE_PARAM_GAIN_MIN,
			fmod_noise.FMOD_NOISE_PARAM_GAIN_MAX,
			fmod_noise.FMOD_NOISE_PARAM_GAIN_DEFAULT
		);
	    FMOD_DSP.INIT_PARAMDESC_INT!(
			out fmod_noise.p_format,
			"Format\0",
			"\0",
			"Mono, stereo or 5.1.  Default = 0 (mono)\0",
			(int32)fmod_noise.FMOD_NOISE_FORMAT.MONO,
			(int32)fmod_noise.FMOD_NOISE_FORMAT._5POINT1,
			(int32)fmod_noise.FMOD_NOISE_FORMAT.MONO,
			false,
			fmod_noise.FMOD_Noise_Format_Names
		);
	    return &fmod_noise.FMOD_Noise_Desc;
	}

	public static mixin DECIBELS_TO_LINEAR(float dbval)
	{
		float result;

		if (dbval <= fmod_noise.FMOD_NOISE_PARAM_GAIN_MIN)
			result = 0.0f;
		else
			result = 20.0f * Math.Pow(10.0f, dbval / 20.0f);

		result
	}

	public static mixin LINEAR_TO_DECIBELS(float linval)
	{
		float result;

		if (linval <= 0.0f)
			result = fmod_noise.FMOD_NOISE_PARAM_GAIN_MIN;
		else
			result = 20.0f * Math.Log10(linval);

		result
	}
}

static class fmod_noise
{
	public const float FMOD_NOISE_PARAM_GAIN_MIN     = -80.0f;
	public const float FMOD_NOISE_PARAM_GAIN_MAX     = 10.0f;
	public const float FMOD_NOISE_PARAM_GAIN_DEFAULT = 0.0f;

	const int32 FMOD_NOISE_RAMPCOUNT = 256;

	enum FMOD_NOISE_PARAM
	{
		LEVEL  = 0,
		FORMAT,
		MAX
	}

	public enum FMOD_NOISE_FORMAT : int32
	{
		MONO     = 0,
		STEREO,
		_5POINT1
	}

	public static char8*[] FMOD_Noise_Format_Names = new char8*[3]("Mono\0", "Stereo\0", "5.1\0") ~ delete _;

	public static FMOD_DSP.PARAMETER_DESC p_level;
	public static FMOD_DSP.PARAMETER_DESC p_format;

	static FMOD_DSP.PARAMETER_DESC*[(int32)FMOD_NOISE_PARAM.MAX] FMOD_Noise_dspparam = .(
	    &p_level,
	    &p_format
	);

	public static FMOD_DSP.DESCRIPTION FMOD_Noise_Desc = .{
	    PluginSDKVersion  = FMOD_DSP.PLUGIN_SDK_VERSION,
	    Name              = "FMOD Noise",   // name
	    Version           = 0x00010000,     // plug-in version
	    NumInputBuffers   = 0,              // number of input buffers to process
	    NumOutputBuffers  = 1,              // number of output buffers to process
	    Create            = => FMOD_Noise_dspcreate,
	    Release           = => FMOD_Noise_dsprelease,
	    Reset             = => FMOD_Noise_dspreset,
	    Read              = null,
	    Process           = => FMOD_Noise_dspprocess,
	    SetPosition       = null,
	    NumParameters     = (int32)FMOD_NOISE_PARAM.MAX,
	    ParamDesc         = &FMOD_Noise_dspparam[0],
	    SetParameterFloat = => FMOD_Noise_dspsetparamfloat,
	    SetParameterInt   = => FMOD_Noise_dspsetparamint,
	    SetParameterBool  = null,
	    SetParameterData  = null,
	    GetParameterFloat = => FMOD_Noise_dspgetparamfloat,
	    GetParameterInt   = => FMOD_Noise_dspgetparamint,
	    GetParameterBool  = null,
	    GetParameterData  = null,
	    ShouldIProcess    = null,
	    UserData          = null,                                      // userdata
	    SysRegister       = null,                                      // Register
	    SysDeregister     = null,                                      // Deregister
	    SysMix            = null                                       // Mix
	};

	class FMODNoiseState
	{
	    float m_target_level;
	    float m_current_level;
	    int32 m_ramp_samples_left;
	    FMOD_NOISE_FORMAT m_format;

		public this()
		{
			m_target_level = DECIBELS_TO_LINEAR!(FMOD_NOISE_PARAM_GAIN_DEFAULT);
			m_format = .MONO;
			reset();
		}
		
		public void setFormat(FMOD_NOISE_FORMAT format)
		{
			m_format = format;
		}

		public float level() =>
			LINEAR_TO_DECIBELS!(m_target_level);

		public FMOD_NOISE_FORMAT format() =>
			m_format;

		public void generate(float[] outbuffer, uint32 length, int32 channels)
		{
			var length;
		    // Note: buffers are interleaved
		    float gain = m_current_level;
			int32 offsetOut = 0;

		    if (m_ramp_samples_left > 0)
		    {
		        float target = m_target_level;
		        float delta = (target - gain) / m_ramp_samples_left;

		        while (length > 0)
		        {
		            if (--m_ramp_samples_left > 0)
		            {
		                gain += delta;

		                for (int i = 0; i < channels; ++i)
		                    outbuffer[offsetOut++] = (((float)(gRand.NextI32() % 32768) / 16384.0f) - 1.0f) * gain;
		            }
		            else
		            {
		                gain = target;
		                break;
		            }

		            --length;
		        }
		    }

		    uint32 samples = length * (uint32)channels;

		    while (samples-- > 0)
		        outbuffer[offsetOut++] = (((float)(gRand.NextI32() % 32768) / 16384.0f) - 1.0f) * gain;

		    m_current_level = gain;
		}

		public void reset()
		{
		    m_current_level     = m_target_level;
		    m_ramp_samples_left = 0;
		}

		public void setLevel(float level)
		{
		    m_target_level      = DECIBELS_TO_LINEAR!(level);
		    m_ramp_samples_left = FMOD_NOISE_RAMPCOUNT;
		}
	}

	static FMOD.RESULT FMOD_Noise_dspcreate(ref FMOD_DSP.STATE dsp)
	{
	    dsp.PluginData = (FMODNoiseState*)dsp.Functions.Alloc(sizeof(FMODNoiseState), .NORMAL, Compiler.CallerFileName);

	    if (dsp.PluginData == null)
	        return .ERR_MEMORY;

	    return .OK;
	}

	static FMOD.RESULT FMOD_Noise_dsprelease(ref FMOD_DSP.STATE dsp)
	{
	    FMODNoiseState* state = (FMODNoiseState*)dsp.PluginData;
		dsp.Functions.Free(state, .NORMAL, Compiler.CallerFileName);
	    return .OK;
	}

	static FMOD.RESULT FMOD_Noise_dspprocess(ref FMOD_DSP.STATE dsp, uint32 length, ref FMOD_DSP.BUFFER_ARRAY inbufferarray, ref FMOD_DSP.BUFFER_ARRAY outbufferarray, bool inputsidle, FMOD_DSP.PROCESS_OPERATION op)
	{
	    FMODNoiseState* state = (FMODNoiseState*)dsp.PluginData;

	    if (op == .PROCESS_QUERY)
	    {
	        FMOD.SPEAKERMODE outmode = .DEFAULT;
	        int32 outchannels = 0;

	        switch((FMOD_NOISE_FORMAT)(*state).format())
	        {
	        case .MONO:
	            outmode = .MONO;
	            outchannels = 1;
	            break;

	        case .STEREO:
	            outmode = .STEREO;
	            outchannels = 2;
	            break;

	        case ._5POINT1:
	            outmode = ._5POINT1;
	            outchannels = 6;
	        }

            outbufferarray.SpeakerMode = outmode;
            outbufferarray.BufferNumChannels[0] = outchannels;
	        return .OK;
	    }

	    (*state).generate(outbufferarray.Buffers[0], length, outbufferarray.BufferNumChannels[0]);
	    return .OK;
	}

	static FMOD.RESULT FMOD_Noise_dspreset(ref FMOD_DSP.STATE dsp)
	{
	    FMODNoiseState* state = (FMODNoiseState*)dsp.PluginData;
	    (*state).reset();
	    return .OK;
	}

	static FMOD.RESULT FMOD_Noise_dspsetparamfloat(ref FMOD_DSP.STATE dsp, int32 index, float value)
	{
	    FMODNoiseState* state = (FMODNoiseState*)dsp.PluginData;

	    switch ((FMOD_NOISE_PARAM)index)
	    {
	    case .LEVEL:
	        (*state).setLevel(value);
	        return .OK;
		default: return .ERR_INVALID_PARAM;
	    }
	}

	static FMOD.RESULT FMOD_Noise_dspgetparamfloat(ref FMOD_DSP.STATE dsp, int32 index, ref float value, char8* valuestr)
	{
	    FMODNoiseState* state = (FMODNoiseState*)dsp.PluginData;
		value = 0.0f;

	    switch ((FMOD_NOISE_PARAM)index)
	    {
	    case .LEVEL:
	        value = (*state).level();

			if (valuestr != null)
			{
				String tmp = scope .();
				tmp.AppendF("{0:N1} dB", (*state).level());
				Internal.MemCpy(valuestr, tmp.CStr(), Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length));
				valuestr[Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length)] = '\0';
			}

	        return .OK;
		default: return .ERR_INVALID_PARAM;
	    }
	}

	static FMOD.RESULT FMOD_Noise_dspsetparamint(ref FMOD_DSP.STATE dsp, int32 index, int32 value)
	{
	    FMODNoiseState* state = (FMODNoiseState*)dsp.PluginData;

	    switch ((FMOD_NOISE_PARAM)index)
	    {
	    case .FORMAT:
	        (*state).setFormat((FMOD_NOISE_FORMAT)value);
	        return .OK;
		default: return .ERR_INVALID_PARAM;
	    }
	}

	static FMOD.RESULT FMOD_Noise_dspgetparamint(ref FMOD_DSP.STATE dsp, int32 index, ref int32 value, char8* valuestr)
	{
	    FMODNoiseState* state = (FMODNoiseState*)dsp.PluginData;
		value = 0;

	    switch ((FMOD_NOISE_PARAM)index)
	    {
	    case .FORMAT:
	        value = (int32)(*state).format();

			if (valuestr != null)
			{
				String tmp = scope .();
				tmp.Append(FMOD_Noise_Format_Names[(int32)(*state).format()]);
				Internal.MemCpy(valuestr, tmp.CStr(), Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length));
				valuestr[Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length)] = '\0';
			}

	        return .OK;
		default: return .ERR_INVALID_PARAM;
	    }
	}
}
