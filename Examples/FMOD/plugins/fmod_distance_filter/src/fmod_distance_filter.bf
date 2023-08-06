/*==============================================================================
Distance Filter DSP Plugin Example
Copyright (c), Firelight Technologies Pty, Ltd 2004-2023.

This example shows how to create a distance filter DSP effect.
==============================================================================*/
namespace fmod_distance_filter;

using Beef_FMOD;
using System;

public static
{
	public const float FMOD_DISTANCE_FILTER_PARAM_MAX_DISTANCE_MIN           = 0.0f;
	public const float FMOD_DISTANCE_FILTER_PARAM_MAX_DISTANCE_MAX           = 10000.0f;
	public const float FMOD_DISTANCE_FILTER_PARAM_MAX_DISTANCE_DEFAULT       = 20.0f;
	public const float FMOD_DISTANCE_FILTER_PARAM_BANDPASS_FREQUENCY_MIN     = 10.0f;
	public const float FMOD_DISTANCE_FILTER_PARAM_BANDPASS_FREQUENCY_MAX     = 22000.0f;
	public const float FMOD_DISTANCE_FILTER_PARAM_BANDPASS_FREQUENCY_DEFAULT = 1500.0f;
	public static float[] distance_mapping_values = new .[7]( 0, 1, 5, 20, 100, 500,    10000 ) ~ delete _;
	public static float[] distance_mapping_scale  = new .[7]( 0, 1, 2,  3,   4,   4.5f,     5 ) ~ delete _;

	[Export, CLink, CallingConvention(.Stdcall)]
	public static FMOD_DSP.DESCRIPTION* FMODGetDSPDescription()
	{
		FMOD_DSP.INIT_PARAMDESC_FLOAT_WITH_MAPPING!(
			out fmod_distance_filter.p_max_distance,
			"Max Dist\0",
			"\0",
			"Distance at which bandpass stops narrowing.  0 to 1000000000.  Default = 100\0",
			FMOD_DISTANCE_FILTER_PARAM_MAX_DISTANCE_DEFAULT,
			distance_mapping_values,
			distance_mapping_scale
		);
		FMOD_DSP.INIT_PARAMDESC_FLOAT!(
			out fmod_distance_filter.p_bandpass_frequency,
			"Frequency\0",
			"Hz\0",
			"Bandpass target frequency.  100 to 10,000Hz.  Default = 2000Hz\0",
			FMOD_DISTANCE_FILTER_PARAM_BANDPASS_FREQUENCY_MIN,
			FMOD_DISTANCE_FILTER_PARAM_BANDPASS_FREQUENCY_MAX,
			FMOD_DISTANCE_FILTER_PARAM_BANDPASS_FREQUENCY_DEFAULT
		);
		FMOD_DSP.INIT_PARAMDESC_DATA!(
			out fmod_distance_filter.p_3d_attributes,
			"3D Attributes\0",
			"\0",
			"\0",
			FMOD_DSP.PARAMETER_DATA_TYPE.ATTRIBUTES3D.Underlying
		);

		return &fmod_distance_filter.FMOD_DistanceFilter_Desc;
	}
}

enum FMOD_DISTANCE_FILTER : int32
{
    MAX_DISTANCE,
    BANDPASS_FREQUENCY,
    ATTRIBUTES_3D,
    NUM_PARAMETERS
}

static class fmod_distance_filter
{
	public static FMOD_DSP.PARAMETER_DESC p_max_distance = .();
	public static FMOD_DSP.PARAMETER_DESC p_bandpass_frequency = .();
	public static FMOD_DSP.PARAMETER_DESC p_3d_attributes = .();

	static FMOD_DSP.PARAMETER_DESC*[FMOD_DISTANCE_FILTER.NUM_PARAMETERS.Underlying] FMOD_DistanceFilter_dspparam = .(
	    &p_max_distance,
	    &p_bandpass_frequency,
	    &p_3d_attributes
	);

