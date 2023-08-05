/* ======================================================================================== */
/* FMOD Core API - output development header file.                                          */
/* Copyright (c), Firelight Technologies Pty, Ltd. 2004-2023.                               */
/*                                                                                          */
/* Use this header if you are wanting to develop your own output plugin to use with         */
/* FMOD's output system.  With this header you can make your own output plugin that FMOD    */
/* can register and use.  See the documentation and examples on how to make a working       */
/* plugin.                                                                                  */
/*                                                                                          */
/* For more detail visit:                                                                   */
/* https://fmod.com/docs/2.02/api/plugin-api-output.html                                    */
/* ======================================================================================== */
namespace Beef_FMOD;

using System;

public struct FMOD_OUTPUT
{
	/*
	    Output constants
	*/
	public const uint32 PLUGIN_VERSION = 5;

	public enum METHOD : uint32
	{
		MIX_DIRECT   = 0,
		MIX_BUFFERED = 1
	}

	/*
	    Output callbacks
	*/
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETNUMDRIVERS_CALLBACK(STATE* output_state, int32* numDrivers);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETDRIVERINFO_CALLBACK(STATE* output_state, int32 id, char8* name, int32 nameLen, FMOD.GUID* guid, int32* systemRate, FMOD.SPEAKERMODE* speakerMode, int32* speakerModeChannels);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT INIT_CALLBACK(STATE* output_state, int32 selectedDriver, FMOD.INITFLAGS flgs, int32* outputRate, FMOD.SPEAKERMODE* speakerMode, int32* speakerModeChannels, FMOD.SOUND_FORMAT* outputFormat, int32 dspBufferLength, int32* dspNumBuffers, int32* dspNumAdditionalBuffers, void* extraDriverData);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT START_CALLBACK(STATE* output_state);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT STOP_CALLBACK(STATE* output_state);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT CLOSE_CALLBACK(STATE* output_state);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT UPDATE_CALLBACK(STATE* output_state);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETHANDLE_CALLBACK(STATE* output_state, void** handle);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT MIXER_CALLBACK(STATE* output_state);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT OBJECT3DGETINFO_CALLBACK(STATE* output_state, int32* maxHardwareObjects);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT OBJECT3DALLOC_CALLBACK(STATE* output_state, void** object3D);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT OBJECT3DFREE_CALLBACK(STATE* output_state, void* object3D);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT OBJECT3DUPDATE_CALLBACK(STATE* output_state, void* object3D, [MangleConst]OBJECT3DINFO* info);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT OPENPORT_CALLBACK(STATE* output_state, FMOD.PORT_TYPE portType, FMOD.PORT_INDEX portIndex, int32* portId, int32* portChannels, FMOD.SOUND_FORMAT* portFormat);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT CLOSEPORT_CALLBACK(STATE* output_state, int32 portId);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT DEVICELISTCHANGED_CALLBACK(STATE* output_state);

	/*
	    Output functions
	*/
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT READFROMMIXER_FUNC(STATE* output_state, void* buffer, uint32 length);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT COPYPORT_FUNC(STATE* output_state, int32 portId, void* buffer, uint32 length);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT REQUESTRESET_FUNC(STATE* output_state);
	[CallingConvention(.Stdcall)]
	public function void* ALLOC_FUNC(uint32 size, uint32 align, [MangleConst]char8* file, int32 line);
	[CallingConvention(.Stdcall)]
	public function void FREE_FUNC(void* ptr, [MangleConst]char8* file, int32 line);
	[CallingConvention(.Stdcall)]
	public function void LOG_FUNC(FMOD.DEBUG_FLAGS level, [MangleConst]char8* file, int32 line, [MangleConst]char8* func, [MangleConst]char8* string, ...);

	/*
	    Output structures
	*/
	[CRepr]
	public struct DESCRIPTION
	{
		public uint32                     ApiVersion;
		public readonly char8*            Name;
		public uint32                     Version;
		public METHOD                     Method;
		public GETNUMDRIVERS_CALLBACK     GetNumDrivers;
		public GETDRIVERINFO_CALLBACK     GetDriverInfo;
		public INIT_CALLBACK              Init;
		public START_CALLBACK             Start;
		public STOP_CALLBACK              Stop;
		public CLOSE_CALLBACK             Close;
		public UPDATE_CALLBACK            Update;
		public GETHANDLE_CALLBACK         GetHandle;
		public MIXER_CALLBACK             Mixer;
		public OBJECT3DGETINFO_CALLBACK   Object3DGetInfo;
		public OBJECT3DALLOC_CALLBACK     Object3DAlloc;
		public OBJECT3DFREE_CALLBACK      Object3DFree;
		public OBJECT3DUPDATE_CALLBACK    Object3DUpdate;
		public OPENPORT_CALLBACK          OpenPort;
		public CLOSEPORT_CALLBACK         ClosePort;
		public DEVICELISTCHANGED_CALLBACK DeviceListChanged;
	}

	[CRepr]
	public struct STATE
	{
		public void*              PluginData;
		public READFROMMIXER_FUNC ReadFromMixer;
		public ALLOC_FUNC         Alloc;
		public FREE_FUNC          Free;
		public LOG_FUNC           Log;
		public COPYPORT_FUNC      CopyPort;
		public REQUESTRESET_FUNC  RequestReset;
	}

	[CRepr]
	public struct OBJECT3DINFO
	{
		public float*      Buffer;
		public uint32      BufferLength;
		public FMOD.VECTOR Position;
		public float       Gain;
		public float       Spread;
		public float       Priority;
	}
}