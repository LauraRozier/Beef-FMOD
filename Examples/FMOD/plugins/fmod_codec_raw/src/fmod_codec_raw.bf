/*===============================================================================================
Raw Codec Plugin Example
Copyright (c), Firelight Technologies Pty, Ltd 2004-2023.

This example shows how to create a codec that reads raw PCM data.

1. The codec can be compiled as a DLL, using the reserved function name 'FMODGetCodecDescription' 
   as the only export symbol, and at runtime, the dll can be loaded in with System::loadPlugin.

2. Alternatively a codec of this type can be compiled directly into the program that uses it, and 
   you just register the codec into FMOD with System::registerCodec.   This puts the codec into 
   the FMOD system, just the same way System::loadPlugin would if it was an external file.

3. The 'open' callback is the first thing called, and FMOD already has a file handle open for it.
   In the open callback you can use FMOD_CODEC_STATE::fileread / FMOD_CODEC_STATE::fileseek to parse 
   your own file format, and return FMOD_ERR_FORMAT if it is not the format you support.  Return 
   FMOD_OK if it succeeds your format test.

4. When an FMOD user calls System::createSound or System::createStream, the 'open' callback is called
   once after FMOD tries to open it as many other types of file.   If you want to override FMOD's 
   internal codecs then use the 'priority' parameter of System::loadPlugin or System::registerCodec.

5. In the open callback, tell FMOD what sort of PCM format the sound will produce with the 
   FMOD_CODEC_STATE::waveformat member.

6. The 'close' callback is called when Sound::release is called by the FMOD user.

7. The 'read' callback is called when System::createSound or System::createStream wants to receive 
   PCM data, in the format that you specified with FMOD_CODEC_STATE::waveformat.  Data is 
   interleaved as decribed in the terminology section of the FMOD API documentation.
   When a stream is being used, the read callback will be called repeatedly, using a size value 
   determined by the decode buffer size of the stream.  See FMOD_CREATESOUNDEXINFO or 
   FMOD_ADVANCEDSETTINGS.

8. The 'seek' callback is called when Channel::setPosition is called, or when looping a sound 
   when it is a stream.

===============================================================================================*/
namespace fmod_codec_raw;

using Beef_FMOD;
using System;

public static
{
	static FMOD_CODEC.DESCRIPTION rawcodec = .{
	    ApiVersion      = FMOD_CODEC.PLUGIN_VERSION,          // Plugin version.
	    Name            = "FMOD Raw player plugin example\0", // Name.
	    Version         = 0x00010000,                         // Version 0xAAAABBBB   A = major, B = minor.
	    DefaultAsStream = 0,                                  // Don't force everything using this codec to be a stream
	    TimeUnits       = .PCMBYTES,                          // The time format we would like to accept into setposition/getposition.
	    Open            = => fmod_codec_raw.rawopen,          // Open callback.
	    Close           = => fmod_codec_raw.rawclose,         // Close callback.
	    Read            = => fmod_codec_raw.rawread,          // Read callback.
	    GetLength       = null,                               // Getlength callback.  (If not specified FMOD return the length in .PCM, .MS or .PCMBYTES units based on the lengthpcm member of the FMOD_CODEC structure).
	    SetPosition     = => fmod_codec_raw.rawsetposition,   // Setposition callback.
	    GetPosition     = null,                               // Getposition callback. (only used for timeunit types that are not .PCM, .MS and .PCMBYTES).
	    SoundCreate     = null,                               // Sound create callback (don't need it)
		GetWaveFormat   = null
	};

	/*
	    FMODGetCodecDescription is mandatory for every fmod plugin.  This is the symbol the registerplugin function searches for.
	    Must be declared with F_CALL to make it export as stdcall.
	    MUST BE EXTERN'ED AS C!  C++ functions will be mangled incorrectly and not load in fmod.
	*/
	[Export, CLink, CallingConvention(.Stdcall)]
	public static FMOD_CODEC.DESCRIPTION* FMODGetCodecDescription()
	{
	    return &rawcodec;
	}
}

static class fmod_codec_raw
{
	
	static FMOD_CODEC.WAVEFORMAT rawWaveFormat;

	/*
	    The actual codec code.

	    Note that the callbacks uses FMOD's supplied file system callbacks.

	    This is important as even though you might want to open the file yourself, you would lose the following benefits.
	    1. Automatic support of memory files, CDDA based files, and HTTP/TCPIP based files.
	    2. "fileoffset" / "length" support when user calls System.createSound with FMOD.CREATESOUNDEXINFO structure.
	    3. Buffered file access.

	    FMOD files are high level abstracts that support all sorts of 'file', they are not just disk file handles.
	    If you want FMOD to use your own filesystem (and potentially lose the above benefits) use System.setFileSystem.
	*/

	public static FMOD.RESULT rawopen(FMOD_CODEC.STATE* codec, FMOD.MODE usermode, FMOD.CREATESOUNDEXINFO* userexinfo)
	{
	    rawWaveFormat.Channels     = 2;
	    rawWaveFormat.Format       = .PCM16;
	    rawWaveFormat.Frequency    = 44100;
	    rawWaveFormat.PCMBlockSize = 0;
	    uint32 size = ?;
	    codec.Functions.Size(codec, &size);
	    rawWaveFormat.LengthPCM    = size / (uint32)(rawWaveFormat.Channels * sizeof(int16)); /* bytes converted to PCM samples */

	    codec.NumSubSounds         = 0;              /* number of 'subsounds' in this sound.  For most codecs this is 0, only multi sound codecs such as FSB or CDDA have subsounds. */
	    codec.WaveFormat           = &rawWaveFormat;
	    codec.PluginData           = null;           /* user data value */

	    /*
		  If your file format needs to read data to determine the format and load metadata, do so here with codec.fileread/fileseek function pointers.
		  This will handle reading from disk/memory or internet.
		*/
	    return .OK;
	}

	public static FMOD.RESULT rawclose(FMOD_CODEC.STATE* codec) =>
		.OK;

	public static FMOD.RESULT rawread(FMOD_CODEC.STATE* codec, void* buffer, uint32 size, out uint32 read)
	{
		read = 0;
		return codec.Functions.Read(codec, buffer, size, &read);
	}

	public static FMOD.RESULT rawsetposition(FMOD_CODEC.STATE* codec, int32 subsound, uint32 position, FMOD.TIMEUNIT postype) =>
	    codec.Functions.Seek(codec, position, .SET);
}