	public static FMOD_DSP.DESCRIPTION FMOD_DistanceFilter_Desc = .{
	    PluginSDKVersion  = FMOD_DSP.PLUGIN_SDK_VERSION,
	    Name              = "FMOD Distance Filter\0",               // name
	    Version           = 0x00010000,                             // plugin version
	    NumInputBuffers   = 1,                                      // number of input buffers to process
	    NumOutputBuffers  = 1,                                      // number of output buffers to process
	    Create            = => FMOD_DistanceFilter_dspcreate,
	    Release           = => FMOD_DistanceFilter_dsprelease,
	    Reset             = => FMOD_DistanceFilter_dspreset,
	    Read              = => FMOD_DistanceFilter_dspread,
	    Process           = null, // FMOD_DistanceFilter_dspprocess, // *** declare this callback instead of FMOD_DistanceFilter_dspread if the plugin sets the output channel count ***
	    SetPosition       = null,
	    NumParameters     = FMOD_DISTANCE_FILTER.NUM_PARAMETERS.Underlying,
	    ParamDesc         = &FMOD_DistanceFilter_dspparam[0],
	    SetParameterFloat = => FMOD_DistanceFilter_dspsetparamfloat,
	    SetParameterInt   = null, // FMOD_DistanceFilter_dspsetparamint,
	    SetParameterBool  = null, // FMOD_DistanceFilter_dspsetparambool,
	    SetParameterData  = => FMOD_DistanceFilter_dspsetparamdata,
	    GetParameterFloat = => FMOD_DistanceFilter_dspgetparamfloat,
	    GetParameterInt   = null, // FMOD_DistanceFilter_dspgetparamint,
	    GetParameterBool  = null, // FMOD_DistanceFilter_dspgetparambool,
	    GetParameterData  = => FMOD_DistanceFilter_dspgetparamdata,
	    ShouldIProcess    = => FMOD_DistanceFilter_shouldiprocess,
	    UserData          = null,                                      // userdata
	    SysRegister       = null,                                      // sys_register
	    SysDeregister     = null,                                      // sys_deregister
	    SysMix            = null                                       // sys_mix
	};

	static FMOD.RESULT FMOD_DistanceFilter_dspcreate(ref FMOD_DSP.STATE dsp_state)
	{
	    FMODDistanceFilterState* state = (FMODDistanceFilterState*)dsp_state.Functions.Alloc(sizeof(FMODDistanceFilterState), .NORMAL, Compiler.CallerFileName);
	    (*state).init(ref dsp_state);
	    dsp_state.PluginData = state;

	    if (state == null)
	        return .ERR_MEMORY;

	    return .OK;
	}
	
	static FMOD.RESULT FMOD_DistanceFilter_dsprelease(ref FMOD_DSP.STATE dsp_state)
	{
	    FMODDistanceFilterState* state = (FMODDistanceFilterState*)dsp_state.PluginData;
	    (*state).release(ref dsp_state);
		dsp_state.Functions.Free(state, .NORMAL, Compiler.CallerFileName);
	    return .OK;
	}
	
	static FMOD.RESULT FMOD_DistanceFilter_dspread(ref FMOD_DSP.STATE dsp_state, ref float[] inbuffer, ref float[] outbuffer, uint32 length, int32 inchannels, ref int32 outchannels)
	{
	    FMODDistanceFilterState* state = (FMODDistanceFilterState*)dsp_state.PluginData;
	    return (*state).process(ref inbuffer, ref outbuffer, length, inchannels); // input and output channels count match for this effect
	}
	
	static FMOD.RESULT FMOD_DistanceFilter_dspprocess(ref FMOD_DSP.STATE dsp_state, uint32 length, ref FMOD_DSP.BUFFER_ARRAY inbufferarray, ref FMOD_DSP.BUFFER_ARRAY outbufferarray, bool inputsidle, FMOD_DSP.PROCESS_OPERATION op)
	{
	    FMODDistanceFilterState* state = (FMODDistanceFilterState*)dsp_state.PluginData;
	    return (*state).process(length, ref inbufferarray, ref outbufferarray, inputsidle, op); // as an example for plugins which set the output channel count
	}
	
	static FMOD.RESULT FMOD_DistanceFilter_dspreset(ref FMOD_DSP.STATE dsp_state)
	{
	    FMODDistanceFilterState* state = (FMODDistanceFilterState*)dsp_state.PluginData;
	    (*state).reset();
	    return .OK;
	}
	
