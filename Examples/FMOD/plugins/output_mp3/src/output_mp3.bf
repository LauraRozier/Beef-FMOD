namespace output_mp3;

using Beef_FMOD;
using System;

public struct outputmp3_state
{
    public Platform.BfpFile*   mFP;
    public void*               mDLL;
    public BE.STREAM           hbeStream;
    public uint8*              pMP3Buffer;
    public int16*              pWAVBuffer;
    public BE.VERSION          Version;
    public uint64              dwMP3Buffer;
    public uint64              dwSamples;

    public BE.BEINITSTREAM     beInitStream;
    public BE.BEENCODECHUNK    beEncodeChunk;
    public BE.BEDEINITSTREAM   beDeinitStream;
    public BE.BECLOSESTREAM    beCloseStream;
    public BE.BEVERSION        beVersion;
    public BE.BEWRITEVBRHEADER beWriteVBRHeader;

    public int32               dspbufferlength;
}

public static
{
	private static FMOD_OUTPUT.DESCRIPTION mp3output = .();
	/*
	    FMODGetOutputDescription is mandantory for every fmod plugin.  This is the symbol the registerplugin function searches for.
	    Must be declared with F_CALL to make it export as stdcall.
	*/
	[Export, CLink, CallingConvention(.Stdcall)]
	public static FMOD_OUTPUT.DESCRIPTION* FMODGetOutputDescription()
	{
	    mp3output.ApiVersion    = FMOD_OUTPUT.PLUGIN_VERSION;
	    mp3output.Name          = "FMOD MP3 Output";
	    mp3output.Version       = 0x00010000;
	    mp3output.Method        = .MIX_DIRECT;
	    mp3output.GetNumDrivers = => OutputMP3.GetNumDriversCallback;
	    mp3output.GetDriverInfo = => OutputMP3.GetDriverInfoCallback;
	    mp3output.Init          = => OutputMP3.InitCallback;
	    mp3output.Close         = => OutputMP3.CloseCallback;
	    mp3output.Update        = => OutputMP3.UpdateCallback;
	    mp3output.GetHandle     = => OutputMP3.GetHandleCallback;

	    return &mp3output;
	}
}

static class OutputMP3
{
	static String ownPath = new .() ~ delete _;
	static String ownDir = new .() ~ delete _;
	static String outputFile = new .() ~ delete _;

	static this()
	{
		Environment.GetModuleFilePath(ownPath);
		System.IO.Path.GetDirectoryPath(ownPath, ownDir);
		outputFile.AppendF("{0}/fmodoutput.mp3", ownDir);
	}

	public static FMOD.RESULT GetNumDriversCallback(FMOD_OUTPUT.STATE* output, int32* numdrivers)
	{
	    *numdrivers = 1;
	    return .OK;
	}

	public static FMOD.RESULT GetDriverInfoCallback(FMOD_OUTPUT.STATE* output, int32 id, char8* name, int32 namelen, FMOD.GUID* guid, int32* systemrate, FMOD.SPEAKERMODE* speakermode, int32* speakermodechannels)
	{
		Internal.MemCpy(name, outputFile.CStr(), Math.Min(namelen, outputFile.Length));
	    *speakermode = .STEREO;
	    *speakermodechannels = 2;
	    return .OK;
	}

