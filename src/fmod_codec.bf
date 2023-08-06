/* ======================================================================================== */
/* FMOD Core API - Codec development header file.                                           */
/* Copyright (c), Firelight Technologies Pty, Ltd. 2004-2023.                               */
/*                                                                                          */
/* Use this header if you are wanting to develop your own file format plugin to use with    */
/* FMOD's codec system.  With this header you can make your own fileformat plugin that FMOD */
/* can register and use.  See the documentation and examples on how to make a working       */
/* plugin.                                                                                  */
/*                                                                                          */
/* For more detail visit:                                                                   */
/* https://fmod.com/docs/2.02/api/core-api.html                                             */
/* ======================================================================================== */
namespace Beef_FMOD;

using System;

public struct FMOD_CODEC
{
	/*
	    Codec constants
	*/
	public const uint32 PLUGIN_VERSION = 1;

	public enum SEEK_METHOD : int32
	{
		SET     = 0,
		CURRENT = 1,
		END     = 2
	}

	/*
	    Codec callbacks
	*/
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT OPEN_CALLBACK(STATE* codec_state, FMOD.MODE userMode, FMOD.CREATESOUNDEXINFO* userExInfo);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT CLOSE_CALLBACK(STATE* codec_state);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT READ_CALLBACK(STATE* codec_state, void* buffer, uint32 samples_in, out uint32 samples_out);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETLENGTH_CALLBACK(STATE* codec_state, out uint32 length, FMOD.TIMEUNIT lengthType);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SETPOSITION_CALLBACK(STATE* codec_state, int32 subSound, uint32 position, FMOD.TIMEUNIT postType);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETPOSITION_CALLBACK(STATE* codec_state, out uint32 position, FMOD.TIMEUNIT postType);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SOUNDCREATE_CALLBACK(STATE* codec_state, int32 subSound, void* sound);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT GETWAVEFORMAT_CALLBACK(STATE* codec_state, int32 index, out WAVEFORMAT waveFormat);

	/*
	    Codec functions
	*/
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT METADATA_FUNC(STATE* codec_state, FMOD.TAGTYPE tagType, char8* name, void* data, uint32 dataLen, FMOD.TAGDATATYPE dataType, int32 unique);
	[CallingConvention(.Stdcall)]
	public function void* ALLOC_FUNC(uint32 size, uint32 align, [MangleConst]char8* file, int32 line);
	[CallingConvention(.Stdcall)]
	public function void FREE_FUNC(void* ptr, [MangleConst]char8* file, int32 line);
	[CallingConvention(.Stdcall)]
	public function void LOG_FUNC(FMOD.DEBUG_FLAGS level, [MangleConst]char8* file, int32 line, [MangleConst]char8* func, [MangleConst]char8* string, ...);

	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT FILE_READ_FUNC(STATE* codec_state, void* buffer, uint32 sizeBytes, uint32* bytesRead);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT FILE_SEEK_FUNC(STATE* codec_state, uint32 pos, SEEK_METHOD method);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT FILE_TELL_FUNC(STATE* codec_state, uint32* pos);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT FILE_SIZE_FUNC(STATE* codec_state, uint32* size);

	/*
	    Codec structures
	*/
	[CRepr]
	public struct DESCRIPTION
	{
	    public uint32                 ApiVersion;
	    public char8*                 Name;
	    public uint32                 Version;
	    public int32                  DefaultAsStream;
	    public FMOD.TIMEUNIT          TimeUnits;
	    public OPEN_CALLBACK          Open;
	    public CLOSE_CALLBACK         Close;
	    public READ_CALLBACK          Read;
	    public GETLENGTH_CALLBACK     GetLength;
	    public SETPOSITION_CALLBACK   SetPosition;
	    public GETPOSITION_CALLBACK   GetPosition;
	    public SOUNDCREATE_CALLBACK   SoundCreate;
	    public GETWAVEFORMAT_CALLBACK GetWaveFormat;
	}
	
	[CRepr]
	public struct WAVEFORMAT
	{
	    public char8*            Name;
	    public FMOD.SOUND_FORMAT Format;
	    public int32             Channels;
	    public int32             Frequency;
	    public uint32            LengthBytes;
	    public uint32            LengthPCM;
	    public uint32            PCMBlockSize;
	    public int32             LoopStart;
	    public int32             LoopEnd;
	    public FMOD.MODE         Mode;
	    public FMOD.CHANNELMASK  ChannelMask;
	    public FMOD.CHANNELORDER ChannelOrder;
	    public float             PeakVolume;
	}
	
	[CRepr]
	public struct STATE_FUNCTIONS
	{
	    public METADATA_FUNC  Metadata;
	    public ALLOC_FUNC     Alloc;
	    public FREE_FUNC      Free;
	    public LOG_FUNC       Log;
	    public FILE_READ_FUNC Read;
	    public FILE_SEEK_FUNC Seek;
	    public FILE_TELL_FUNC Tell;
	    public FILE_SIZE_FUNC Size;
	}
	
	[CRepr]
	public struct STATE
	{
	    public void*            PluginData;
	    public WAVEFORMAT*      WaveFormat;
	    public STATE_FUNCTIONS* Functions;
	    public int32            NumSubSounds;
	}
}