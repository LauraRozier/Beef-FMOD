namespace Common;

using System;
using System.Collections;
using Beef_FMOD;

public static
{
	public static readonly String AppExeFull = new .() ~ delete _;
	public static readonly String AppExe = new .() ~ delete _;
	public static readonly String AppExeDir = new .() ~ delete _;

	public const uint32 NUM_COLUMNS = 50;
	public const uint32 NUM_ROWS = 25;
	public const uint32 BUFFER_SIZE = (NUM_COLUMNS + 1) * NUM_ROWS;

	public struct FMOD_OS_FILE {}
	public struct FMOD_OS_CRITICALSECTION {}

	public static int32 gScreenWidth = 0;
	public static int32 gScreenHeight = 0;
	public static uint32 gPressedButtons = 0;
	public static uint32 gDownButtons = 0;
	public static char8[BUFFER_SIZE + 1] gWriteBuffer = .();
	public static char8[BUFFER_SIZE + 1] gDisplayBuffer = .();
	public static uint32 gYPos = 0;
	public static bool gQuit = false;
	public static List<String> gPathList = new .() ~ DeleteContainerAndItems!(_);
	
	public static bool Common_Private_Test;
	public static String[] Common_Private_Arg = null;
	public static function void(uint32*) Common_Private_Update = null;
	public static function void(StringView) Common_Private_Print = null;
	public static function void() Common_Private_Close = null;
	public static function void(FMOD.RESULT, StringView, int) Common_Private_Error = null;

	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_Debug_Output([MangleConst]char8* format, ...);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_File_Open([MangleConst]char8* name, uint32 mode, out uint32 filesize, out FMOD_OS_FILE* handle);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_File_Close(FMOD_OS_FILE* handle);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_File_Read(FMOD_OS_FILE* handle, void* buf, uint32 count, out uint32 read);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_File_Write(FMOD_OS_FILE* handle, [MangleConst]void* buffer, uint32 bytesToWrite, bool flush);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_File_Seek(FMOD_OS_FILE* handle, uint32 offset);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_Time_Sleep(uint32 ms);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_CriticalSection_Create(out void* crit, bool memorycrit);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_CriticalSection_Free(void* crit, bool memorycrit);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_CriticalSection_Enter(void* crit);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_CriticalSection_Leave(void* crit);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_CriticalSection_TryEnter(void* crit, out bool entered);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_CriticalSection_IsLocked(void* crit, out bool locked);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_Thread_Create([MangleConst]char8* name, function void(void* param) callback, void* param, FMOD.THREAD_AFFINITY affinity, FMOD.THREAD_PRIORITY priority, FMOD.THREAD_STACK_SIZE stacksize, out void* handle);
	[Import(FMOD_STUDIO.STUDIO_VERSION.DLL), CLink, CallingConvention(.Stdcall)]
	private static extern FMOD.RESULT FMOD_OS_Thread_Destroy(void* handle);

	public static mixin ERRCHECK(FMOD.RESULT result)
	{
		ERRCHECK(result, Compiler.CallerFileName, Compiler.CallerLineNum);
	}

	private static void ERRCHECK(FMOD.RESULT result, StringView file, int line)
	{
		if (result == .OK)
			return;

		if (Common_Private_Error != null)
			Common_Private_Error(result, file, line);

		String str = scope .();
		FMOD_ErrorString(result, str);
		Common_Fatal("{0}({1}): FMOD error {2} - {3}", file, line, result, str);
	}

	/* Cross platform functions (common) */
	[NoReturn]
	public static void Common_Fatal(StringView format, params Span<Object> args)
	{
		String error = scope .();
		error.AppendF(format, params args);

		String quitBtn = scope .();
		Common_BtnStr(.BTN_QUIT, quitBtn);

		repeat
		{
		    Common_Draw("A fatal error has occurred...");
		    Common_Draw("");
		    Common_Draw(error);
		    Common_Draw("");
		    Common_Draw("Press {0} to quit", quitBtn);

		    Common_Update();
		    Common_Sleep(50);
		} while (!Common_BtnDown(.BTN_QUIT));

		Internal.FatalError(error, 3);
	}

	public static void Common_Draw(StringView format, params Span<Object> args)
	{
		String string = new .();
		string.AppendF(format, params args);

		repeat
		{
			bool consumeNewLine = false;
			int copyLength = string.Length;

			// Search for new line characters
			int newline = string.IndexOf('\n');

			if (newline > -1)
			{
				consumeNewLine = true;
				copyLength = newline;
			}

			if (copyLength > NUM_COLUMNS)
			{
				// Hard wrap by default
				copyLength = NUM_COLUMNS;

				// Loop for a soft wrap
				for (int i = NUM_COLUMNS - 1; i >= 0; i--)
				{
				    if (string[i] == ' ')
				    {
				        copyLength = i + 1;
				        break;
				    }
				}
			}

			StringView tmp = string.Substring(0, copyLength);
			Common_DrawText(tmp);

			copyLength += (consumeNewLine ? 1 : 0);
			string.Remove(0, Math.Min(string.Length, copyLength));
		} while (string.Length > 0);

		delete string;
	}

	public static void Common_Log(StringView format, params Span<Object> args)
	{
		String tmp = scope .();
		tmp.AppendF(format, params args);
		FMOD_OS_Debug_Output(tmp.CStr());
	}

	public static void Common_LoadFileMemory(StringView name, void** buff, int32* length)
	{
		FMOD_OS_FILE* file = null;
		uint32 len, bytesread;

		FMOD_OS_File_Open(name.Ptr, 0, out len, out file);
		void* mem = Internal.Malloc(len);
		FMOD_OS_File_Read(file, mem, len, out bytesread);
		FMOD_OS_File_Close(file);

		*buff = mem;
		*length = (int32)bytesread;
	}

	public static void Common_UnloadFileMemory(void* buff) =>
		Internal.Free(buff);

	public static void Common_Sleep(uint32 ms) =>
		FMOD_OS_Time_Sleep(ms);

	public static void Common_File_Open(StringView name, uint32 mode, out uint32 filesize, out void* handle) // mode : 0 = read, 1 = write.
	{
		FMOD_OS_File_Open(name.Ptr, mode, out filesize, var handlePtr);
		handle = handlePtr;
	}
	public static void Common_File_Close(void* handle) =>
		FMOD_OS_File_Close((FMOD_OS_FILE*)handle);
	public static void Common_File_Read(void* handle, void* buf, uint32 length, out uint32 read) =>
		FMOD_OS_File_Read((FMOD_OS_FILE*)handle, buf, length, out read);
	public static void Common_File_Write(void* handle, void* buf, uint32 length) =>
    	FMOD_OS_File_Write((FMOD_OS_FILE*)handle, buf, length, true);
	public static void Common_File_Seek(void* handle, uint32 offset) =>
    	FMOD_OS_File_Seek((FMOD_OS_FILE*)handle, offset);

	public static void Common_Mutex_Create(ref Common_Mutex mutex) =>
    	FMOD_OS_CriticalSection_Create(out mutex.crit, false);
	public static void Common_Mutex_Destroy(Common_Mutex mutex) =>
    	FMOD_OS_CriticalSection_Free(mutex.crit, false);
	public static void Common_Mutex_Enter(Common_Mutex mutex) =>
    	FMOD_OS_CriticalSection_Enter(mutex.crit);
	public static void Common_Mutex_Leave(Common_Mutex mutex) =>
    	FMOD_OS_CriticalSection_Leave(mutex.crit);

	public static void Common_Thread_Create(function void(void* param) callback, void* param, out void* handle) =>
    	FMOD_OS_Thread_Create("FMOD Example Thread", callback, param, .GROUP_A, .MEDIUM, .FEEDER, out handle);
	public static void Common_Thread_Destroy(void* handle) =>
    	FMOD_OS_Thread_Destroy(handle);
}

public enum Common_Button : uint32
{
    BTN_ACTION1,
    BTN_ACTION2,
    BTN_ACTION3,
    BTN_ACTION4,
    BTN_LEFT,
    BTN_RIGHT,
    BTN_UP,
    BTN_DOWN,
    BTN_MORE,
    BTN_QUIT
}

public struct Common_Mutex
{
    public void* crit;
}