	public static FMOD.RESULT InitCallback(FMOD_OUTPUT.STATE* output_state, int32 selecteddriver, FMOD.INITFLAGS flags, int32* outputrate, FMOD.SPEAKERMODE* speakermode, int32* speakermodechannels, FMOD.SOUND_FORMAT* outputformat, int32 dspbufferlength, int32* dspnumbuffers, int32* dspnumadditionalbuffers, void* extradriverdata)
	{

	    outputmp3_state state = .();
	    BE.CONFIG beConfig = .();
	    BE.ERR err = .SUCCESSFUL;
	    String filename = scope .(256);

	    /*
	        Create a structure that we can attach to the plugin instance.
	    */
	    output_state.PluginData = &state;

	    *outputformat        = .PCM16;
	    *speakermode         = .STEREO;
	    *speakermodechannels = 2;

		String lameDll = scope .(ownDir);
#if BF_64_BIT
		lameDll.Append("/lame_enc64.dll");
#else
		lameDll.Append("/lame_enc.dll");
#endif
	    state.mDLL = Internal.LoadSharedLibrary(lameDll);

	    if (state.mDLL == null)
	        return .ERR_PLUGIN_RESOURCE;

	    state.dspbufferlength = dspbufferlength;

	    /*
	        Get Interface functions from the DLL
	    */
	    state.beInitStream     = (BE.BEINITSTREAM)     Internal.GetSharedProcAddress(state.mDLL, BE.TEXT_BEINITSTREAM);
	    state.beEncodeChunk    = (BE.BEENCODECHUNK)    Internal.GetSharedProcAddress(state.mDLL, BE.TEXT_BEENCODECHUNK);
	    state.beDeinitStream   = (BE.BEDEINITSTREAM)   Internal.GetSharedProcAddress(state.mDLL, BE.TEXT_BEDEINITSTREAM);
	    state.beCloseStream    = (BE.BECLOSESTREAM)    Internal.GetSharedProcAddress(state.mDLL, BE.TEXT_BECLOSESTREAM);
	    state.beVersion        = (BE.BEVERSION)        Internal.GetSharedProcAddress(state.mDLL, BE.TEXT_BEVERSION);
	    state.beWriteVBRHeader = (BE.BEWRITEVBRHEADER) Internal.GetSharedProcAddress(state.mDLL, BE.TEXT_BEWRITEVBRHEADER);

	    // Check if all interfaces are present
	    if (state.beInitStream == null || state.beEncodeChunk == null || state.beDeinitStream == null || state.beCloseStream == null || state.beVersion == null || state.beWriteVBRHeader == null)
	        return .ERR_PLUGIN;

	    // Get the version number
	    state.beVersion(out state.Version);

		beConfig = .(); // clear all fields

	    // use the LAME config structure
	    beConfig.dwConfig = BE.CONFIG_LAME;

	    // this are the default settings for testcase.wav

	    // FMOD NOTE : The 'extradriverdata' param could be used to pass in info about the bitrate and encoding settings.

	    beConfig.format.LHV1.dwStructVersion    = 1;
	    beConfig.format.LHV1.dwStructSize       = sizeof(BE.CONFIG);
	    beConfig.format.LHV1.dwSampleRate       = (uint64)*outputrate;                     // INPUT FREQUENCY
	    beConfig.format.LHV1.dwReSampleRate     = 0;                                       // DON'T RESAMPLE
	    beConfig.format.LHV1.nMode              = BE.MP3_MODE.JSTEREO.Underlying;          // OUTPUT IN STREO
	    beConfig.format.LHV1.dwBitrate          = 128;                                     // MINIMUM BIT RATE
	    beConfig.format.LHV1.nPreset            = BE.LAME_QUALITY_PRESET.R3MIX.Underlying; // QUALITY PRESET SETTING
	    beConfig.format.LHV1.dwMpegVersion      = BE.MPEG1;                                // MPEG VERSION (I or II)
	    beConfig.format.LHV1.dwPsyModel         = 0;                                       // USE DEFAULT PSYCHOACOUSTIC MODEL
	    beConfig.format.LHV1.dwEmphasis         = 0;                                       // NO EMPHASIS TURNED ON
	    beConfig.format.LHV1.bOriginal          = true;                                    // SET ORIGINAL FLAG
	    beConfig.format.LHV1.bWriteVBRHeader    = true;                                    // Write INFO tag

		// beConfig.format.LHV1.dwMaxBitrate     = 320;                                       // MAXIMUM BIT RATE
		// beConfig.format.LHV1.bCRC             = true;                                      // INSERT CRC
		// beConfig.format.LHV1.bCopyright       = true;                                      // SET COPYRIGHT FLAG
		// beConfig.format.LHV1.bPrivate         = true;                                      // SET PRIVATE FLAG
		// beConfig.format.LHV1.bWriteVBRHeader  = true;                                      // YES, WRITE THE XING VBR HEADER
		// beConfig.format.LHV1.bEnableVBR       = true;                                      // USE VBR
		// beConfig.format.LHV1.nVBRQuality      = 5;                                         // SET VBR QUALITY
	    beConfig.format.LHV1.bNoRes             = true;                                    // No Bit reservoir

		// Preset Test
		// beConfig.format.LHV1.nPreset          = BE.LAME_QUALITY_PRESET.PHONE.Underlying;

	    // Init the MP3 Stream
	    err = state.beInitStream(&beConfig, &state.dwSamples, &state.dwMP3Buffer, &state.hbeStream);

	    // Check result
	    if(err != .SUCCESSFUL)
	        return .ERR_PLUGIN;

	    // Allocate MP3 buffer
	    state.pMP3Buffer = (uint8*)Internal.Malloc((int)state.dwMP3Buffer);

	    if (state.pMP3Buffer == null)
	        return .ERR_MEMORY;

	    // Allocate WAV buffer
	    state.pWAVBuffer = (int16*)Internal.Malloc((int)(state.dwSamples * sizeof(int16)));

	    if (state.pWAVBuffer == null)
	        return .ERR_MEMORY;

	    if (extradriverdata == null)
			filename.Set(outputFile);
	    else
			filename.Append((char8*)extradriverdata);

		Platform.BfpFileResult fileResult = .Ok;
		state.mFP = Platform.BfpFile_Create(filename.CStr(), .CreateAlways, .Read | .Write | .Truncate, .Normal, &fileResult);

	    if (fileResult != .Ok || state.mFP == null)
	        return .ERR_FILE_NOTFOUND;

	    return .OK;
	}

