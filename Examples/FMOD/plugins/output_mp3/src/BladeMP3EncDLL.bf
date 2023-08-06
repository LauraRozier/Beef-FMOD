/*
* Blade Type of DLL Interface for Lame encoder
*
* Copyright (c) 1999-2002 A.L. Faber
* Based on bladedll.h version 1.0 written by Jukka Poikolainen
*
* This library is free software; you can redistribute it and/or
* modify it under the terms of the GNU Library General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Library General Public License for more details.
*
* You should have received a copy of the GNU Library General Public
* License along with this library; if not, write to the
* Free Software Foundation, Inc., 59 Temple Place - Suite 330,
* Boston, MA  02111-1307, USA.
*/
namespace output_mp3;

using Beef_FMOD;
using System;

struct BE
{
	/* encoding formats */
	public const uint32 CONFIG_MP3  = 0;
	public const uint32 CONFIG_LAME = 256;

	/* type definitions */
	public typealias STREAM  = void*;
	/* error codes */
	public enum ERR : uint64
	{
		SUCCESSFUL                = 0x00000000,
		INVALID_FORMAT            = 0x00000001,
		INVALID_FORMAT_PARAMETERS = 0x00000002,
		NO_MORE_HANDLES           = 0x00000003,
		INVALID_HANDLE            = 0x00000004,
		BUFFER_TOO_SMALL          = 0x00000005
	}

	public const uint8 MPEG1 = 1;
	public const uint8 MPEG2 = 0;

	/* other constants */
	public const uint8 MAX_HOMEPAGE = 128;

	/* format specific variables */
	public enum MP3_MODE
	{
		STEREO      = 0,
		JSTEREO     = 1,
		DUALCHANNEL = 2,
		MONO        = 3
	}

	public const uint8 CURRENT_STRUCT_VERSION = 1;
	public const uint16 CURRENT_STRUCT_SIZE   = sizeof(CONFIG); // Is currently ?? bytes

    public const char8* TEXT_BEINITSTREAM            = "beInitStream\0";
    public const char8* TEXT_BEENCODECHUNK           = "beEncodeChunk\0";
    public const char8* TEXT_BEENCODECHUNKFLOATS16NI = "beEncodeChunkFloatS16NI\0";
    public const char8* TEXT_BEDEINITSTREAM          = "beDeinitStream\0";
    public const char8* TEXT_BECLOSESTREAM           = "beCloseStream\0";
    public const char8* TEXT_BEVERSION               = "beVersion\0";
    public const char8* TEXT_BEWRITEVBRHEADER        = "beWriteVBRHeader\0";
    public const char8* TEXT_BEFLUSHNOGAP            = "beFlushNoGap\0";
    public const char8* TEXT_BEWRITEINFOTAG          = "beWriteInfoTag\0";

	public enum VBRMETHOD : int32
	{
		NONE    = -1,
		DEFAULT =  0,
		OLD     =  1,
		NEW     =  2,
		MTRH    =  3,
		ABR     =  4
	}

	public enum LAME_QUALITY_PRESET : int64
	{
		NOPRESET         = -1,

		// QUALITY PRESETS
		NORMAL_QUALITY   = 0,
		LOW_QUALITY      = 1,
		HIGH_QUALITY     = 2,
		VOICE_QUALITY    = 3,
		R3MIX            = 4,
		VERYHIGH_QUALITY = 5,
		STANDARD         = 6,
		FAST_STANDARD    = 7,
		EXTREME          = 8,
		FAST_EXTREME     = 9,
		INSANE           = 10,
		ABR              = 11,
		CBR              = 12,
		MEDIUM           = 13,
		FAST_MEDIUM      = 14,

		// NEW PRESET VALUES
		PHONE  = 1000,
		SW     = 2000,
		AM     = 3000,
		FM     = 4000,
		VOICE  = 5000,
		RADIO  = 6000,
		TAPE   = 7000,
		HIFI   = 8000,
		CD     = 9000,
		STUDIO = 10000
	}

	[CRepr, Packed(1)]
	public struct CONFIG
	{
		public uint64 dwConfig; // BE_CONFIG_XXXXX Currently only BE_CONFIG_MP3 is supported
		public FormatUnion format;

		[CRepr, Union, Packed(1)]
		public struct FormatUnion
		{
			public Mp3Type  mp3;
			public LHV1Type LHV1;
			public AacType  aac;

			[CRepr, Packed(1)]
			public struct Mp3Type
			{
				public uint64 dwSampleRate; // 48000, 44100 and 32000 allowed
				public uint8  byMode;       // BE_MP3_MODE_STEREO, BE_MP3_MODE_DUALCHANNEL, BE_MP3_MODE_MONO
				public uint16 wBitrate;     // 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256 and 320 allowed
				public bool   bPrivate;
				public bool   bCRC;
				public bool   bCopyright;
				public bool   bOriginal;
			} // BE_CONFIG_MP3

