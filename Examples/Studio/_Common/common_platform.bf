namespace Common;

using System;
using System.IO;

public static
{
	const int16 VK_ESCAPE = 0x1B;
	const int16 VK_SPACE  = 0x20;
	const int16 VK_LEFT   = 0x25;
	const int16 VK_UP     = 0x26;
	const int16 VK_RIGHT  = 0x27;
	const int16 VK_DOWN   = 0x28;

	/* Functions with platform specific implementation (common_platform) */
	static void OnCancel(Console.CancelKind kind, ref bool term)
	{
		gQuit = true;
	}

	public static void Common_Start()
	{
		Environment.GetExecutableFilePath(AppExeFull);
		Path.GetFileName(AppExeFull, AppExe);
		Path.GetDirectoryPath(AppExeFull, AppExeDir);

		Console.OnCancel.AddFront(new => OnCancel);
	}

	public static void Common_Close()
	{
		if (Common_Private_Close != null)
		    Common_Private_Close();
	}

	public static void Common_Update()
	{
		uint32 newButtons = getButtonState();
		newButtons |= (gQuit ? (1 << Common_Button.BTN_QUIT.Underlying) : 0);
		gPressedButtons = (gDownButtons ^ newButtons) & newButtons;
		gDownButtons = newButtons;

		Internal.MemCpy(&gDisplayBuffer[0], &gWriteBuffer[0], BUFFER_SIZE);
		Console.Clear();

		gYPos = 0;
		Internal.MemSet(&gWriteBuffer[0], (uint8)' ', BUFFER_SIZE);

		for (int i = 0; i < NUM_ROWS; i++)
			gWriteBuffer[(i * (NUM_COLUMNS + 1)) + NUM_COLUMNS] = '\n';

		String outStr = new .();
		outStr.Append(gDisplayBuffer);
		Console.Write(outStr);
		delete outStr;

	    if (Common_Private_Update != null)
	        Common_Private_Update(&gPressedButtons);
	}

	public static void Common_DrawText(StringView text)
	{
		if (gYPos < NUM_ROWS)
		{
			Internal.MemCpy(&gWriteBuffer[gYPos * (NUM_COLUMNS + 1)], text.Ptr, text.Length);
        	gYPos++;
		}
	}

	public static bool Common_BtnDown(Common_Button btn) =>
		((gDownButtons & (1 << btn.Underlying)) != 0);

	public static void Common_BtnStr(Common_Button btn, String outStr)
	{
	    switch (btn)
	    {
	        case .BTN_ACTION1:  outStr.Set("1");
	        case .BTN_ACTION2:  outStr.Set("2");
	        case .BTN_ACTION3:  outStr.Set("3");
	        case .BTN_ACTION4:  outStr.Set("4");
	        case .BTN_LEFT:     outStr.Set("Left");
	        case .BTN_RIGHT:    outStr.Set("Right");
	        case .BTN_UP:       outStr.Set("Up");
	        case .BTN_DOWN:     outStr.Set("Down");
	        case .BTN_MORE:     outStr.Set("Space");
	        case .BTN_QUIT:     outStr.Set("Escape");
	        default:            outStr.Set("Unknown");
	    }
	}

	public static void Common_MediaPath(StringView fileName, String outFilePath)
	{
		outFilePath.Clear();

		if (File.Exists(fileName))
			outFilePath.Append(fileName);
		else
			outFilePath.AppendF("{0}/media/{1}", AppExeDir, fileName);

		gPathList.Add(new .(outFilePath));
	}

	public static void Common_WritePath(StringView fileName, String outStr) =>
		Common_MediaPath(fileName, outStr);

	static uint32 getButtonState()
	{
	    uint32 buttons = 0;

	    if (GetAsyncKeyState((int32)'1') & 0x8000 > 0) buttons |= (1 << Common_Button.BTN_ACTION1.Underlying);
	    if (GetAsyncKeyState((int32)'2') & 0x8000 > 0) buttons |= (1 << Common_Button.BTN_ACTION2.Underlying);
	    if (GetAsyncKeyState((int32)'3') & 0x8000 > 0) buttons |= (1 << Common_Button.BTN_ACTION3.Underlying);
	    if (GetAsyncKeyState((int32)'4') & 0x8000 > 0) buttons |= (1 << Common_Button.BTN_ACTION4.Underlying);
	    if (GetAsyncKeyState(VK_LEFT)    & 0x8000 > 0) buttons |= (1 << Common_Button.BTN_LEFT.Underlying);
	    if (GetAsyncKeyState(VK_RIGHT)   & 0x8000 > 0) buttons |= (1 << Common_Button.BTN_RIGHT.Underlying);
	    if (GetAsyncKeyState(VK_UP)      & 0x8000 > 0) buttons |= (1 << Common_Button.BTN_UP.Underlying);
	    if (GetAsyncKeyState(VK_DOWN)    & 0x8000 > 0) buttons |= (1 << Common_Button.BTN_DOWN.Underlying);
	    if (GetAsyncKeyState(VK_SPACE)   & 0x8000 > 0) buttons |= (1 << Common_Button.BTN_MORE.Underlying);
	    if (GetAsyncKeyState(VK_ESCAPE)  & 0x8000 > 0) buttons |= (1 << Common_Button.BTN_QUIT.Underlying);

	    return buttons;
	}

	[CLink, CallingConvention(.Stdcall)]
	static extern int16 GetAsyncKeyState(int32 vKey);
}
