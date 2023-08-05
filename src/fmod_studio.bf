/* ======================================================================================== */
/* FMOD Studio API - C header file.                                                         */
/* Copyright (c), Firelight Technologies Pty, Ltd. 2004-2023.                               */
/*                                                                                          */
/* Use this header in conjunction with fmod_studio_common.h (which contains all the         */
/* constants / callbacks) to develop using the C language.                                  */
/*                                                                                          */
/* For more detail visit:                                                                   */
/* https://fmod.com/docs/2.02/api/studio-api.html                                           */
/* ======================================================================================== */
namespace Beef_FMOD;

using System;


public struct FMOD_STUDIO
{
	public struct STUDIO_VERSION
	{
#if BF_PLATFORM_WINDOWS
	#if BF_32_BIT || BF_64_BIT
		public const String DLL = "fmodstudio.dll";
	#else
		#error Unsupported CPU
	#endif
#endif
	}

	public const uint32 LOAD_MEMORY_ALIGNMENT = 32;

	public enum INITFLAGS : uint32
	{
	    NORMAL                = 0x00000000,
	    LIVEUPDATE            = 0x00000001,
	    ALLOW_MISSING_PLUGINS = 0x00000002,
	    SYNCHRONOUS_UPDATE    = 0x00000004,
	    DEFERRED_CALLBACKS    = 0x00000008,
	    LOAD_FROM_UPDATE      = 0x00000010,
	    MEMORY_TRACKING       = 0x00000020,
	}

    public enum PARAMETER_FLAGS : uint
    {
        READONLY  = 0x00000001,
        AUTOMATIC = 0x00000002,
        GLOBAL    = 0x00000004,
        DISCRETE  = 0x00000008,
        LABELED   = 0x00000010,
    }

    public enum SYSTEM_CALLBACK_TYPE : uint
    {
        PREUPDATE               = 0x00000001,
        POSTUPDATE              = 0x00000002,
        BANK_UNLOAD             = 0x00000004,
        LIVEUPDATE_CONNECTED    = 0x00000008,
        LIVEUPDATE_DISCONNECTED = 0x00000010,
        ALL                     = 0xFFFFFFFF,
    }

    public enum EVENT_CALLBACK_TYPE : uint
    {
        CREATED                  = 0x00000001,
        DESTROYED                = 0x00000002,
        STARTING                 = 0x00000004,
        STARTED                  = 0x00000008,
        RESTARTED                = 0x00000010,
        STOPPED                  = 0x00000020,
        START_FAILED             = 0x00000040,
        CREATE_PROGRAMMER_SOUND  = 0x00000080,
        DESTROY_PROGRAMMER_SOUND = 0x00000100,
        PLUGIN_CREATED           = 0x00000200,
        PLUGIN_DESTROYED         = 0x00000400,
        TIMELINE_MARKER          = 0x00000800,
        TIMELINE_BEAT            = 0x00001000,
        SOUND_PLAYED             = 0x00002000,
        SOUND_STOPPED            = 0x00004000,
        REAL_TO_VIRTUAL          = 0x00008000,
        VIRTUAL_TO_REAL          = 0x00010000,
        START_EVENT_COMMAND      = 0x00020000,
        NESTED_TIMELINE_BEAT     = 0x00040000,
        ALL                      = 0xFFFFFFFF,
    }

    public enum LOAD_BANK_FLAGS : uint32
    {
        NORMAL             = 0x00000000,
        NONBLOCKING        = 0x00000001,
        DECOMPRESS_SAMPLES = 0x00000002,
        UNENCRYPTED        = 0x00000004,
    }

    public enum COMMANDCAPTURE_FLAGS : uint32
    {
        NORMAL                  = 0x00000000,
        FILEFLUSH               = 0x00000001,
        SKIP_INITIAL_STATE      = 0x00000002,
    }

    public enum COMMANDREPLAY_FLAGS : uint32
    {
        NORMAL                  = 0x00000000,
        SKIP_CLEANUP            = 0x00000001,
        FAST_FORWARD            = 0x00000002,
        SKIP_BANK_LOAD          = 0x00000004,
    }

	public enum LOADING_STATE : int32
	{
        UNLOADING,
        UNLOADED,
        LOADING,
        LOADED,
        ERROR
	}

	public enum LOAD_MEMORY_MODE : int32
	{
        LOAD_MEMORY,
        LOAD_MEMORY_POINT
	}

	public enum PARAMETER_TYPE : int32
	{
        GAME_CONTROLLED,
        AUTOMATIC_DISTANCE,
        AUTOMATIC_EVENT_CONE_ANGLE,
        AUTOMATIC_EVENT_ORIENTATION,
        AUTOMATIC_DIRECTION,
        AUTOMATIC_ELEVATION,
        AUTOMATIC_LISTENER_ORIENTATION,
        AUTOMATIC_SPEED,
        AUTOMATIC_SPEED_ABSOLUTE,
        AUTOMATIC_DISTANCE_NORMALIZED,
        MAX
	}

	public enum USER_PROPERTY_TYPE : int32
	{
		INTEGER,
		BOOLEAN,
		FLOAT,
		STRING
	}

	public enum EVENT_PROPERTY : int32
	{
        CHANNELPRIORITY,
        SCHEDULE_DELAY,
        SCHEDULE_LOOKAHEAD,
        MINIMUM_DISTANCE,
        MAXIMUM_DISTANCE,
        COOLDOWN,
        MAX
	}

	public enum PLAYBACK_STATE : int32
	{
        PLAYING,
        SUSTAINING,
        STOPPED,
        STARTING,
        STOPPING
	}

	public enum STOP_MODE : int32
	{
        ALLOWFADEOUT,
        IMMEDIATE
	}

	public enum INSTANCETYPE : int32
	{
        NONE,
        SYSTEM,
        EVENTDESCRIPTION,
        EVENTINSTANCE,
        PARAMETERINSTANCE,
        BUS,
        VCA,
        BANK,
        COMMANDREPLAY
	}

	/*
	    FMOD Studio structures
	*/
	[CRepr]
	public struct BANK_INFO
	{
		public int32                    Size;
		public void*                    UserData;
		public int32                    UserDataLength;
		public FMOD.FILE_OPEN_CALLBACK  OpenCallback;
		public FMOD.FILE_CLOSE_CALLBACK CloseCallback;
		public FMOD.FILE_READ_CALLBACK  ReadCallback;
		public FMOD.FILE_SEEK_CALLBACK  SeekCallback;
	}
	
	[CRepr]
	public struct PARAMETER_ID
	{
		public uint32 Data1;
		public uint32 Data2;
	}
	
	[CRepr]
	public struct PARAMETER_DESCRIPTION
	{
		public readonly char8* Name;
		public PARAMETER_ID    Id;
		public float           Minimum;
		public float           Maximum;
		public float           DefaultValue;
		public PARAMETER_TYPE  Type;
		public PARAMETER_FLAGS Flags;
		public FMOD.GUID       Guid;
	}
	
	[CRepr]
	public struct USER_PROPERTY
	{
		public readonly char8*    Name;
		public USER_PROPERTY_TYPE Type;
		private ValueUnion        U;
	
		[CRepr, Union]
		public struct ValueUnion
		{
			public int32           IntValue;
			public bool            BoolValue;
			public float           FloatValue;
			public readonly char8* StringValue;
		}

        public int32 IntValue()   => (Type == .INTEGER) ? U.IntValue   : -1;
        public bool BoolValue()   => (Type == .BOOLEAN) ? U.BoolValue  : false;
        public float FloatValue() => (Type == .FLOAT)   ? U.FloatValue : -1;
        public void StringValue(String outStr)
		{
			outStr.Clear();
			outStr.Append((Type == .STRING)  ? U.StringValue : "");
		}
	}
	
	[CRepr]
	public struct PROGRAMMER_SOUND_PROPERTIES
	{
		public readonly char8* Name;
		public void*           Sound;
		public int32           SubSoundIndex;
	}
	
	[CRepr]
	public struct PLUGIN_INSTANCE_PROPERTIES
	{
		public readonly char8* Name;
		public void*           DSP;
	}
	
	[CRepr]
	public struct TIMELINE_MARKER_PROPERTIES
	{
		public readonly char8* Name;
		public int32           Position;
	}
	
	[CRepr]
	public struct TIMELINE_BEAT_PROPERTIES
	{
		public int32 Bar;
		public int32 Beat;
		public int32 Position;
		public float Tempo;
		public int32 TimeSignatureUpper;
		public int32 TimeSignatureLower;
	}
	
	[CRepr]
	public struct TIMELINE_NESTED_BEAT_PROPERTIES
	{
		public FMOD.GUID                EventId;
		public TIMELINE_BEAT_PROPERTIES Properties;
	}
	
	[CRepr]
	public struct ADVANCEDSETTINGS
	{
		public int32  CbSize;
		public uint32 CommandQueueSize;
		public uint32 HandleInitialize;
		public int32  StudioUpdatePeriod;
		public int32  IdleSampleDataPoolSize;
		public uint32 StreamingScheduleDelay;
		public char8* EncryptionKey;
	}
	
	[CRepr]
	public struct CPU_USAGE
	{
		public float Update;
	}
	