	static FMOD.RESULT FMOD_DistanceFilter_dspsetparamfloat(ref FMOD_DSP.STATE dsp_state, int32 index, float value)
	{
	    FMODDistanceFilterState* state = (FMODDistanceFilterState*)dsp_state.PluginData;
	
	    switch ((FMOD_DISTANCE_FILTER)index)
	    {
	    case .MAX_DISTANCE:
	        (*state).setMaxDistance(value);
	        return .OK;
	    case .BANDPASS_FREQUENCY:
	        (*state).setBandpassFrequency(value);
	        return .OK;
		default: return .ERR_INVALID_PARAM;
	    }
	}
	
	static FMOD.RESULT FMOD_DistanceFilter_dspgetparamfloat(ref FMOD_DSP.STATE dsp_state, int32 index, ref float value, char8* valuestr)
	{
	    FMODDistanceFilterState* state = (FMODDistanceFilterState*)dsp_state.PluginData;
	
	    switch ((FMOD_DISTANCE_FILTER)index)
	    {
	    case .MAX_DISTANCE:
			{
		        value = (*state).maxDistance();

				if (valuestr != null)
				{
					String tmp = scope .();
					tmp.AppendF("{0:N1}", (*state).maxDistance());
					Internal.MemCpy(valuestr, tmp.Ptr, Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length));
					valuestr[Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length)] = '\0';
				}
	
		        return .OK;
			}
	    case .BANDPASS_FREQUENCY:
			{
		        value = (*state).bandpassFrequency();

				if (valuestr != null)
				{
					String tmp = scope .();
					tmp.AppendF("{0:N1 Hz}", (*state).bandpassFrequency());
					Internal.MemCpy(valuestr, tmp.Ptr, Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length));
					valuestr[Math.Min(FMOD_DSP.GETPARAM_VALUESTR_LENGTH, tmp.Length)] = '\0';
				}

