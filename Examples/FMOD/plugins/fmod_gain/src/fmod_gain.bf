/*==============================================================================
Gain DSP Plugin Example
Copyright (c), Firelight Technologies Pty, Ltd 2004-2023.

This example shows how to create a simple gain DSP effect.
==============================================================================*/
namespace fmod_gain;

using Beef_FMOD;
using System;

#define FMOD_GAIN_USEPROCESSCALLBACK

/*
FMOD plugins have 2 methods of processing data.
1. via a 'read' callback which is compatible with FMOD Ex but limited in functionality, or
2. via a 'process' callback which exposes more functionality, like masks and query before process early out logic.
*/

public static
{
	public const float FMOD_GAIN_PARAM_GAIN_MIN     = -80.0f;
	public const float FMOD_GAIN_PARAM_GAIN_MAX     = 10.0f;
	public const float FMOD_GAIN_PARAM_GAIN_DEFAULT = 0.0f;
	public const int32 FMOD_GAIN_RAMPCOUNT          = 256;

	public const int32 FMOD_GAIN_PARAM_GAIN     = 0;
	public const int32 FMOD_GAIN_PARAM_INVERT   = 1;
	public const int32 FMOD_GAIN_NUM_PARAMETERS = 2;

	static float[] gain_mapping_values = new .[5]( -80, -50, -30, -10, 10 ) ~ delete _;
	static float[] gain_mapping_scale  = new .[5](   0,   2,   4,   7, 11 ) ~ delete _;

	[Export, CLink, CallingConvention(.Stdcall)]
	public static FMOD_DSP.DESCRIPTION* FMODGetDSPDescription()
	{
	    FMOD_DSP.INIT_PARAMDESC_FLOAT_WITH_MAPPING!(out fmod_gain.p_gain, "Gain\0", "dB\0", "Gain in dB.  -80 to 10.  Default = 0\0", FMOD_GAIN_PARAM_GAIN_DEFAULT, gain_mapping_values, gain_mapping_scale);
	    FMOD_DSP.INIT_PARAMDESC_BOOL!(out fmod_gain.p_invert, "Invert\0", "\0", "Invert signal.  Default = off\0", false, null);
	    return &fmod_gain.FMOD_Gain_Desc;
	}

	public static mixin DECIBELS_TO_LINEAR(float dbval)
	{
		float result;

		if (dbval <= FMOD_GAIN_PARAM_GAIN_MIN)
			result = 0.0f;
		else
			result = 20.0f * Math.Pow(10.0f, dbval / 20.0f);

		result
	}

	public static mixin LINEAR_TO_DECIBELS(float linval)
	{
		float result;

		if (linval <= 0.0f)
			result = FMOD_GAIN_PARAM_GAIN_MIN;
		else
			result = 20.0f * Math.Log10(linval);

		result
	}
}

static class fmod_gain
{
	public static bool FMOD_Gain_Running = false;
	public static FMOD_DSP.PARAMETER_DESC p_gain;
	public static FMOD_DSP.PARAMETER_DESC p_invert;

	public static FMOD_DSP.PARAMETER_DESC*[FMOD_GAIN_NUM_PARAMETERS] FMOD_Gain_dspparam = .(
	    &p_gain,
	    &p_invert
	);

	public static FMOD_DSP.DESCRIPTION FMOD_Gain_Desc = .{
	    PluginSDKVersion  = FMOD_DSP.PLUGIN_SDK_VERSION,
	    Name              = "FMOD Gain\0", // name
	    Version           = 0x00010000,    // plug-in version
	    NumInputBuffers   = 1,             // number of input buffers to process
	    NumOutputBuffers  = 1,             // number of output buffers to process
	    Create            = => FMOD_Gain_dspcreate,
	    Release           = => FMOD_Gain_dsprelease,
	    Reset             = => FMOD_Gain_dspreset,
#if FMOD_GAIN_USEPROCESSCALLBACK
    	Read              = null,
    	Process           = => FMOD_Gain_dspprocess,
#else
   		Read              = => FMOD_Gain_dspread,
    	Process           = null,
#endif
	    SetPosition       = null,
	    NumParameters     = FMOD_GAIN_NUM_PARAMETERS,
	    ParamDesc         = &FMOD_Gain_dspparam[0],
	    SetParameterFloat = => FMOD_Gain_dspsetparamfloat,
	    SetParameterInt   = null, // FMOD_Gain_dspsetparamint,
	    SetParameterBool  = => FMOD_Gain_dspsetparambool,
	    SetParameterData  = null, // FMOD_Gain_dspsetparamdata,
	    GetParameterFloat = => FMOD_Gain_dspgetparamfloat,
	    GetParameterInt   = null, // FMOD_Gain_dspgetparamint,
	    GetParameterBool  = => FMOD_Gain_dspgetparambool,
	    GetParameterData  = null, // FMOD_Gain_dspgetparamdata,
	    ShouldIProcess    = => FMOD_Gain_shouldiprocess,
	    UserData          = null, // userdata
	    SysRegister       = => FMOD_Gain_sys_register,
	    SysDeregister     = => FMOD_Gain_sys_deregister,
	    SysMix            = => FMOD_Gain_sys_mix
	};

