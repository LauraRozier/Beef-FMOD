/* ==============================================================================================  */
/* FMOD Core / Studio API - Error string header file.                                              */
/* Copyright (c), Firelight Technologies Pty, Ltd. 2004-2023.                                      */
/*                                                                                                 */
/* Use this header if you want to store or display a string version / english explanation          */
/* of the FMOD error codes.                                                                        */
/*                                                                                                 */
/* For more detail visit:                                                                          */
/* https://fmod.com/docs/2.02/api/core-api-common.html#fmod_result                                 */
/* =============================================================================================== */
namespace Beef_FMOD;

using System;

public static
{
	public static void FMOD_ErrorString(FMOD.RESULT errcode, String outStr)
	{
		switch (errcode)
		{
		case .OK:                            outStr.Set("No errors.");
		case .ERR_BADCOMMAND:                outStr.Set("Tried to call a function on a data type that does not allow this type of functionality (ie calling Sound::lock on a streaming sound).");
		case .ERR_CHANNEL_ALLOC:             outStr.Set("Error trying to allocate a channel.");
		case .ERR_CHANNEL_STOLEN:            outStr.Set("The specified channel has been reused to play another sound.");
		case .ERR_DMA:                       outStr.Set("DMA Failure.  See debug output for more information.");
		case .ERR_DSP_CONNECTION:            outStr.Set("DSP connection error.  Connection possibly caused a cyclic dependency or connected dsps with incompatible buffer counts.");
		case .ERR_DSP_DONTPROCESS:           outStr.Set("DSP outStr.Set(code from a DSP process query callback.  Tells mixer not to call the process callback and therefore not consume CPU.  Use this to optimize the DSP graph.");
		case .ERR_DSP_FORMAT:                outStr.Set("DSP Format error.  A DSP unit may have attempted to connect to this network with the wrong format, or a matrix may have been set with the wrong size if the target unit has a specified channel map.");
		case .ERR_DSP_INUSE:                 outStr.Set("DSP is already in the mixer's DSP network. It must be removed before being reinserted or released.");
		case .ERR_DSP_NOTFOUND:              outStr.Set("DSP connection error.  Couldn't find the DSP unit specified.");
		case .ERR_DSP_RESERVED:              outStr.Set("DSP operation error.  Cannot perform operation on this DSP as it is reserved by the system.");
		case .ERR_DSP_SILENCE:               outStr.Set("DSP outStr.Set(code from a DSP process query callback.  Tells mixer silence would be produced from read, so go idle and not consume CPU.  Use this to optimize the DSP graph.");
		case .ERR_DSP_TYPE:                  outStr.Set("DSP operation cannot be performed on a DSP of this type.");
		case .ERR_FILE_BAD:                  outStr.Set("Error loading file.");
		case .ERR_FILE_COULDNOTSEEK:         outStr.Set("Couldn't perform seek operation.  This is a limitation of the medium (ie netstreams) or the file format.");
		case .ERR_FILE_DISKEJECTED:          outStr.Set("Media was ejected while reading.");
		case .ERR_FILE_EOF:                  outStr.Set("End of file unexpectedly reached while trying to read essential data (truncated?).");
		case .ERR_FILE_ENDOFDATA:            outStr.Set("End of current chunk reached while trying to read data.");
		case .ERR_FILE_NOTFOUND:             outStr.Set("File not found.");
		case .ERR_FORMAT:                    outStr.Set("Unsupported file or audio format.");
		case .ERR_HEADER_MISMATCH:           outStr.Set("There is a version mismatch between the FMOD header and either the FMOD Studio library or the FMOD Low Level library.");
		case .ERR_HTTP:                      outStr.Set("A HTTP error occurred. This is a catch-all for HTTP errors not listed elsewhere.");
		case .ERR_HTTP_ACCESS:               outStr.Set("The specified resource requires authentication or is forbidden.");
		case .ERR_HTTP_PROXY_AUTH:           outStr.Set("Proxy authentication is required to access the specified resource.");
		case .ERR_HTTP_SERVER_ERROR:         outStr.Set("A HTTP server error occurred.");
		case .ERR_HTTP_TIMEOUT:              outStr.Set("The HTTP request timed out.");
		case .ERR_INITIALIZATION:            outStr.Set("FMOD was not initialized correctly to support this function.");
		case .ERR_INITIALIZED:               outStr.Set("Cannot call this command after System::init.");
		case .ERR_INTERNAL:                  outStr.Set("An error occurred that wasn't supposed to.  Contact support.");
		case .ERR_INVALID_FLOAT:             outStr.Set("Value passed in was a NaN, Inf or denormalized float.");
		case .ERR_INVALID_HANDLE:            outStr.Set("An invalid object handle was used.");
		case .ERR_INVALID_PARAM:             outStr.Set("An invalid parameter was passed to this function.");
		case .ERR_INVALID_POSITION:          outStr.Set("An invalid seek position was passed to this function.");
		case .ERR_INVALID_SPEAKER:           outStr.Set("An invalid speaker was passed to this function based on the current speaker mode.");
		case .ERR_INVALID_SYNCPOINT:         outStr.Set("The syncpoint did not come from this sound handle.");
		case .ERR_INVALID_THREAD:            outStr.Set("Tried to call a function on a thread that is not supported.");
		case .ERR_INVALID_VECTOR:            outStr.Set("The vectors passed in are not unit length, or perpendicular.");
		case .ERR_MAXAUDIBLE:                outStr.Set("Reached maximum audible playback count for this sound's soundgroup.");
		case .ERR_MEMORY:                    outStr.Set("Not enough memory or resources.");
		case .ERR_MEMORY_CANTPOINT:          outStr.Set("Can't use FMOD_OPENMEMORY_POINT on non PCM source data, or non mp3/xma/adpcm data if FMOD_CREATECOMPRESSEDSAMPLE was used.");
		case .ERR_NEEDS3D:                   outStr.Set("Tried to call a command on a 2d sound when the command was meant for 3d sound.");
		case .ERR_NEEDSHARDWARE:             outStr.Set("Tried to use a feature that requires hardware support.");
		case .ERR_NET_CONNECT:               outStr.Set("Couldn't connect to the specified host.");
		case .ERR_NET_SOCKET_ERROR:          outStr.Set("A socket error occurred.  This is a catch-all for socket-related errors not listed elsewhere.");
		case .ERR_NET_URL:                   outStr.Set("The specified URL couldn't be resolved.");
		case .ERR_NET_WOULD_BLOCK:           outStr.Set("Operation on a non-blocking socket could not complete immediately.");
		case .ERR_NOTREADY:                  outStr.Set("Operation could not be performed because specified sound/DSP connection is not ready.");
		case .ERR_OUTPUT_ALLOCATED:          outStr.Set("Error initializing output device, but more specifically, the output device is already in use and cannot be reused.");
		case .ERR_OUTPUT_CREATEBUFFER:       outStr.Set("Error creating hardware sound buffer.");
		case .ERR_OUTPUT_DRIVERCALL:         outStr.Set("A call to a standard soundcard driver failed, which could possibly mean a bug in the driver or resources were missing or exhausted.");
		case .ERR_OUTPUT_FORMAT:             outStr.Set("Soundcard does not support the specified format.");
		case .ERR_OUTPUT_INIT:               outStr.Set("Error initializing output device.");
		case .ERR_OUTPUT_NODRIVERS:          outStr.Set("The output device has no drivers installed.  If pre-init, FMOD_OUTPUT_NOSOUND is selected as the output mode.  If post-init, the function just fails.");
		case .ERR_PLUGIN:                    outStr.Set("An unspecified error has been returned from a plugin.");
		case .ERR_PLUGIN_MISSING:            outStr.Set("A requested output, dsp unit type or codec was not available.");
		case .ERR_PLUGIN_RESOURCE:           outStr.Set("A resource that the plugin requires cannot be allocated or found. (ie the DLS file for MIDI playback)");
		case .ERR_PLUGIN_VERSION:            outStr.Set("A plugin was built with an unsupported SDK version.");
		case .ERR_RECORD:                    outStr.Set("An error occurred trying to initialize the recording device.");
		case .ERR_REVERB_CHANNELGROUP:       outStr.Set("Reverb properties cannot be set on this channel because a parent channelgroup owns the reverb connection.");
		case .ERR_REVERB_INSTANCE:           outStr.Set("Specified instance in FMOD_REVERB_PROPERTIES couldn't be set. Most likely because it is an invalid instance number or the reverb doesn't exist.");
		case .ERR_SUBSOUNDS:                 outStr.Set("The error occurred because the sound referenced contains subsounds when it shouldn't have, or it doesn't contain subsounds when it should have.  The operation may also not be able to be performed on a parent sound.");
		case .ERR_SUBSOUND_ALLOCATED:        outStr.Set("This subsound is already being used by another sound, you cannot have more than one parent to a sound.  Null out the other parent's entry first.");
		case .ERR_SUBSOUND_CANTMOVE:         outStr.Set("Shared subsounds cannot be replaced or moved from their parent stream, such as when the parent stream is an FSB file.");
		case .ERR_TAGNOTFOUND:               outStr.Set("The specified tag could not be found or there are no tags.");
		case .ERR_TOOMANYCHANNELS:           outStr.Set("The sound created exceeds the allowable input channel count.  This can be increased using the 'maxinputchannels' parameter in System::setSoftwareFormat.");
		case .ERR_TRUNCATED:                 outStr.Set("The retrieved string is too long to fit in the supplied buffer and has been truncated.");
		case .ERR_UNIMPLEMENTED:             outStr.Set("Something in FMOD hasn't been implemented when it should be! contact support!");
		case .ERR_UNINITIALIZED:             outStr.Set("This command failed because System::init or System::setDriver was not called.");
		case .ERR_UNSUPPORTED:               outStr.Set("A command issued was not supported by this object.  Possibly a plugin without certain callbacks specified.");
		case .ERR_VERSION:                   outStr.Set("The version number of this file format is not supported.");
		case .ERR_EVENT_ALREADY_LOADED:      outStr.Set("The specified bank has already been loaded.");
		case .ERR_EVENT_LIVEUPDATE_BUSY:     outStr.Set("The live update connection failed due to the game already being connected.");
		case .ERR_EVENT_LIVEUPDATE_MISMATCH: outStr.Set("The live update connection failed due to the game data being out of sync with the tool.");
		case .ERR_EVENT_LIVEUPDATE_TIMEOUT:  outStr.Set("The live update connection timed out.");
		case .ERR_EVENT_NOTFOUND:            outStr.Set("The requested event, parameter, bus or vca could not be found.");
		case .ERR_STUDIO_UNINITIALIZED:      outStr.Set("The Studio::System object is not yet initialized.");
		case .ERR_STUDIO_NOT_LOADED:         outStr.Set("The specified resource is not loaded, so it can't be unloaded.");
		case .ERR_INVALID_STRING:            outStr.Set("An invalid string was passed to this function.");
		case .ERR_ALREADY_LOCKED:            outStr.Set("The specified resource is already locked.");
		case .ERR_NOT_LOCKED:                outStr.Set("The specified resource is not locked, so it can't be unlocked.");
		case .ERR_RECORD_DISCONNECTED:       outStr.Set("The specified recording driver has been disconnected.");
		case .ERR_TOOMANYSAMPLES:            outStr.Set("The length provided exceeds the allowable limit.");
		default :                            outStr.Set("Unknown error.");
		}
	}
}