			[CRepr, Packed(1)]
			public struct LHV1Type
			{
				// STRUCTURE INFORMATION
				public uint64    dwStructVersion;
				public uint64    dwStructSize;

				// BASIC ENCODER SETTINGS
				public uint64    dwSampleRate;    // SAMPLERATE OF INPUT FILE
				public uint64    dwReSampleRate;  // DOWNSAMPLERATE, 0=ENCODER DECIDES
				public int64     nMode;           // BE_MP3_MODE_STEREO, BE_MP3_MODE_DUALCHANNEL, BE_MP3_MODE_MONO
				public uint64    dwBitrate;       // CBR bitrate, VBR min bitrate
				public uint64    dwMaxBitrate;    // CBR ignored, VBR Max bitrate
				public int64     nPreset;         // Quality preset, use one of the settings of the LAME_QUALITY_PRESET enum
				public uint64    dwMpegVersion;   // FUTURE USE, MPEG-1 OR MPEG-2
				public uint64    dwPsyModel;      // FUTURE USE, SET TO 0
				public uint64    dwEmphasis;      // FUTURE USE, SET TO 0

				// BIT STREAM SETTINGS
				public bool      bPrivate;        // Set Private Bit (TRUE/FALSE)
				public bool      bCRC;            // Insert CRC (TRUE/FALSE)
				public bool      bCopyright;      // Set Copyright Bit (TRUE/FALSE)
				public bool      bOriginal;       // Set Original Bit (TRUE/FALSE)

				// VBR STUFF
				public bool      bWriteVBRHeader; // WRITE XING VBR HEADER (TRUE/FALSE)
				public bool      bEnableVBR;      // USE VBR ENCODING (TRUE/FALSE)
				public int32     nVBRQuality;     // VBR QUALITY 0..9
				public uint64    dwVbrAbr_bps;    // Use ABR in stead of nVBRQuality
				public VBRMETHOD nVbrMethod;
				public bool      bNoRes;          // Disable Bit reservoir (TRUE/FALSE)

				// MISC SETTINGS
				public bool      bStrictIso;      // Use strict ISO encoding rules (TRUE/FALSE)
				public uint16    nQuality;        // Quality Setting, HIGH BYTE should be NOT LOW byte, otherwise quality=5

				// FUTURE USE, SET TO 0, align strucutre to 331 bytes
				public uint8[255 - 4 * sizeof(uint64) - sizeof(uint16)] btReserved;
			} // LAME header version 1

			[CRepr, Packed(1)]
			public struct AacType
			{
				public uint64 dwSampleRate;
				public uint8  byMode;
				public uint16 wBitrate;
				public uint8  byEncodingMethod;
			} // AAC codec
		}
	}

	[CRepr, Packed(1)]
	public struct VERSION
	{
		// BladeEnc DLL Version number
		public uint8 byDLLMajorVersion;
		public uint8 byDLLMinorVersion;
	
		// BladeEnc Engine Version Number
		public uint8 byMajorVersion;
		public uint8 byMinorVersion;
	
		// DLL Release date
		public uint8  byDay;
		public uint8  byMonth;
		public uint16 wYear;
	
		// BladeEnc	Homepage URL
		public char8[MAX_HOMEPAGE + 1] zHomepage;	
	
		public uint8 byAlphaLevel;
		public uint8 byBetaLevel;
		public uint8 byMMXEnabled;
	
		public uint8[125] btReserved;
	}

	public function ERR BEINITSTREAM(CONFIG* pbeConfig, uint64* dwSamples, uint64* dwBufferSize, STREAM* phbeStream);
	public function ERR BEENCODECHUNK(STREAM hbeStream, uint64 nSamples, int16* pSamples, uint8* pOutput, uint64* pdwOutput);

	// added for floating point audio  -- DSPguru, jd
	public function ERR BEENCODECHUNKFLOATS16NI(STREAM hbeStream, uint64 nSamples, float* buffer_l, float* buffer_r, uint8* pOutput, uint64* pdwOutput);
	public function ERR BEDEINITSTREAM(STREAM hbeStream, uint8* pOutput, uint64* pdwOutput);
	public function ERR BECLOSESTREAM(STREAM hbeStream);
	public function void BEVERSION(out VERSION pbeVersion);
	public function ERR BEWRITEVBRHEADER([MangleConst]char8* lpszFileName);
	public function ERR BEWRITEINFOTAG(STREAM hbeStream, [MangleConst]char8* lpszFileName);
}