	public static FMOD.RESULT CloseCallback(FMOD_OUTPUT.STATE* output_state)
	{
	    if (output_state == null || output_state.PluginData == null)
	        return .OK;

	    outputmp3_state state = *(outputmp3_state*)output_state.PluginData;
	    uint64 dwWrite = 0;
	    BE.ERR err;

		if (state.hbeStream != null)
		{
			// Deinit the stream
			err = state.beDeinitStream(state.hbeStream, state.pMP3Buffer, &dwWrite);

			// Check result
			if (err != .SUCCESSFUL)
			{
			    state.beCloseStream(state.hbeStream);
			    return .ERR_PLUGIN;
			}

			// Are there any bytes returned from the DeInit call?
			// If so, write them to disk
			if (dwWrite > 0)
			{
				Platform.BfpFileResult fileResult = .Ok;
				int resultLen = Platform.BfpFile_Write(state.mFP, state.pMP3Buffer, (int)dwWrite, -1, &fileResult);

				if (fileResult != .Ok || resultLen != (int)dwWrite)
			        return .ERR_FILE_BAD;
			}

			// close the MP3 Stream
			state.beCloseStream(state.hbeStream);
		}
	
	    if (state.pWAVBuffer != null)
	    {
	        Internal.Free(state.pWAVBuffer);
	        state.pWAVBuffer = null;
	    }
	
	    if (state.pMP3Buffer != null)
	    {
	        Internal.Free(state.pMP3Buffer);
	        state.pMP3Buffer = null;
	    }
	
	    if (state.mFP != null)
	    {
	        Platform.BfpFile_Release(state.mFP);
	        state.mFP = null;
	    }
	
	    return .OK;
	}

	public static FMOD.RESULT UpdateCallback(FMOD_OUTPUT.STATE* output_state)
	{
	    FMOD.RESULT result;
	    outputmp3_state state = *(outputmp3_state *)output_state.PluginData;
	    uint64 dwRead  = 0, dwWrite = 0;
	    BE.ERR err;
	
	    /*
	        Update the mixer to the interleaved buffer.
	    */
	    int16* destptr = state.pWAVBuffer;
	    uint32 len = (uint32)state.dwSamples / 2; /* /2 = stereo */
	
	    while (len > 0)
	    {
	        uint32 l = len; // > state.dspbufferlength ? state.dspbufferlength : len;
	        result = output_state.ReadFromMixer(output_state, destptr, l);

	        if (result != .OK)
	            return .OK;
	
	        len -= l;
	        destptr += (l * 2); /* *2 = stereo. */
	    }
	
	    dwRead = state.dwSamples * sizeof(int16);
	
	    // Encode samples
	    err = state.beEncodeChunk(state.hbeStream, dwRead / sizeof(int16), state.pWAVBuffer, state.pMP3Buffer, &dwWrite);
	
	    // Check result
	    if (err != .SUCCESSFUL)
	    {
	        state.beCloseStream(state.hbeStream);
	        return .ERR_PLUGIN;
	    }
	
	    // write dwWrite bytes that are returned in the pMP3Buffer to disk
		Platform.BfpFileResult fileResult = .Ok;
		int resultLen = Platform.BfpFile_Write(state.mFP, state.pMP3Buffer, (int)dwWrite, -1, &fileResult);

	    if (fileResult != .Ok || resultLen != (int)dwWrite)
	        return .ERR_FILE_BAD;
	
	    return .OK;
	}

	public static FMOD.RESULT GetHandleCallback(FMOD_OUTPUT.STATE* output_state, void** handle)
	{
	    outputmp3_state* state = (outputmp3_state*)output_state.PluginData;
	    *handle = state.mFP;
	    return .OK;
	}
}