	public static FMOD.RESULT FMOD_Gain_dspcreate(ref FMOD_DSP.STATE dsp_state)
	{
	    dsp_state.PluginData = (FMODGainState*)dsp_state.Functions.Alloc(sizeof(FMODGainState), .NORMAL, Compiler.CallerFileName);

	    if (dsp_state.PluginData == null)
	        return .ERR_MEMORY;

	    return .OK;
	}

	public static FMOD.RESULT FMOD_Gain_dsprelease(ref FMOD_DSP.STATE dsp_state)
	{
	    FMODGainState* state = (FMODGainState*)dsp_state.PluginData;
		dsp_state.Functions.Free(state, .NORMAL, Compiler.CallerFileName);
	    return .OK;
	}

#if FMOD_GAIN_USEPROCESSCALLBACK
	public static FMOD.RESULT FMOD_Gain_dspprocess(ref FMOD_DSP.STATE dsp_state, uint32 length, ref FMOD_DSP.BUFFER_ARRAY inbufferarray, ref FMOD_DSP.BUFFER_ARRAY outbufferarray, bool inputsidle, FMOD_DSP.PROCESS_OPERATION op)
	{
	    FMODGainState* state = (FMODGainState*)dsp_state.PluginData;

	    if (op == .PROCESS_QUERY)
	    {
            outbufferarray.BufferNumChannels[0] = inbufferarray.BufferNumChannels[0];
            outbufferarray.SpeakerMode          = inbufferarray.SpeakerMode;

	        if (inputsidle)
	            return .ERR_DSP_DONTPROCESS;
	    }
	    else
	    {
	        (*state).read(ref inbufferarray.Buffers[0], ref outbufferarray.Buffers[0], length, inbufferarray.BufferNumChannels[0]); // input and output channels count match for this effect
	    }

	    return .OK;
	}
#else
	public static FMOD.RESULT FMOD_Gain_dspread(ref FMOD_DSP.STATE dsp_state, ref float[] inbuffer, ref float[] outbuffer, uint32 length, int32 inchannels, int32* outchannels)
	{
	    FMODGainState* state = (FMODGainState*)dsp_state.PluginData;
	    (*state).read(ref inbuffer, ref outbuffer, length, inchannels); // input and output channels count match for this effect
	    return .OK;
	}
#endif

	public static FMOD.RESULT FMOD_Gain_dspreset(ref FMOD_DSP.STATE dsp_state)
	{
	    FMODGainState* state = (FMODGainState*)dsp_state.PluginData;
	    (*state).reset();
	    return .OK;
	}

	public static FMOD.RESULT FMOD_Gain_dspsetparamfloat(ref FMOD_DSP.STATE dsp_state, int32 index, float value)
	{
	    FMODGainState* state = (FMODGainState*)dsp_state.PluginData;

	    switch (index)
	    {
	    case FMOD_GAIN_PARAM_GAIN:
	        (*state).setGain(value);
	        return .OK;
	    }

	    return .ERR_INVALID_PARAM;
	}