	[CRepr]
	public struct BUFFER_INFO
	{
		public int32 CurrentUsage;
		public int32 PeakUsage;
		public int32 Capacity;
		public int32 StallCount;
		public int32 StallTime;
	}
	
	[CRepr]
	public struct BUFFER_USAGE
	{
		public BUFFER_INFO StudioCommandQueue;
		public BUFFER_INFO StudioHandle;
	}
	
	[CRepr]
	public struct SOUND_INFO
	{
		public readonly char8*        NameOrData;
		public FMOD.MODE              Mode;
		public FMOD.CREATESOUNDEXINFO ExInfo;
		public int32                  SubSoundIndex;
	}
	
	[CRepr]
	public struct COMMAND_INFO
	{
		public readonly char8* CommandName;
		public int32           ParentCommandIndex;
		public int32           FrameNumber;
		public float           FrameTime;
		public INSTANCETYPE    InstanceType;
		public INSTANCETYPE    OutputType;
		public uint32          InstanceHandle;
		public uint32          OutputHandle;
	}
	
	[CRepr]
	public struct MEMORY_USAGE
	{
		public int32 Exclusive;
		public int32 Inclusive;
		public int32 SampleData;
	}

	/*
	    FMOD Studio callbacks.
	*/
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT SYSTEM_CALLBACK(void* system, SYSTEM_CALLBACK_TYPE type, void* commandData, void* userData);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT EVENT_CALLBACK(EVENT_CALLBACK_TYPE type, void* event, void* parameters);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT COMMANDREPLAY_FRAME_CALLBACK(void* replay, int32 commandIndex, float currentTime, void* userData);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT COMMANDREPLAY_LOAD_BANK_CALLBACK(void* replay, int32 commandIndex, [MangleConst]FMOD.GUID* bankGuid, [MangleConst]char8* bankFileName, LOAD_BANK_FLAGS flags, out void* bank, void* userdata);
	[CallingConvention(.Stdcall)]
	public function FMOD.RESULT COMMANDREPLAY_CREATE_INSTANCE_CALLBACK(void* replay, int32 commandIndex, void* eventDescription, out void* instance, void* userData);

	/*
	    Global
	*/
    public struct Util
	{
        public static FMOD.RESULT ParseID(StringView idString, out FMOD.GUID id) =>
			FMOD_Studio_ParseID(idString.ToScopeCStr!(), out id);

		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_ParseID([MangleConst]char8* idString, out FMOD.GUID id);
	}

	/*
	    System
	*/
	public struct System
	{
        public void* handle;

		public this(void* ptr) { handle = ptr; }
        public bool HasHandle() => handle != null;
        public void ClearHandle() mut { handle = null; }
		public bool IsValid() => HasHandle() && FMOD_Studio_System_IsValid(handle);

		public static FMOD.RESULT Create(out System system) =>
			FMOD_Studio_System_Create(out system.handle, FMOD.VERSION.Number);

		public FMOD.RESULT SetAdvancedSettings(ref ADVANCEDSETTINGS settings)
        {
            settings.CbSize = sizeof(ADVANCEDSETTINGS);
            return FMOD_Studio_System_SetAdvancedSettings(handle, ref settings);
        }

		public FMOD.RESULT SetAdvancedSettings(ref ADVANCEDSETTINGS settings, StringView encryptionKey)
		{
			char8* userKey = settings.EncryptionKey;
			settings.EncryptionKey = encryptionKey.ToScopeCStr!();
			FMOD.RESULT result = SetAdvancedSettings(ref settings);
			settings.EncryptionKey = userKey;
			return result;
		}

		public FMOD.RESULT GetAdvancedSettings(out ADVANCEDSETTINGS settings)
		{
			settings.CbSize = sizeof(ADVANCEDSETTINGS);
			return FMOD_Studio_System_GetAdvancedSettings(handle, out settings);
		}

		public FMOD.RESULT Initialize(int32 maxChannels, INITFLAGS studioFlags, FMOD.INITFLAGS flags, void* extradriverdata) =>
			FMOD_Studio_System_Initialize(handle, maxChannels, studioFlags, flags, extradriverdata);
		public FMOD.RESULT Release() =>
			FMOD_Studio_System_Release(handle);
		public FMOD.RESULT Update() =>
			FMOD_Studio_System_Update(handle);
		public FMOD.RESULT GetCoreSystem(out FMOD.System coreSystem) =>
		    FMOD_Studio_System_GetCoreSystem(handle, out coreSystem.handle);
		public FMOD.RESULT GetEvent(StringView path, out EventDescription _event) =>
			FMOD_Studio_System_GetEvent(handle, path.ToScopeCStr!(), out _event.handle);
		public FMOD.RESULT GetBus(StringView path, out Bus bus) =>
			FMOD_Studio_System_GetBus(handle, path.ToScopeCStr!(), out bus.handle);
		public FMOD.RESULT GetVCA(StringView path, out VCA vca) =>
			FMOD_Studio_System_GetVCA(handle, path.ToScopeCStr!(), out vca.handle);
		public FMOD.RESULT GetBank(StringView path, out Bank bank) =>
			FMOD_Studio_System_GetBank(handle, path.ToScopeCStr!(), out bank.handle);