		        return .OK;
			}
		default: return .ERR_INVALID_PARAM;
	    }
	}
	
	static FMOD.RESULT FMOD_DistanceFilter_dspsetparamdata(ref FMOD_DSP.STATE dsp_state, int32 index, void* data, uint32 length)
	{
	    FMODDistanceFilterState* state = (FMODDistanceFilterState*)dsp_state.PluginData;
	
	    switch ((FMOD_DISTANCE_FILTER)index)
	    {
	    case .ATTRIBUTES_3D:
	        FMOD_DSP.PARAMETER_3DATTRIBUTES* param = (FMOD_DSP.PARAMETER_3DATTRIBUTES*)data;
	        (*state).setDistance(Math.Sqrt(param.Relative.Position.X * param.Relative.Position.X + param.Relative.Position.Y * param.Relative.Position.Y + param.Relative.Position.Z * param.Relative.Position.Z));
	        return .OK;
		default: return .ERR_INVALID_PARAM;
	    }
	}
	
	static FMOD.RESULT FMOD_DistanceFilter_dspgetparamdata(ref FMOD_DSP.STATE dsp_state, int32 index, ref void* value, ref uint32 length, char8* valuestr)
	{
	    switch ((FMOD_DISTANCE_FILTER)index)
	    {
	    case .ATTRIBUTES_3D: return .ERR_INVALID_PARAM;
		default: return .ERR_INVALID_PARAM;
	    }
	}
	
	static FMOD.RESULT FMOD_DistanceFilter_shouldiprocess(ref FMOD_DSP.STATE dsp_state, bool inputsidle, uint32 length, FMOD.CHANNELMASK inmask, int32 inchannels, FMOD.SPEAKERMODE speakermode)
	{
	    if (inputsidle)
	        return .ERR_DSP_DONTPROCESS;
	
	    return .OK;
	}

	class FMODDistanceFilterState
	{
	    float m_max_distance;
	    float m_bandpass_frequency;
	    float m_distance;
	    float m_target_highpass_time_const;
	    float m_current_highpass_time_const;
	    float m_target_lowpass_time_const;
	    float m_current_lowpass_time_const;
	    int32 m_ramp_samples_left;
	    float* m_previous_lp1_out;
	    float* m_previous_lp2_out;
	    float* m_previous_hp_out;
	    int32 m_sample_rate;
	    int32 m_max_channels;

	    public float maxDistance() =>
			m_max_distance;

	    public float bandpassFrequency() =>
			m_bandpass_frequency;

		public void init(ref FMOD_DSP.STATE dsp_state)
		{
			dsp_state.Functions.GetSamplerate(ref dsp_state, ref m_sample_rate);

		    m_max_channels = 8;
		    m_max_distance = FMOD_DISTANCE_FILTER_PARAM_MAX_DISTANCE_DEFAULT;
		    m_bandpass_frequency = FMOD_DISTANCE_FILTER_PARAM_BANDPASS_FREQUENCY_DEFAULT;
		    m_distance = 0;
			
			m_previous_lp1_out = (float*)dsp_state.Functions.Alloc((uint32)(m_max_channels * sizeof(float)), .NORMAL, Compiler.CallerFileName);
		    m_previous_lp2_out = (float*)dsp_state.Functions.Alloc((uint32)(m_max_channels * sizeof(float)), .NORMAL, Compiler.CallerFileName);
		    m_previous_hp_out  = (float*)dsp_state.Functions.Alloc((uint32)(m_max_channels * sizeof(float)), .NORMAL, Compiler.CallerFileName);

		    updateTimeConstants();
		    reset();
		}

		public void release(ref FMOD_DSP.STATE dsp_state)
		{
			dsp_state.Functions.Free(m_previous_lp1_out, .NORMAL, Compiler.CallerFileName);
			dsp_state.Functions.Free(m_previous_lp2_out, .NORMAL, Compiler.CallerFileName);
			dsp_state.Functions.Free(m_previous_hp_out,  .NORMAL, Compiler.CallerFileName);
		}

		public FMOD.RESULT process(ref float[] inbuffer, ref float[] outbuffer, uint32 length, int channels)
		{
			var length;

		    if (channels > m_max_channels)
		        return .ERR_INVALID_PARAM;

		    // Note: buffers are interleaved
		    static float jitter = 1E-20f;
		    float lp1_out, lp2_out;
		    int32 ch;

		    float lp_tc = m_current_lowpass_time_const;
		    float hp_tc = m_current_highpass_time_const;

			int offsetOut = 0;
			int offsetIn = 0;

		    if (m_ramp_samples_left > 0)
		    {
		        float lp_delta = (m_target_lowpass_time_const - m_current_lowpass_time_const) / m_ramp_samples_left;
		        float hp_delta = (m_target_highpass_time_const - m_current_highpass_time_const) / m_ramp_samples_left;

		        while (length > 0)
		        {
		            if (--m_ramp_samples_left > 0)
		            {
		                lp_tc += lp_delta;
		                hp_tc += hp_delta;

		                for (ch = 0; ch < channels; ++ch)
		                {
		                    lp1_out = m_previous_lp1_out[ch] + lp_tc * (inbuffer[offsetIn++] + jitter - m_previous_lp1_out[ch]);
		                    lp2_out = m_previous_lp2_out[ch] + lp_tc * (lp1_out - m_previous_lp2_out[ch]);
		                    outbuffer[offsetOut] = hp_tc * (m_previous_hp_out[ch] + lp2_out - m_previous_lp2_out[ch]);

		                    m_previous_lp1_out[ch] = lp1_out;
		                    m_previous_lp2_out[ch] = lp2_out;
		                    m_previous_hp_out[ch] = outbuffer[offsetOut++];
		                }

		                jitter = -jitter;
		            }
		            else
		            {
		                lp_tc = m_target_lowpass_time_const;
		                hp_tc = m_target_highpass_time_const;
		                break;
		            }

		            --length;
		        }
		    }

		    while (length-- > 0)
		    {
		        for (ch = 0; ch < channels; ++ch)
		        {
		            lp1_out = m_previous_lp1_out[ch] + lp_tc * (inbuffer[offsetIn++] + jitter - m_previous_lp1_out[ch]);
		            lp2_out = m_previous_lp2_out[ch] + lp_tc * (lp1_out - m_previous_lp2_out[ch]);
		            outbuffer[offsetOut] = hp_tc * (m_previous_hp_out[ch] + lp2_out - m_previous_lp2_out[ch]);

		            m_previous_lp1_out[ch] = lp1_out;
		            m_previous_lp2_out[ch] = lp2_out;
		            m_previous_hp_out[ch] = outbuffer[offsetOut++];
		        }
		        jitter = -jitter;
		    }

		    m_current_lowpass_time_const = lp_tc;
		    m_current_highpass_time_const = hp_tc;

		    return .OK;
		}

		public FMOD.RESULT process(uint32 length, ref FMOD_DSP.BUFFER_ARRAY inbufferarray, ref FMOD_DSP.BUFFER_ARRAY outbufferarray, bool inputsidle, FMOD_DSP.PROCESS_OPERATION op)
		{
			var length;

		    if (op == .PROCESS_QUERY)
		    {
		        FMOD.SPEAKERMODE outmode;
		        int32 outchannels;

#define STEREO
#if STEREO // For stereo output
		        {
		            outmode = .STEREO;
		            outchannels = 2;
		        }
#else // For 5.1 output
		        {
		            outmode = ._5POINT1;
		            outchannels = 6;
		        }
#endif

	            outbufferarray.SpeakerMode = outmode;
	            outbufferarray.BufferNumChannels[0] = outchannels;

		        if (inputsidle)
		            return .ERR_DSP_DONTPROCESS;

		        return .OK;
		    }

		    // Do processing here
		    float* inbuffer   = (float*)inbufferarray.Buffers[0];
		    float* outbuffer  = (float*)outbufferarray.Buffers[0];
		    int32 inchannels  = inbufferarray.BufferNumChannels[0];
		    int32 outchannels = outbufferarray.BufferNumChannels[0];

		    while(length-- > 0)
		    {
		        // MAIN DSP LOOP...
		    }

		    return .OK;
		}

		public void reset()
		{
		    m_current_lowpass_time_const  = m_target_lowpass_time_const;
		    m_current_highpass_time_const = m_target_highpass_time_const;
		    m_ramp_samples_left           = 0;

		    Internal.MemSet(m_previous_lp1_out, 0, m_max_channels * sizeof(float));
		    Internal.MemSet(m_previous_lp2_out, 0, m_max_channels * sizeof(float));
		    Internal.MemSet(m_previous_hp_out,  0, m_max_channels * sizeof(float));
		}

		public void setMaxDistance(float distance)
		{
		    m_max_distance = distance;
		    updateTimeConstants();
		}

		public void setBandpassFrequency(float frequency)
		{
		    m_bandpass_frequency = frequency;
		    updateTimeConstants();
		}

		public void setDistance(float distance)
		{
		    m_distance = distance;
		    updateTimeConstants();
		}

		private void updateTimeConstants()
		{
		    const float PI         = 3.14159265358979323846f;
		    const float MIN_CUTOFF = 10.0f;
		    const float MAX_CUTOFF = 22000.0f;

		    float dist_factor = m_distance >= m_max_distance ? 1.0f : m_distance / m_max_distance;
		    float lp_cutoff = m_bandpass_frequency + (1.0f - dist_factor) * (1.0f - dist_factor) * (MAX_CUTOFF - m_bandpass_frequency);
		    float hp_cutoff = MIN_CUTOFF + dist_factor * dist_factor * (m_bandpass_frequency - MIN_CUTOFF);

		    float dt = 1.0f / m_sample_rate;
		    float threshold = m_sample_rate / PI;

		    if (lp_cutoff >= MAX_CUTOFF)
		    {
		        m_target_lowpass_time_const = 1.0f;
		    }
		    else if (lp_cutoff <= threshold)
		    {
		        float RC = 1.0f / (2.0f * PI * lp_cutoff);
		        m_target_lowpass_time_const = dt / (RC + dt);
		    }
		    else
		    {
		        m_target_lowpass_time_const = 0.666666667f + (lp_cutoff - threshold) / (3.0f * (MAX_CUTOFF - threshold));
		    }

		    if (hp_cutoff >= MAX_CUTOFF)
		    {
		        m_target_highpass_time_const = 0.0f;
		    }
		    else if (hp_cutoff <= threshold)
		    {
		        float RC = 1.0f / (2.0f * PI * hp_cutoff);
		        m_target_highpass_time_const = RC / (RC + dt);
		    }
		    else
		    {
		        m_target_highpass_time_const = (MAX_CUTOFF - hp_cutoff) / (3.0f * (MAX_CUTOFF - threshold));
		    }

		    m_ramp_samples_left = 256;
		}
	}
}