	public static FMOD.RESULT FMOD_Gain_dspgetparamfloat(ref FMOD_DSP.STATE dsp_state, int32 index, ref float value, char8* valuestr)
	{
	    FMODGainState* state = (FMODGainState*)dsp_state.PluginData;

	    switch (index)
	    {
	    case FMOD_GAIN_PARAM_GAIN:
			{
				value = (*state).gain();

				if (valuestr != null)
				{
					String tmp = scope .();
					tmp.AppendF("{0:N1} dB", (*state).gain());
					Internal.MemCpy(valuestr, tmp.CStr(), Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length));
					valuestr[Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length)] = '\0';
				}

				return .OK;
			}
	    }

	    return .ERR_INVALID_PARAM;
	}

	public static FMOD.RESULT FMOD_Gain_dspsetparambool(ref FMOD_DSP.STATE dsp_state, int32 index, bool value)
	{
	    FMODGainState* state = (FMODGainState*)dsp_state.PluginData;

	    switch (index)
	    {
	      case FMOD_GAIN_PARAM_INVERT:
	        (*state).setInvert(value ? true : false);
	        return .OK;
	    }

	    return .ERR_INVALID_PARAM;
	}

	public static FMOD.RESULT FMOD_Gain_dspgetparambool(ref FMOD_DSP.STATE dsp_state, int32 index, ref bool value, char8* valuestr)
	{
	    FMODGainState* state = (FMODGainState*)dsp_state.PluginData;

	    switch (index)
	    {
	    case FMOD_GAIN_PARAM_INVERT:
	        value = (*state).invert();

			if (valuestr != null)
			{
				String tmp = scope .();
				tmp.Append((*state).invert() ? "Inverted" : "Off");
				Internal.MemCpy(valuestr, tmp.CStr(), Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length));
				valuestr[Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length)] = '\0';
			}

	        return .OK;
	    }

	    return .ERR_INVALID_PARAM;
	}

	public static FMOD.RESULT FMOD_Gain_shouldiprocess(ref FMOD_DSP.STATE dsp_state, bool inputsidle, uint32 length, FMOD.CHANNELMASK inmask, int32 inchannels, FMOD.SPEAKERMODE speakermode)
	{
	    if (inputsidle)
	    {
	        return .ERR_DSP_DONTPROCESS;
	    }

	    return .OK;
	}


	public static FMOD.RESULT FMOD_Gain_sys_register(ref FMOD_DSP.STATE dsp_state)
	{
	    FMOD_Gain_Running = true;
	    // called once for this type of dsp being loaded or registered (it is not per instance)
	    return .OK;
	}

	public static FMOD.RESULT FMOD_Gain_sys_deregister(ref FMOD_DSP.STATE dsp_state)
	{
	    FMOD_Gain_Running = false;
	    // called once for this type of dsp being unloaded or de-registered (it is not per instance)
	    return .OK;
	}

	public static FMOD.RESULT FMOD_Gain_sys_mix(ref FMOD_DSP.STATE dsp_state, int32 stage)
	{
	    // stage == 0 , before all dsps are processed/mixed, this callback is called once for this type.
	    // stage == 1 , after all dsps are processed/mixed, this callback is called once for this type.
	    return .OK;
	}
}

class FMODGainState
{
    float m_target_gain;
    float m_current_gain;
    int32 m_ramp_samples_left;
    bool m_invert;

	public this()
	{
	    m_target_gain = DECIBELS_TO_LINEAR!(FMOD_GAIN_PARAM_GAIN_DEFAULT);
	    m_invert = false;
	    reset();
	}
	
	public float gain() =>
		LINEAR_TO_DECIBELS!(m_invert ? -m_target_gain : m_target_gain);

	public bool invert() =>
		m_invert;

	public void read(ref float[] inbuffer, ref float[] outbuffer, uint32 length, int32 channels)
	{
		var length;
		// Note: buffers are interleaved
		float gain = m_current_gain;

		int32 offsetOut = 0, offsetIn = 0;

		if (m_ramp_samples_left > 0)
		{
		    float target = m_target_gain;
		    float delta = (target - gain) / m_ramp_samples_left;

		    while (length > 0)
		    {
		        if (--m_ramp_samples_left > 0)
		        {
		            gain += delta;

		            for (int32 i = 0; i < channels; ++i)
		                outbuffer[offsetOut++] = inbuffer[offsetIn++] * gain;
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
		    outbuffer[offsetOut++] = inbuffer[offsetIn++] * gain;

		m_current_gain = gain;
	}

	public void reset()
	{
	    m_current_gain = m_target_gain;
	    m_ramp_samples_left = 0;
	}

	public void setGain(float gain)
	{
		m_target_gain = m_invert ? -DECIBELS_TO_LINEAR!(gain) : DECIBELS_TO_LINEAR!(gain);
		m_ramp_samples_left = FMOD_GAIN_RAMPCOUNT;
	}

	public void setInvert(bool invert)
	{
		if (invert != m_invert)
		{
		    m_target_gain = -m_target_gain;
		    m_ramp_samples_left = FMOD_GAIN_RAMPCOUNT;
		}

		m_invert = invert;
	}
}