        public FMOD.RESULT GetEventByID(FMOD.GUID id, out EventDescription _event)
		{
			var id;
            return FMOD_Studio_System_GetEventByID(handle, ref id, out _event.handle);
		}
        public FMOD.RESULT GetBusByID(FMOD.GUID id, out Bus bus)
		{
			var id;
            return FMOD_Studio_System_GetBusByID(handle, ref id, out bus.handle);
		}
        public FMOD.RESULT GetVCAByID(FMOD.GUID id, out VCA vca)
		{
			var id;
            return FMOD_Studio_System_GetVCAByID(handle, ref id, out vca.handle);
		}
        public FMOD.RESULT GetBankByID(FMOD.GUID id, out Bank bank)
		{
			var id;
            return FMOD_Studio_System_GetBankByID(handle, ref id, out bank.handle);
		}
        public FMOD.RESULT GetSoundInfo(StringView key, out SOUND_INFO info) =>
            FMOD_Studio_System_GetSoundInfo(handle, key.ToScopeCStr!(), out info);
        public FMOD.RESULT GetParameterDescriptionByName(StringView name, out PARAMETER_DESCRIPTION parameter) =>
            FMOD_Studio_System_GetParameterDescriptionByName(handle, name.ToScopeCStr!(), out parameter);
        public FMOD.RESULT GetParameterDescriptionByID(PARAMETER_ID id, out PARAMETER_DESCRIPTION parameter) =>
			FMOD_Studio_System_GetParameterDescriptionByID(handle, id, out parameter);
		public FMOD.RESULT GetParameterLabelByName(StringView name, int32 labelindex, String outLabel)
		{
			outLabel.Clear();
			char8* stringMem = new char8[256]*;
			int32 retrieved = 0;

			FMOD.RESULT result = FMOD_Studio_System_GetParameterLabelByName(handle, name.ToScopeCStr!(), labelindex, stringMem, 256, out retrieved);

			if (result == .ERR_TRUNCATED)
			{
				delete stringMem;
                result = FMOD_Studio_System_GetParameterLabelByName(handle, name.ToScopeCStr!(), labelindex, null, 0, out retrieved);
				stringMem = new char8[retrieved]*;
				result = FMOD_Studio_System_GetParameterLabelByName(handle, name.ToScopeCStr!(), labelindex, stringMem, retrieved, out retrieved);
			}

			if (result == .OK)
				outLabel.Append(stringMem);

			delete stringMem;
			return result;
		}
		public FMOD.RESULT GetParameterLabelByID(PARAMETER_ID id, int32 labelindex, String outLabel)
		{
			outLabel.Clear();
			char8* stringMem = new char8[256]*;
			int32 retrieved = 0;

			FMOD.RESULT result = FMOD_Studio_System_GetParameterLabelByID(handle, id, labelindex, stringMem, 256, out retrieved);

			if (result == .ERR_TRUNCATED)
			{
				delete stringMem;
                result = FMOD_Studio_System_GetParameterLabelByID(handle, id, labelindex, null, 0, out retrieved);
				stringMem = new char8[retrieved]*;
				result = FMOD_Studio_System_GetParameterLabelByID(handle, id, labelindex, stringMem, retrieved, out retrieved);
			}

			if (result == .OK)
				outLabel.Append(stringMem);

			delete stringMem;
			return result;
		}
		public FMOD.RESULT GetParameterByID(PARAMETER_ID id, out float value) =>
		    GetParameterByID(id, out value, var finalValue);
		public FMOD.RESULT GetParameterByID(PARAMETER_ID id, out float value, out float finalvalue) =>
			FMOD_Studio_System_GetParameterByID(handle, id, out value, out finalvalue);
		public FMOD.RESULT SetParameterByID(PARAMETER_ID id, float value, bool ignoreseekspeed = false) =>
			FMOD_Studio_System_SetParameterByID(handle, id, value, ignoreseekspeed);
		public FMOD.RESULT SetParameterByIDWithLabel(PARAMETER_ID id, StringView label, bool ignoreseekspeed = false) =>
			FMOD_Studio_System_SetParameterByIDWithLabel(handle, id, label.ToScopeCStr!(), ignoreseekspeed);
		public FMOD.RESULT SetParametersByIDs(PARAMETER_ID[] ids, float[] values, int32 count, bool ignoreseekspeed = false) =>
			FMOD_Studio_System_SetParametersByIDs(handle, ids, values, count, ignoreseekspeed);
		public FMOD.RESULT GetParameterByName(StringView name, out float value) =>
			GetParameterByName(name, out value, var finalValue);
		public FMOD.RESULT GetParameterByName(StringView name, out float value, out float finalvalue) =>
			FMOD_Studio_System_GetParameterByName(handle, name.ToScopeCStr!(), out value, out finalvalue);
		public FMOD.RESULT SetParameterByName(StringView name, float value, bool ignoreseekspeed = false) =>
			FMOD_Studio_System_SetParameterByName(handle, name.ToScopeCStr!(), value, ignoreseekspeed);
		public FMOD.RESULT SetParameterByNameWithLabel(StringView name, StringView label, bool ignoreseekspeed = false) =>
			FMOD_Studio_System_SetParameterByNameWithLabel(handle, name.ToScopeCStr!(), label.ToScopeCStr!(), ignoreseekspeed);
		public FMOD.RESULT LookupID(StringView path, out FMOD.GUID id) =>
			FMOD_Studio_System_LookupID(handle, path.ToScopeCStr!(), out id);
		public FMOD.RESULT LookupPath(FMOD.GUID id, String path)
		{
			var id;
		    path.Clear();

			char8* stringMem = new .[256]*;
	        int32 retrieved = 0;
	        FMOD.RESULT result = FMOD_Studio_System_LookupPath(handle, ref id, stringMem, 256, out retrieved);

	        if (result == .ERR_TRUNCATED)
	        {
	            delete stringMem;
	            stringMem = new .[retrieved]*;
	            result = FMOD_Studio_System_LookupPath(handle, ref id, stringMem, retrieved, out retrieved);
	        }

	        if (result == .OK)
	            path.Append(stringMem);

	        delete stringMem;
	        return result;
		}
		public FMOD.RESULT GetNumListeners(out int32 numlisteners) =>
			FMOD_Studio_System_GetNumListeners(handle, out numlisteners);
		public FMOD.RESULT SetNumListeners(int32 numlisteners) =>
			FMOD_Studio_System_SetNumListeners(handle, numlisteners);
		public FMOD.RESULT GetListenerAttributes(int32 listener, out FMOD.ATTRIBUTES_3D attributes) =>
			FMOD_Studio_System_GetListenerAttributes(handle, listener, out attributes, null);
		public FMOD.RESULT GetListenerAttributes(int32 listener, out FMOD.ATTRIBUTES_3D attributes, out FMOD.VECTOR attenuationposition) =>
			FMOD_Studio_System_GetListenerAttributes(handle, listener, out attributes, out attenuationposition);
		public FMOD.RESULT SetListenerAttributes(int32 listener, ref FMOD.ATTRIBUTES_3D attributes) =>
			FMOD_Studio_System_SetListenerAttributes(handle, listener, ref attributes, null);
		public FMOD.RESULT SetListenerAttributes(int32 listener, ref FMOD.ATTRIBUTES_3D attributes, ref FMOD.VECTOR attenuationposition) =>
			FMOD_Studio_System_SetListenerAttributes(handle, listener, ref attributes, ref attenuationposition);
		public FMOD.RESULT GetListenerWeight(int32 listener, out float weight) =>
			FMOD_Studio_System_GetListenerWeight(handle, listener, out weight);
		public FMOD.RESULT SetListenerWeight(int32 listener, float weight) =>
			FMOD_Studio_System_SetListenerWeight(handle, listener, weight);
		public FMOD.RESULT LoadBankFile(StringView filename, LOAD_BANK_FLAGS flags, out Bank bank) =>
			FMOD_Studio_System_LoadBankFile(handle, filename.ToScopeCStr!(), flags, out bank.handle);
		public FMOD.RESULT LoadBankMemory(uint8[] buffer, LOAD_BANK_FLAGS flags, out Bank bank) =>
			FMOD_Studio_System_LoadBankMemory(handle, buffer.CArray(), (int32)buffer.Count, LOAD_MEMORY_MODE.LOAD_MEMORY, flags, out bank.handle);
		public FMOD.RESULT LoadBankCustom(ref BANK_INFO info, LOAD_BANK_FLAGS flags, out Bank bank)
		{
		    info.Size = sizeof(BANK_INFO);
		    return FMOD_Studio_System_LoadBankCustom(handle, ref info, flags, out bank.handle);
		}
		public FMOD.RESULT UnloadAll() =>
			FMOD_Studio_System_UnloadAll(handle);
		public FMOD.RESULT FlushCommands() =>
			FMOD_Studio_System_FlushCommands(handle);
		public FMOD.RESULT FlushSampleLoading() =>
			FMOD_Studio_System_FlushSampleLoading(handle);
		public FMOD.RESULT StartCommandCapture(StringView filename, COMMANDCAPTURE_FLAGS flags) =>
			FMOD_Studio_System_StartCommandCapture(handle, filename.ToScopeCStr!(), flags);
		public FMOD.RESULT StopCommandCapture() =>
			FMOD_Studio_System_StopCommandCapture(handle);
		public FMOD.RESULT LoadCommandReplay(StringView filename, COMMANDREPLAY_FLAGS flags, out CommandReplay replay) =>
			FMOD_Studio_System_LoadCommandReplay(handle, filename.ToScopeCStr!(), flags, out replay.handle);
		public FMOD.RESULT GetBankCount(out int32 count) =>
			FMOD_Studio_System_GetBankCount(handle, out count);
		public FMOD.RESULT GetBankList(out Bank[] array)
		{
		    array = null;

		    FMOD.RESULT result;
		    int32 capacity;
		    result = FMOD_Studio_System_GetBankCount(handle, out capacity);

		    if (result != .OK)
		        return result;

		    if (capacity == 0)
		    {
		        array = new .[0];
		        return result;
		    }

		    void*[] rawArray = new .[capacity];
		    int32 actualCount;
		    result = FMOD_Studio_System_GetBankList(handle, rawArray, capacity, out actualCount);

		    if (result != .OK)
		        return result;

		    if (actualCount > capacity) // More items added since we queried just now?
		        actualCount = capacity;

		    array = new .[actualCount];

		    for (int32 i = 0; i < actualCount; ++i)
		        array[i].handle = rawArray[i];

		    return .OK;
		}
		public FMOD.RESULT GetParameterDescriptionCount(out int32 count) =>
			FMOD_Studio_System_GetParameterDescriptionCount(handle, out count);
		public FMOD.RESULT GetParameterDescriptionList(out PARAMETER_DESCRIPTION[] array)
		{
		    array = null;

		    int32 capacity;
		    FMOD.RESULT result = FMOD_Studio_System_GetParameterDescriptionCount(handle, out capacity);

		    if (result != .OK)
		        return result;

		    if (capacity == 0)
		    {
		        array = new .[0];
		        return .OK;
		    }

		    PARAMETER_DESCRIPTION[] tempArray = new .[capacity];
		    int32 actualCount;
		    result = FMOD_Studio_System_GetParameterDescriptionList(handle, tempArray, capacity, out actualCount);

		    if (result != .OK)
		        return result;

		    if (actualCount != capacity)
		    {
				PARAMETER_DESCRIPTION[] tmp = new .[actualCount];
				Array.Copy(tempArray, tmp, actualCount);
		        delete tempArray;
				tempArray = tmp;
		    }

		    array = tempArray;
		    return .OK;
		}
		public FMOD.RESULT GetCPUUsage(out CPU_USAGE usage, out FMOD.CPU_USAGE usage_core) =>
			FMOD_Studio_System_GetCPUUsage(handle, out usage, out usage_core);
		public FMOD.RESULT GetBufferUsage(out BUFFER_USAGE usage) =>
			FMOD_Studio_System_GetBufferUsage(handle, out usage);
		public FMOD.RESULT ResetBufferUsage() =>
			FMOD_Studio_System_ResetBufferUsage(handle);

		public FMOD.RESULT SetCallback(SYSTEM_CALLBACK callback, SYSTEM_CALLBACK_TYPE callbackmask = .ALL) =>
			FMOD_Studio_System_SetCallback(handle, callback, callbackmask);

		public FMOD.RESULT GetUserData(out void* userdata) =>
			FMOD_Studio_System_GetUserData(handle, out userdata);

		public FMOD.RESULT SetUserData(void* userdata) =>
			FMOD_Studio_System_SetUserData(handle, userdata);

		public FMOD.RESULT GetMemoryUsage(out MEMORY_USAGE memoryusage) =>
			FMOD_Studio_System_GetMemoryUsage(handle, out memoryusage);

		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_Create(out void* system, uint32 headerVersion);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern bool FMOD_Studio_System_IsValid(void* system);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetAdvancedSettings(void* system, ref ADVANCEDSETTINGS settings);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetAdvancedSettings(void* system, out ADVANCEDSETTINGS settings);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_Initialize(void* system, int32 maxChannels, INITFLAGS studioFlags, FMOD.INITFLAGS flags, void* extraDriverData);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_Release(void* system);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_Update(void* system);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetCoreSystem(void* system, out void* coreSystem);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetEvent(void* system, [MangleConst]char8* pathOrID, out void* event);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetBus(void* system, [MangleConst]char8* pathOrID, out void* bus);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetVCA(void* system, [MangleConst]char8* pathOrID, out void* vca);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetBank(void* system, [MangleConst]char8* pathOrID, out void* bank);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetEventByID(void* system, ref FMOD.GUID id, out void* event);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetBusByID(void* system, ref FMOD.GUID id, out void* bus);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetVCAByID(void* system, ref FMOD.GUID id, out void* vca);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetBankByID(void* system, ref FMOD.GUID id, out void* bank);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetSoundInfo(void* system, [MangleConst]char8* key, out SOUND_INFO info);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetParameterDescriptionByName(void* system, [MangleConst]char8* name, out PARAMETER_DESCRIPTION parameter);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetParameterDescriptionByID(void* system, PARAMETER_ID id, out PARAMETER_DESCRIPTION parameter);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetParameterLabelByName(void* system, [MangleConst]char8* name, int32 labelIndex, char8* label, int32 size, out int32 retrieved);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetParameterLabelByID(void* system, PARAMETER_ID id, int32 labelIndex, char8* label, int32 size, out int32 retrieved);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetParameterByID(void* system, PARAMETER_ID id, out float value, out float finalValue);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetParameterByID(void* system, PARAMETER_ID id, float value, bool ignoreSeekSpeed);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetParameterByIDWithLabel(void* system, PARAMETER_ID id, [MangleConst]char8* label, bool ignoreSeekSpeed);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetParametersByIDs(void* system, [MangleConst]PARAMETER_ID[] ids, float[] values, int32 count, bool ignoreSeekSpeed);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetParameterByName(void* system, [MangleConst]char8* name, out float value, out float finalValue);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetParameterByName(void* system, [MangleConst]char8* name, float value, bool ignoreSeekSpeed);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetParameterByNameWithLabel(void* system, [MangleConst]char8* name, [MangleConst]char8* label, bool ignoreSeekSpeed);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_LookupID(void* system, [MangleConst]char8* path, out FMOD.GUID id);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_LookupPath(void* system, ref FMOD.GUID id, char8* path, int32 size, out int32 retrieved);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetNumListeners(void* system, out int32 numListeners);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetNumListeners(void* system, int32 numListeners);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetListenerAttributes(void* system, int32 index, out FMOD.ATTRIBUTES_3D attributes, void* zero);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetListenerAttributes(void* system, int32 index, out FMOD.ATTRIBUTES_3D attributes, out FMOD.VECTOR attenuationPosition);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetListenerAttributes(void* system, int32 index, ref FMOD.ATTRIBUTES_3D attributes, void* zero);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetListenerAttributes(void* system, int32 index, ref FMOD.ATTRIBUTES_3D attributes, ref FMOD.VECTOR attenuationPosition);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetListenerWeight(void* system, int32 index, out float weight);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetListenerWeight(void* system, int32 index, float weight);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_LoadBankFile(void* system, [MangleConst]char8* filename, LOAD_BANK_FLAGS flags, out void* bank);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_LoadBankMemory(void* system, [MangleConst]uint8* buffer, int32 length, LOAD_MEMORY_MODE mode, LOAD_BANK_FLAGS flags, out void* bank);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_LoadBankCustom(void* system, ref BANK_INFO info, LOAD_BANK_FLAGS flags, out void* bank);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_RegisterPlugin(void* system, ref FMOD_DSP.DESCRIPTION description);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_UnregisterPlugin(void* system, [MangleConst]char8* name);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_UnloadAll(void* system);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_FlushCommands(void* system);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_FlushSampleLoading(void* system);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_StartCommandCapture(void* system, [MangleConst]char8* filename, COMMANDCAPTURE_FLAGS flags);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_StopCommandCapture(void* system);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_LoadCommandReplay(void* system, [MangleConst]char8* filename, COMMANDREPLAY_FLAGS flags, out void* replay);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetBankCount(void* system, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetBankList(void* system, void*[] array, int32 capacity, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetParameterDescriptionCount(void* system, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetParameterDescriptionList(void* system, PARAMETER_DESCRIPTION[] array, int32 capacity, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetCPUUsage(void* system, out CPU_USAGE usage, out FMOD.CPU_USAGE usageCore);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetBufferUsage(void* system, out BUFFER_USAGE usage);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_ResetBufferUsage(void* system);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetCallback(void* system, SYSTEM_CALLBACK callback, SYSTEM_CALLBACK_TYPE callbackMask);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_SetUserData(void* system, void* userData);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetUserData(void* system, out void* userData);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_System_GetMemoryUsage(void* system, out MEMORY_USAGE memoryUsage);
	}

	/*
	    EventDescription
	*/
	public struct EventDescription
	{
		public void* handle;

		public this(void* ptr) { handle = ptr; }
		public bool HasHandle() => handle != null;
		public void ClearHandle() mut { handle = null; }
		public bool IsValid() => HasHandle() && FMOD_Studio_EventDescription_IsValid(handle);

		public FMOD.RESULT GetID(out FMOD.GUID id) =>
			FMOD_Studio_EventDescription_GetID(handle, out id);
		public FMOD.RESULT GetPath(String outPath)
		{
			outPath.Clear();
	        char8* stringMem = new char8[256]*;
	        int32 retrieved = 0;
	        FMOD.RESULT result = FMOD_Studio_EventDescription_GetPath(handle, stringMem, 256, out retrieved);

	        if (result == .ERR_TRUNCATED)
	        {
	            delete stringMem;
	            stringMem = new char8[retrieved]*;
	            result = FMOD_Studio_EventDescription_GetPath(handle, stringMem, retrieved, out retrieved);
	        }

	        if (result == .OK)
	            outPath.Append(stringMem);

	        delete stringMem;
	        return result;
		}
		public FMOD.RESULT GetParameterDescriptionCount(out int32 count) =>
			FMOD_Studio_EventDescription_GetParameterDescriptionCount(handle, out count);
		public FMOD.RESULT GetParameterDescriptionByIndex(int32 index, out PARAMETER_DESCRIPTION parameter) =>
			FMOD_Studio_EventDescription_GetParameterDescriptionByIndex(handle, index, out parameter);
		public FMOD.RESULT GetParameterDescriptionByName(StringView name, out PARAMETER_DESCRIPTION parameter) =>
			FMOD_Studio_EventDescription_GetParameterDescriptionByName(handle, name.ToScopeCStr!(), out parameter);
		public FMOD.RESULT GetParameterDescriptionByID(PARAMETER_ID id, out PARAMETER_DESCRIPTION parameter) =>
			FMOD_Studio_EventDescription_GetParameterDescriptionByID(handle, id, out parameter);
		public FMOD.RESULT GetParameterLabelByIndex(int32 index, int32 labelindex, String outLabel)
		{
		    outLabel.Clear();
	        char8* stringMem = new char8[256]*;
	        int32 retrieved = 0;
	        FMOD.RESULT result = FMOD_Studio_EventDescription_GetParameterLabelByIndex(handle, index, labelindex, stringMem, 256, out retrieved);

	        if (result == .ERR_TRUNCATED)
	        {
	        	delete stringMem;
	            result = FMOD_Studio_EventDescription_GetParameterLabelByIndex(handle, index, labelindex, null, 0, out retrieved);
	            stringMem = new char8[retrieved]*;
	            result = FMOD_Studio_EventDescription_GetParameterLabelByIndex(handle, index, labelindex, stringMem, retrieved, out retrieved);
	        }

	        if (result == .OK)
	            outLabel.Append(stringMem);

        	delete stringMem;
	        return result;
		}
		public FMOD.RESULT GetParameterLabelByName(StringView name, int32 labelindex, String outLabel)
		{
		    outLabel.Clear();
	        char8* stringMem = new char8[256]*;
	        int32 retrieved = 0;
	        FMOD.RESULT result = FMOD_Studio_EventDescription_GetParameterLabelByName(handle, name.ToScopeCStr!(), labelindex, stringMem, 256, out retrieved);

	        if (result == .ERR_TRUNCATED)
	        {
	        	delete stringMem;
	            result = FMOD_Studio_EventDescription_GetParameterLabelByName(handle, name.ToScopeCStr!(), labelindex, null, 0, out retrieved);
	            stringMem = new char8[retrieved]*;
	            result = FMOD_Studio_EventDescription_GetParameterLabelByName(handle, name.ToScopeCStr!(), labelindex, stringMem, retrieved, out retrieved);
	        }

	        if (result == .OK)
	            outLabel.Append(stringMem);

	        delete stringMem;
	        return result;
		}
		public FMOD.RESULT GetParameterLabelByID(PARAMETER_ID id, int32 labelindex, String outLabel)
		{
		    outLabel.Clear();
	        char8* stringMem = new char8[256]*;
	        int32 retrieved = 0;
	        FMOD.RESULT result = FMOD_Studio_EventDescription_GetParameterLabelByID(handle, id, labelindex, stringMem, 256, out retrieved);

	        if (result == .ERR_TRUNCATED)
	        {
	            delete stringMem;
	            result = FMOD_Studio_EventDescription_GetParameterLabelByID(handle, id, labelindex, null, 0, out retrieved);
	            stringMem = new char8[retrieved]*;
	            result = FMOD_Studio_EventDescription_GetParameterLabelByID(handle, id, labelindex, stringMem, retrieved, out retrieved);
	        }

	        if (result == .OK)
	            outLabel.Append(stringMem);

	        delete stringMem;
	        return result;
		}
		public FMOD.RESULT GetUserPropertyCount(out int32 count) =>
			FMOD_Studio_EventDescription_GetUserPropertyCount(handle, out count);
		public FMOD.RESULT GetUserPropertyByIndex(int32 index, out USER_PROPERTY property) =>
			FMOD_Studio_EventDescription_GetUserPropertyByIndex(handle, index, out property);
		public FMOD.RESULT GetUserProperty(StringView name, out USER_PROPERTY property) =>
			FMOD_Studio_EventDescription_GetUserProperty(handle, name.ToScopeCStr!(), out property);
		public FMOD.RESULT GetLength(out int32 length) =>
			FMOD_Studio_EventDescription_GetLength(handle, out length);
		public FMOD.RESULT GetMinMaxDistance(out float min, out float max) =>
			FMOD_Studio_EventDescription_GetMinMaxDistance(handle, out min, out max);
		public FMOD.RESULT GetSoundSize(out float size) =>
			FMOD_Studio_EventDescription_GetSoundSize(handle, out size);
		public FMOD.RESULT IsSnapshot(out bool snapshot) =>
			FMOD_Studio_EventDescription_IsSnapshot(handle, out snapshot);
		public FMOD.RESULT IsOneshot(out bool oneshot) =>
			FMOD_Studio_EventDescription_IsOneshot(handle, out oneshot);
		public FMOD.RESULT IsStream(out bool isStream) =>
			FMOD_Studio_EventDescription_IsStream(handle, out isStream);
		public FMOD.RESULT Is3D(out bool is3D) =>
			FMOD_Studio_EventDescription_Is3D(handle, out is3D);
		public FMOD.RESULT IsDopplerEnabled(out bool doppler) =>
			FMOD_Studio_EventDescription_IsDopplerEnabled(handle, out doppler);
		public FMOD.RESULT HasSustainPoint(out bool sustainPoint) =>
			FMOD_Studio_EventDescription_HasSustainPoint(handle, out sustainPoint);

		public FMOD.RESULT CreateInstance(out EventInstance instance) =>
			FMOD_Studio_EventDescription_CreateInstance(handle, out instance.handle);
		public FMOD.RESULT GetInstanceCount(out int32 count) =>
			FMOD_Studio_EventDescription_GetInstanceCount(handle, out count);
		public FMOD.RESULT GetInstanceList(out EventInstance[] array)
		{
		    array = null;

		    FMOD.RESULT result;
		    int32 capacity;
		    result = FMOD_Studio_EventDescription_GetInstanceCount(handle, out capacity);

		    if (result != .OK)
		        return result;

		    if (capacity == 0)
		    {
		        array = new .[0];
		        return result;
		    }

		    void*[] rawArray = new .[capacity];
		    int32 actualCount;
		    result = FMOD_Studio_EventDescription_GetInstanceList(handle, rawArray, capacity, out actualCount);

		    if (result != .OK)
		        return result;

		    if (actualCount > capacity) // More items added since we queried just now?
		        actualCount = capacity;

		    array = new .[actualCount];

		    for (int32 i = 0; i < actualCount; ++i)
		        array[i].handle = rawArray[i];

		    return .OK;
		}
		public FMOD.RESULT LoadSampleData() =>
			FMOD_Studio_EventDescription_LoadSampleData(handle);
		public FMOD.RESULT UnloadSampleData() =>
			FMOD_Studio_EventDescription_UnloadSampleData(handle);
		public FMOD.RESULT GetSampleLoadingState(out LOADING_STATE state) =>
			FMOD_Studio_EventDescription_GetSampleLoadingState(handle, out state);
		public FMOD.RESULT ReleaseAllInstances() =>
			FMOD_Studio_EventDescription_ReleaseAllInstances(handle);
		public FMOD.RESULT SetCallback(EVENT_CALLBACK callback, EVENT_CALLBACK_TYPE callbackmask = .ALL) =>
			FMOD_Studio_EventDescription_SetCallback(handle, callback, callbackmask);
		public FMOD.RESULT GetUserData(out void* userdata) =>
			FMOD_Studio_EventDescription_GetUserData(handle, out userdata);
		public FMOD.RESULT SetUserData(void* userdata) =>
			FMOD_Studio_EventDescription_SetUserData(handle, userdata);

		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern bool FMOD_Studio_EventDescription_IsValid(void* eventDescription);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetID(void* eventDescription, out FMOD.GUID id);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetPath(void* eventDescription, char8* path, int32 size, out int32 retrieved);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetParameterDescriptionCount(void* eventDescription, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetParameterDescriptionByIndex(void* eventDescription, int32 index, out PARAMETER_DESCRIPTION parameter);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetParameterDescriptionByName(void* eventDescription, [MangleConst]char8* name, out PARAMETER_DESCRIPTION parameter);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetParameterDescriptionByID(void* eventDescription, PARAMETER_ID id, out PARAMETER_DESCRIPTION parameter);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetParameterLabelByIndex(void* eventDescription, int32 index, int32 labelIndex, char8* label, int32 size, out int32 retrieved);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetParameterLabelByName(void* eventDescription, [MangleConst]char8* name, int32 labelIndex, char8* label, int32 size, out int32 retrieved);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetParameterLabelByID(void* eventDescription, PARAMETER_ID id, int32 labelIndex, char8* label, int32 size, out int32 retrieved);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetUserPropertyCount(void* eventDescription, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetUserPropertyByIndex(void* eventDescription, int32 index, out USER_PROPERTY property);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetUserProperty(void* eventDescription, [MangleConst]char8* name, out USER_PROPERTY property);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetLength(void* eventDescription, out int32 length);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetMinMaxDistance(void* eventDescription, out float min, out float max);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetSoundSize(void* eventDescription, out float size);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_IsSnapshot(void* eventDescription, out bool snapshot);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_IsOneshot(void* eventDescription, out bool oneShot);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_IsStream(void* eventDescription, out bool isStream);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_Is3D(void* eventDescription, out bool is3D);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_IsDopplerEnabled(void* eventDescription, out bool doppler);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_HasSustainPoint(void* eventDescription, out bool sustainPoint);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_CreateInstance(void* eventDescription, out void* instance);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetInstanceCount(void* eventDescription, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetInstanceList(void* eventDescription, void*[] array, int32 capacity, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_LoadSampleData(void* eventDescription);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_UnloadSampleData(void* eventDescription);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetSampleLoadingState(void* eventDescription, out LOADING_STATE state);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_ReleaseAllInstances(void* eventDescription);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_SetCallback(void* eventDescription, EVENT_CALLBACK callback, EVENT_CALLBACK_TYPE callbackMask);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_GetUserData(void* eventDescription, out void* userData);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventDescription_SetUserData(void* eventDescription, void* userData);  
	} 

	/*
	    EventInstance
	*/
	public struct EventInstance
	{
		public void* handle;

		public this(void* ptr) { handle = ptr; }
		public bool HasHandle() => handle != null;
		public void ClearHandle() mut { handle = null; }
		public bool IsValid() => HasHandle() && FMOD_Studio_EventInstance_IsValid(handle);

		public FMOD.RESULT GetDescription(out EventDescription description) =>
			FMOD_Studio_EventInstance_GetDescription(handle, out description.handle);
		public FMOD.RESULT GetVolume(out float volume) =>
			FMOD_Studio_EventInstance_GetVolume(handle, out volume, var _);
		public FMOD.RESULT GetVolume(out float volume, out float finalvolume) =>
			FMOD_Studio_EventInstance_GetVolume(handle, out volume, out finalvolume);
		public FMOD.RESULT SetVolume(float volume) =>
			FMOD_Studio_EventInstance_SetVolume(handle, volume);
		public FMOD.RESULT GetPitch(out float pitch) =>
			FMOD_Studio_EventInstance_GetPitch(handle, out pitch, var _);
		public FMOD.RESULT GetPitch(out float pitch, out float finalpitch) =>
			FMOD_Studio_EventInstance_GetPitch(handle, out pitch, out finalpitch);
		public FMOD.RESULT SetPitch(float pitch) =>
			FMOD_Studio_EventInstance_SetPitch(handle, pitch);
		public FMOD.RESULT Get3DAttributes(out FMOD.ATTRIBUTES_3D attributes) =>
			FMOD_Studio_EventInstance_Get3DAttributes(handle, out attributes);
		public FMOD.RESULT Set3DAttributes(FMOD.ATTRIBUTES_3D attributes)
		{
			var attributes;
		    return FMOD_Studio_EventInstance_Set3DAttributes(handle, ref attributes);
		}
		public FMOD.RESULT GetListenerMask(out uint32 mask) =>
			FMOD_Studio_EventInstance_GetListenerMask(handle, out mask);
		public FMOD.RESULT SetListenerMask(uint32 mask) =>
			FMOD_Studio_EventInstance_SetListenerMask(handle, mask);
		public FMOD.RESULT GetProperty(EVENT_PROPERTY index, out float value) =>
			FMOD_Studio_EventInstance_GetProperty(handle, index, out value);
		public FMOD.RESULT SetProperty(EVENT_PROPERTY index, float value) =>
			FMOD_Studio_EventInstance_SetProperty(handle, index, value);
		public FMOD.RESULT GetReverbLevel(int32 index, out float level) =>
			FMOD_Studio_EventInstance_GetReverbLevel(handle, index, out level);
		public FMOD.RESULT SetReverbLevel(int32 index, float level) =>
			FMOD_Studio_EventInstance_SetReverbLevel(handle, index, level);
		public FMOD.RESULT GetPaused(out bool paused) =>
			FMOD_Studio_EventInstance_GetPaused(handle, out paused);
		public FMOD.RESULT SetPaused(bool paused) =>
			FMOD_Studio_EventInstance_SetPaused(handle, paused);
		public FMOD.RESULT Start() =>
			FMOD_Studio_EventInstance_Start(handle);
		public FMOD.RESULT Stop(STOP_MODE mode) =>
			FMOD_Studio_EventInstance_Stop(handle, mode);
		public FMOD.RESULT GetTimelinePosition(out int32 position) =>
			FMOD_Studio_EventInstance_GetTimelinePosition(handle, out position);
		public FMOD.RESULT SetTimelinePosition(int32 position) =>
			FMOD_Studio_EventInstance_SetTimelinePosition(handle, position);
		public FMOD.RESULT GetPlaybackState(out PLAYBACK_STATE state) =>
			FMOD_Studio_EventInstance_GetPlaybackState(handle, out state);
		public FMOD.RESULT GetChannelGroup(out FMOD.ChannelGroup group) =>
			FMOD_Studio_EventInstance_GetChannelGroup(handle, out group.handle);
		public FMOD.RESULT GetMinMaxDistance(out float min, out float max) =>
			FMOD_Studio_EventInstance_GetMinMaxDistance(handle, out min, out max);
		public FMOD.RESULT Release() =>
			FMOD_Studio_EventInstance_Release(handle);
		public FMOD.RESULT IsVirtual(out bool virtualstate) =>
			FMOD_Studio_EventInstance_IsVirtual(handle, out virtualstate);
		public FMOD.RESULT GetParameterByID(PARAMETER_ID id, out float value) =>
			GetParameterByID(id, out value, var _);
		public FMOD.RESULT GetParameterByID(PARAMETER_ID id, out float value, out float finalvalue) =>
			FMOD_Studio_EventInstance_GetParameterByID(handle, id, out value, out finalvalue);
		public FMOD.RESULT SetParameterByID(PARAMETER_ID id, float value, bool ignoreseekspeed = false) =>
			FMOD_Studio_EventInstance_SetParameterByID(handle, id, value, ignoreseekspeed);
		public FMOD.RESULT SetParameterByIDWithLabel(PARAMETER_ID id, StringView label, bool ignoreseekspeed = false) =>
			FMOD_Studio_EventInstance_SetParameterByIDWithLabel(handle, id, label.ToScopeCStr!(), ignoreseekspeed);
		public FMOD.RESULT SetParametersByIDs(PARAMETER_ID[] ids, float[] values, int32 count, bool ignoreseekspeed = false) =>
			FMOD_Studio_EventInstance_SetParametersByIDs(handle, ids, values, count, ignoreseekspeed);
		public FMOD.RESULT GetParameterByName(StringView name, out float value) =>
			GetParameterByName(name, out value, var _);
		public FMOD.RESULT GetParameterByName(StringView name, out float value, out float finalvalue) =>
			FMOD_Studio_EventInstance_GetParameterByName(handle, name.ToScopeCStr!(), out value, out finalvalue);
		public FMOD.RESULT SetParameterByName(StringView name, float value, bool ignoreseekspeed = false) =>
			FMOD_Studio_EventInstance_SetParameterByName(handle, name.ToScopeCStr!(), value, ignoreseekspeed);
		public FMOD.RESULT SetParameterByNameWithLabel(StringView name, StringView label, bool ignoreseekspeed = false) =>
			FMOD_Studio_EventInstance_SetParameterByNameWithLabel(handle, name.ToScopeCStr!(), label.ToScopeCStr!(), ignoreseekspeed);
		public FMOD.RESULT KeyOff() =>
			FMOD_Studio_EventInstance_KeyOff(handle);
		public FMOD.RESULT SetCallback(EVENT_CALLBACK callback, EVENT_CALLBACK_TYPE callbackmask = .ALL) =>
			FMOD_Studio_EventInstance_SetCallback(handle, callback, callbackmask);
		public FMOD.RESULT GetUserData(out void* userdata) =>
			FMOD_Studio_EventInstance_GetUserData(handle, out userdata);
		public FMOD.RESULT SetUserData(void* userdata) =>
			FMOD_Studio_EventInstance_SetUserData(handle, userdata);
		public FMOD.RESULT GetCPUUsage(out uint32 exclusive, out uint32 inclusive) =>
			FMOD_Studio_EventInstance_GetCPUUsage(handle, out exclusive, out inclusive);
		public FMOD.RESULT GetMemoryUsage(out MEMORY_USAGE memoryusage) =>
			FMOD_Studio_EventInstance_GetMemoryUsage(handle, out memoryusage);

		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern bool FMOD_Studio_EventInstance_IsValid(void* eventInstance);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetDescription(void* eventInstance, out void* description);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetVolume(void* eventInstance, out float volume, out float finalVolume);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetVolume(void* eventInstance, float volume);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetPitch(void* eventInstance, out float pitch, out float finalPitch);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetPitch(void* eventInstance, float pitch);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_Get3DAttributes(void* eventInstance, out FMOD.ATTRIBUTES_3D attributes);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_Set3DAttributes(void* eventInstance, ref FMOD.ATTRIBUTES_3D attributes);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetListenerMask(void* eventInstance, out uint32 mask);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetListenerMask(void* eventInstance, uint32 mask);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetProperty(void* eventInstance, EVENT_PROPERTY index, out float value);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetProperty(void* eventInstance, EVENT_PROPERTY index, float value);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetReverbLevel(void* eventInstance, int32 index, out float level);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetReverbLevel(void* eventInstance, int32 index, float level);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetPaused(void* eventInstance, out bool paused);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetPaused(void* eventInstance, bool paused);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_Start(void* eventInstance);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_Stop(void* eventInstance, STOP_MODE mode);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetTimelinePosition(void* eventInstance, out int32 position);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetTimelinePosition(void* eventInstance, int32 position);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetPlaybackState(void* eventInstance, out PLAYBACK_STATE state);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetChannelGroup(void* eventInstance, out void* group);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetMinMaxDistance(void* eventInstance, out float min, out float max);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_Release(void* eventInstance);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_IsVirtual(void* eventInstance, out bool virtualState);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetParameterByName(void* eventInstance, [MangleConst]char8* name, out float value, out float finalValue);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetParameterByName(void* eventInstance, [MangleConst]char8* name, float value, bool ignoreSeekSpeed);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetParameterByNameWithLabel(void* eventInstance, [MangleConst]char8* name, [MangleConst]char8* label, bool ignoreSeekSpeed);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetParameterByID(void* eventInstance, PARAMETER_ID id, out float value, out float finalValue);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetParameterByID(void* eventInstance, PARAMETER_ID id, float value, bool ignoreSeekSpeed);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetParameterByIDWithLabel(void* eventInstance, PARAMETER_ID id, [MangleConst]char8* label, bool ignoreSeekSpeed);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetParametersByIDs(void* eventInstance, [MangleConst]PARAMETER_ID[] ids, float[] values, int32 count, bool ignoreSeekSpeed);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_KeyOff(void* eventInstance);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetCallback(void* eventInstance, EVENT_CALLBACK callback, EVENT_CALLBACK_TYPE callbackMask);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetUserData(void* eventInstance, out void* userData);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_SetUserData(void* eventInstance, void* userData);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetCPUUsage(void* eventInstance, out uint32 exclusive, out uint32 inclusive);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_EventInstance_GetMemoryUsage(void* eventInstance, out MEMORY_USAGE memoryUsage);
	}

	/*
	    Bus
	*/
	public struct Bus
	{
		public void* handle;

		public this(void* ptr) { handle = ptr; }
		public bool HasHandle() => handle != null;
		public void ClearHandle() mut { handle = null; }
		public bool IsValid() => HasHandle() && FMOD_Studio_Bus_IsValid(handle);

		public FMOD.RESULT GetID(out FMOD.GUID id) =>
			FMOD_Studio_Bus_GetID(handle, out id);
		public FMOD.RESULT GetPath(String outPath)
		{
		    outPath.Clear();
	        char8* stringMem = new char8[256]*;
	        int32 retrieved = 0;
	        FMOD.RESULT result = FMOD_Studio_Bus_GetPath(handle, stringMem, 256, out retrieved);

	        if (result == .ERR_TRUNCATED)
	        {
	            delete stringMem;
	            stringMem = new char8[retrieved]*;
	            result = FMOD_Studio_Bus_GetPath(handle, stringMem, retrieved, out retrieved);
	        }

	        if (result == .OK)
	            outPath.Append(stringMem);

	        delete stringMem;
	        return result;
		}
		public FMOD.RESULT GetVolume(out float volume) =>
			GetVolume(out volume, var _);
		public FMOD.RESULT GetVolume(out float volume, out float finalvolume) =>
			FMOD_Studio_Bus_GetVolume(handle, out volume, out finalvolume);
		public FMOD.RESULT SetVolume(float volume) =>
			FMOD_Studio_Bus_SetVolume(handle, volume);
		public FMOD.RESULT GetPaused(out bool paused) =>
			FMOD_Studio_Bus_GetPaused(handle, out paused);
		public FMOD.RESULT SetPaused(bool paused) =>
			FMOD_Studio_Bus_SetPaused(handle, paused);
		public FMOD.RESULT GetMute(out bool mute) =>
			FMOD_Studio_Bus_GetMute(handle, out mute);
		public FMOD.RESULT SetMute(bool mute) =>
			FMOD_Studio_Bus_SetMute(handle, mute);
		public FMOD.RESULT StopAllEvents(STOP_MODE mode) =>
			FMOD_Studio_Bus_StopAllEvents(handle, mode);
		public FMOD.RESULT LockChannelGroup() =>
			FMOD_Studio_Bus_LockChannelGroup(handle);
		public FMOD.RESULT UnlockChannelGroup() =>
			FMOD_Studio_Bus_UnlockChannelGroup(handle);
		public FMOD.RESULT GetChannelGroup(out FMOD.ChannelGroup group) =>
			FMOD_Studio_Bus_GetChannelGroup(handle, out group.handle);
		public FMOD.RESULT GetCPUUsage(out uint32 exclusive, out uint32 inclusive) =>
			FMOD_Studio_Bus_GetCPUUsage(handle, out exclusive, out inclusive);
		public FMOD.RESULT GetMemoryUsage(out MEMORY_USAGE memoryusage) =>
			FMOD_Studio_Bus_GetMemoryUsage(handle, out memoryusage);
		public FMOD.RESULT GetPortIndex(out FMOD.PORT_INDEX index) =>
			FMOD_Studio_Bus_GetPortIndex(handle, out index);
		public FMOD.RESULT SetPortIndex(FMOD.PORT_INDEX index) =>
			FMOD_Studio_Bus_SetPortIndex(handle, index);

		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern bool FMOD_Studio_Bus_IsValid(void* bus);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_GetID(void* bus, out FMOD.GUID id);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_GetPath(void* bus, char8* path, int32 size, out int32 retrieved);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_GetVolume(void* bus, out float volume, out float finalVolume);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_SetVolume(void* bus, float volume);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_GetPaused(void* bus, out bool paused);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_SetPaused(void* bus, bool paused);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_GetMute(void* bus, out bool mute);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_SetMute(void* bus, bool mute);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_StopAllEvents(void* bus, STOP_MODE mode);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_GetPortIndex(void* bus, out FMOD.PORT_INDEX index);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_SetPortIndex(void* bus, FMOD.PORT_INDEX index);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_LockChannelGroup(void* bus);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_UnlockChannelGroup(void* bus);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_GetChannelGroup(void* bus, out void* group);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_GetCPUUsage(void* bus, out uint32 exclusive, out uint32 inclusive);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bus_GetMemoryUsage(void* bus, out MEMORY_USAGE memoryUsage);
	}

	/*
	    VCA
	*/
	public struct VCA
	{
		public void* handle;

		public this(void* ptr) { handle = ptr; }
		public bool HasHandle() => handle != null;
		public void ClearHandle() mut { handle = null; }
		public bool IsValid() => HasHandle() && FMOD_Studio_VCA_IsValid(handle);

		public FMOD.RESULT GetID(out FMOD.GUID id) =>
			FMOD_Studio_VCA_GetID(handle, out id);
		public FMOD.RESULT GetPath(String outPath)
		{
		    outPath.Clear();
	        char8* stringMem = new char8[256]*;
	        int32 retrieved = 0;
	        FMOD.RESULT result = FMOD_Studio_VCA_GetPath(handle, stringMem, 256, out retrieved);

	        if (result == .ERR_TRUNCATED)
	        {
	            delete stringMem;
	            stringMem = new char8[retrieved]*;
	            result = FMOD_Studio_VCA_GetPath(handle, stringMem, retrieved, out retrieved);
	        }

	        if (result == .OK)
	            outPath.Append(stringMem);

	        delete stringMem;
	        return result;
		}
		public FMOD.RESULT GetVolume(out float volume) =>
			GetVolume(out volume, var _);
		public FMOD.RESULT GetVolume(out float volume, out float finalvolume) =>
			FMOD_Studio_VCA_GetVolume(handle, out volume, out finalvolume);
		public FMOD.RESULT setVolume(float volume) =>
			FMOD_Studio_VCA_SetVolume(handle, volume);

		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern bool FMOD_Studio_VCA_IsValid(void* vca);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_VCA_GetID(void* vca, out FMOD.GUID id);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_VCA_GetPath(void* vca, char8* path, int32 size, out int32 retrieved);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_VCA_GetVolume(void* vca, out float volume, out float finalVolume);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_VCA_SetVolume(void* vca, float volume);
	}

	/*
	    Bank
	*/
	public struct Bank
	{
		public void* handle;

		public this(void* ptr) { handle = ptr; }
		public bool HasHandle() => handle != null;
		public void ClearHandle() mut { handle = null; }
		public bool IsValid() => HasHandle() && FMOD_Studio_Bank_IsValid(handle);

		public FMOD.RESULT GetID(out FMOD.GUID id) =>
			FMOD_Studio_Bank_GetID(handle, out id);
		public FMOD.RESULT GetPath(String outPath)
		{
		    outPath.Clear();
	        char8* stringMem = new char8[256]*;
	        int32 retrieved = 0;
	        FMOD.RESULT result = FMOD_Studio_Bank_GetPath(handle, stringMem, 256, out retrieved);

	        if (result == .ERR_TRUNCATED)
	        {
	           	delete stringMem;
	            stringMem = new char8[retrieved]*;
	            result = FMOD_Studio_Bank_GetPath(handle, stringMem, retrieved, out retrieved);
	        }

	        if (result == .OK)
	            outPath.Append(stringMem);

	        delete stringMem;
	        return result;
		}
		public FMOD.RESULT Unload() =>
			FMOD_Studio_Bank_Unload(handle);
		public FMOD.RESULT LoadSampleData() =>
			FMOD_Studio_Bank_LoadSampleData(handle);
		public FMOD.RESULT UnloadSampleData() =>
			FMOD_Studio_Bank_UnloadSampleData(handle);
		public FMOD.RESULT GetLoadingState(out LOADING_STATE state) =>
			FMOD_Studio_Bank_GetLoadingState(handle, out state);
		public FMOD.RESULT GetSampleLoadingState(out LOADING_STATE state) =>
			FMOD_Studio_Bank_GetSampleLoadingState(handle, out state);

		// Enumeration
		public FMOD.RESULT GetStringCount(out int32 count) =>
			FMOD_Studio_Bank_GetStringCount(handle, out count);
		public FMOD.RESULT GetStringInfo(int32 index, out FMOD.GUID id, String outPath)
		{
		    outPath.Clear();
		    id = .();
	        char8* stringMem = new char8[256]*;
	        int32 retrieved = 0;
	        FMOD.RESULT result = FMOD_Studio_Bank_GetStringInfo(handle, index, out id, stringMem, 256, out retrieved);

	        if (result == .ERR_TRUNCATED)
	        {
	            delete stringMem;
	            stringMem = new char8[retrieved]*;
	            result = FMOD_Studio_Bank_GetStringInfo(handle, index, out id, stringMem, retrieved, out retrieved);
	        }

	        if (result == .OK)
	            outPath.Append(stringMem);

	        delete stringMem;
	        return result;
		}

		public FMOD.RESULT GetEventCount(out int32 count) =>
			FMOD_Studio_Bank_GetEventCount(handle, out count);
		public FMOD.RESULT GetEventList(out EventDescription[] array)
		{
		    array = null;

		    FMOD.RESULT result;
		    int32 capacity;
		    result = FMOD_Studio_Bank_GetEventCount(handle, out capacity);

		    if (result != .OK)
		        return result;

		    if (capacity == 0)
		    {
		        array = new .[0];
		        return result;
		    }

		    void*[] rawArray = new .[capacity];
		    int32 actualCount;
		    result = FMOD_Studio_Bank_GetEventList(handle, rawArray, capacity, out actualCount);

		    if (result != .OK)
		        return result;

		    if (actualCount > capacity) // More items added since we queried just now?
		        actualCount = capacity;

		    array = new .[actualCount];

		    for (int32 i = 0; i < actualCount; ++i)
		        array[i].handle = rawArray[i];

		    return .OK;
		}
		public FMOD.RESULT GetBusCount(out int32 count) =>
			FMOD_Studio_Bank_GetBusCount(handle, out count);
		public FMOD.RESULT GetBusList(out Bus[] array)
		{
		    array = null;

		    FMOD.RESULT result;
		    int32 capacity;
		    result = FMOD_Studio_Bank_GetBusCount(handle, out capacity);

		    if (result != .OK)
		        return result;

		    if (capacity == 0)
		    {
		        array = new .[0];
		        return result;
		    }

		    void*[] rawArray = new .[capacity];
		    int32 actualCount;
		    result = FMOD_Studio_Bank_GetBusList(handle, rawArray, capacity, out actualCount);

		    if (result != .OK)
		        return result;

		    if (actualCount > capacity) // More items added since we queried just now?
		        actualCount = capacity;

		    array = new .[actualCount];

		    for (int32 i = 0; i < actualCount; ++i)
		        array[i].handle = rawArray[i];

		    return .OK;
		}
		public FMOD.RESULT GetVCACount(out int32 count) =>
			FMOD_Studio_Bank_GetVCACount(handle, out count);
		public FMOD.RESULT GetVCAList(out VCA[] array)
		{
		    array = null;

		    FMOD.RESULT result;
		    int32 capacity;
		    result = FMOD_Studio_Bank_GetVCACount(handle, out capacity);

		    if (result != .OK)
		        return result;

		    if (capacity == 0)
		    {
		        array = new .[0];
		        return result;
		    }

		    void*[] rawArray = new .[capacity];
		    int32 actualCount;
		    result = FMOD_Studio_Bank_GetVCAList(handle, rawArray, capacity, out actualCount);

		    if (result != .OK)
		        return result;

		    if (actualCount > capacity) // More items added since we queried just now?
		        actualCount = capacity;

		    array = new .[actualCount];

		    for (int32 i = 0; i < actualCount; ++i)
		        array[i].handle = rawArray[i];

		    return .OK;
		}

		public FMOD.RESULT GetUserData(out void* userdata) =>
			FMOD_Studio_Bank_GetUserData(handle, out userdata);
		public FMOD.RESULT SetUserData(void* userdata) =>
			FMOD_Studio_Bank_SetUserData(handle, userdata);

		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern bool FMOD_Studio_Bank_IsValid(void* bank);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetID(void* bank, out FMOD.GUID id);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetPath(void* bank, char8* path, int32 size, out int32 retrieved);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_Unload(void* bank);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_LoadSampleData(void* bank);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_UnloadSampleData(void* bank);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetLoadingState(void* bank, out LOADING_STATE state);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetSampleLoadingState(void* bank, out LOADING_STATE state);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetStringCount(void* bank, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetStringInfo(void* bank, int32 index, out FMOD.GUID id, char8* path, int32 size, out int32 retrieved);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetEventCount(void* bank, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetEventList(void* bank, void*[] array, int32 capacity, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetBusCount(void* bank, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetBusList(void* bank, void*[] array, int32 capacity, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetVCACount(void* bank, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetVCAList(void* bank, void*[] array, int32 capacity, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_GetUserData(void* bank, out void* userdata);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_Bank_SetUserData(void* bank, void* userdata);
	}

	/*
	    Command playback information
	*/
	public struct CommandReplay
	{
		public void* handle;

		public this(void* ptr) { handle = ptr; }
		public bool HasHandle() => handle != null;
		public void ClearHandle() mut { handle = null; }
		public bool IsValid() => HasHandle() && FMOD_Studio_CommandReplay_IsValid(handle);

		// Information query
		public FMOD.RESULT GetSystem(out System system) =>
			FMOD_Studio_CommandReplay_GetSystem(handle, out system.handle);
		public FMOD.RESULT GetLength(out float length) =>
			FMOD_Studio_CommandReplay_GetLength(handle, out length);
		public FMOD.RESULT GetCommandCount(out int32 count) =>
			FMOD_Studio_CommandReplay_GetCommandCount(handle, out count);
		public FMOD.RESULT GetCommandInfo(int32 commandIndex, out COMMAND_INFO info) =>
			FMOD_Studio_CommandReplay_GetCommandInfo(handle, commandIndex, out info);
		public FMOD.RESULT GetCommandString(int32 commandIndex, String outBuffer)
		{
		    outBuffer.Clear();
	        int32 stringLength = 256;
	        char8* stringMem = new char8[256]*;
	        FMOD.RESULT result = FMOD_Studio_CommandReplay_GetCommandString(handle, commandIndex, stringMem, stringLength);

	        while (result == .ERR_TRUNCATED)
	        {
	            delete stringMem;
	            stringLength *= 2;
	            stringMem = new char8[stringLength]*;
	            result = FMOD_Studio_CommandReplay_GetCommandString(handle, commandIndex, stringMem, stringLength);
	        }

	        if (result == .OK)
	            outBuffer.Append(stringMem);

	        delete stringMem;
	        return result;
		}
		public FMOD.RESULT GetCommandAtTime(float time, out int32 commandIndex) =>
			FMOD_Studio_CommandReplay_GetCommandAtTime(handle, time, out commandIndex);
		// Playback
		public FMOD.RESULT SetBankPath(StringView bankPath) =>
			FMOD_Studio_CommandReplay_SetBankPath(handle, bankPath.ToScopeCStr!());
		public FMOD.RESULT Start() =>
			FMOD_Studio_CommandReplay_Start(handle);
		public FMOD.RESULT Stop() =>
			FMOD_Studio_CommandReplay_Stop(handle);
		public FMOD.RESULT SeekToTime(float time) =>
			FMOD_Studio_CommandReplay_SeekToTime(handle, time);
		public FMOD.RESULT SeekToCommand(int32 commandIndex) =>
			FMOD_Studio_CommandReplay_SeekToCommand(handle, commandIndex);
		public FMOD.RESULT GetPaused(out bool paused) =>
			FMOD_Studio_CommandReplay_GetPaused(handle, out paused);
		public FMOD.RESULT SetPaused(bool paused) =>
			FMOD_Studio_CommandReplay_SetPaused(handle, paused);
		public FMOD.RESULT GetPlaybackState(out PLAYBACK_STATE state) =>
			FMOD_Studio_CommandReplay_GetPlaybackState(handle, out state);
		public FMOD.RESULT GetCurrentCommand(out int32 commandIndex, out float currentTime) =>
			FMOD_Studio_CommandReplay_GetCurrentCommand(handle, out commandIndex, out currentTime);
		// Release
		public FMOD.RESULT Release() =>
			FMOD_Studio_CommandReplay_Release(handle);
		// Callbacks
		public FMOD.RESULT SetFrameCallback(COMMANDREPLAY_FRAME_CALLBACK callback) =>
			FMOD_Studio_CommandReplay_SetFrameCallback(handle, callback);
		public FMOD.RESULT SetLoadBankCallback(COMMANDREPLAY_LOAD_BANK_CALLBACK callback) =>
			FMOD_Studio_CommandReplay_SetLoadBankCallback(handle, callback);
		public FMOD.RESULT SetCreateInstanceCallback(COMMANDREPLAY_CREATE_INSTANCE_CALLBACK callback) =>
			FMOD_Studio_CommandReplay_SetCreateInstanceCallback(handle, callback);
		public FMOD.RESULT GetUserData(out void* userdata) =>
			FMOD_Studio_CommandReplay_GetUserData(handle, out userdata);
		public FMOD.RESULT SetUserData(void* userdata) =>
			FMOD_Studio_CommandReplay_SetUserData(handle, userdata);

		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern bool FMOD_Studio_CommandReplay_IsValid(void* replay);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_GetSystem(void* replay, out void* system);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_GetLength(void* replay, out float length);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_GetCommandCount(void* replay, out int32 count);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_GetCommandInfo(void* replay, int32 commandindex, out COMMAND_INFO info);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_GetCommandString(void* replay, int32 commandindex, char8* buffer, int32 length);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_GetCommandAtTime(void* replay, float time, out int32 commandindex);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_SetBankPath(void* replay, [MangleConst]char8* bankPath);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_Start(void* replay);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_Stop(void* replay);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_SeekToTime(void* replay, float time);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_SeekToCommand(void* replay, int32 commandindex);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_GetPaused(void* replay, out bool paused);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_SetPaused(void* replay, bool paused);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_GetPlaybackState(void* replay, out PLAYBACK_STATE state);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_GetCurrentCommand(void* replay, out int32 commandindex, out float currentTime);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_Release(void* replay);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_SetFrameCallback(void* replay, COMMANDREPLAY_FRAME_CALLBACK callback);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_SetLoadBankCallback(void* replay, COMMANDREPLAY_LOAD_BANK_CALLBACK callback);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_SetCreateInstanceCallback(void* replay, COMMANDREPLAY_CREATE_INSTANCE_CALLBACK callback);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_GetUserData(void* replay, out void* userdata);
		[Import(STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
		private static extern FMOD.RESULT FMOD_Studio_CommandReplay_SetUserData(void* replay, void* userdata);
	}
}
