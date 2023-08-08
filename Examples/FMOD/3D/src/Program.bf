namespace _3D;

using Beef_FMOD;
using Common;
using System;

static class Program
{
	const int32 INTERFACE_UPDATETIME = 50;   // 50ms update for interface
	const float DISTANCEFACTOR       = 1.0f; // Units per meter.  I.e feet would = 3.28.  centimeters would = 100.

	public static int Main(String[] Args)
	{
		Common_Start();

		FMOD.ChannelGroup channelGroupNull = .(null);
		FMOD.Channel channel1              = .(null), channel2 = .(null), channel3 = .(null);
		bool listenerFlag                  = true;
		FMOD.VECTOR listenerPos            = .{
			X = 0.0f,
			Y = 0.0f,
			Z = -1.0f * DISTANCEFACTOR
		};
		void* extraDriverData              = null;
		
		/*
		    Create a System object and initialize.
		*/
		FMOD.System system = .(null);
		ERRCHECK!(FMOD.Factory.System_Create(out system));
		ERRCHECK!(system.Init(100, .NORMAL, extraDriverData));

	    /*
	        Set the distance units. (meters/feet etc).
	    */
		ERRCHECK!(system.Set3DSettings(1.0f, DISTANCEFACTOR, 1.0f));

		/*
		    Load some sounds
		*/
		String drumloopFile = scope .();
		Common_MediaPath("drumloop.wav", drumloopFile);
		drumloopFile.EnsureNullTerminator();
		FMOD.Sound sound1 = .(null);
		ERRCHECK!(system.CreateSound(drumloopFile, ._3D, out sound1));
		ERRCHECK!(sound1.Set3DMinMaxDistance(0.5f * DISTANCEFACTOR, 5000.0f * DISTANCEFACTOR));
		ERRCHECK!(sound1.SetMode(.LOOP_NORMAL));

		String jaguarFile = scope .();
		Common_MediaPath("jaguar.wav", jaguarFile);
		jaguarFile.EnsureNullTerminator();
		FMOD.Sound sound2 = .(null);
		ERRCHECK!(system.CreateSound(jaguarFile, ._3D, out sound2));
		ERRCHECK!(sound2.Set3DMinMaxDistance(0.5f * DISTANCEFACTOR, 5000.0f * DISTANCEFACTOR));
		ERRCHECK!(sound2.SetMode(.LOOP_NORMAL));

		String swishFile = scope .();
		Common_MediaPath("swish.wav", swishFile);
		swishFile.EnsureNullTerminator();
		FMOD.Sound sound3 = .(null);
		ERRCHECK!(system.CreateSound(swishFile, ._3D, out sound3));

		/*
		    Play sounds at certain positions
		*/
		{
			FMOD.VECTOR pos = .{
				X = -10.0f * DISTANCEFACTOR,
				Y = 0.0f,
				Z = 0.0f
			};
			FMOD.VECTOR vel = .{
				X = 0.0f,
				Y = 0.0f,
				Z = 0.0f
			};

			ERRCHECK!(system.PlaySound(sound1, channelGroupNull, true, out channel1));
			ERRCHECK!(channel1.Set3DAttributes(ref pos, ref vel));
			ERRCHECK!(channel1.SetPaused(false));
		}

		{
			FMOD.VECTOR pos = .{
				X = 15.0f * DISTANCEFACTOR,
				Y = 0.0f,
				Z = 0.0f
			};
			FMOD.VECTOR vel = .{
				X = 0.0f,
				Y = 0.0f,
				Z = 0.0f
			};

			ERRCHECK!(system.PlaySound(sound2, channelGroupNull, true, out channel2));
			ERRCHECK!(channel2.Set3DAttributes(ref pos, ref vel));
			ERRCHECK!(channel2.SetPaused(false));
		}

		String btnLeftText = scope .();
		Common_BtnStr(.BTN_LEFT, btnLeftText);
		String btnRightText = scope .();
		Common_BtnStr(.BTN_RIGHT, btnRightText);
		String btnQuitText = scope .();
		Common_BtnStr(.BTN_QUIT, btnQuitText);
		String btnMoreText = scope .();
		Common_BtnStr(.BTN_MORE, btnMoreText);
		String btnAct1Text = scope .();
		Common_BtnStr(.BTN_ACTION1, btnAct1Text);
		String btnAct2Text = scope .();
		Common_BtnStr(.BTN_ACTION2, btnAct2Text);
		String btnAct3Text = scope .();
		Common_BtnStr(.BTN_ACTION3, btnAct3Text);

		float time          = 0.0f;
		FMOD.VECTOR lastPos = .{
			X = 0.0f,
			Y = 0.0f,
			Z = 0.0f
		};

		/*
		    Main loop
		*/
		repeat
		{
        	Common_Update();

			if (Common_BtnDown(.BTN_ACTION1))
			{
			    channel1.GetPaused(var paused);
			    channel1.SetPaused(!paused);
			}

			if (Common_BtnDown(.BTN_ACTION2))
			{
			    channel2.GetPaused(var paused);
			    channel2.SetPaused(!paused);
			}

			if (Common_BtnDown(.BTN_ACTION3))
			    ERRCHECK!(system.PlaySound(sound3, channelGroupNull, false, out channel3));

			if (Common_BtnDown(.BTN_MORE))
			    listenerFlag = !listenerFlag;

			if (!listenerFlag)
			{
			    if (Common_BtnDown(.BTN_LEFT))
			    {
			        listenerPos.X -= 1.0f * DISTANCEFACTOR;

			        if (listenerPos.X < -24 * DISTANCEFACTOR)
			            listenerPos.X = -24 * DISTANCEFACTOR;
			    }

			    if (Common_BtnDown(.BTN_RIGHT))
			    {
			        listenerPos.X += 1.0f * DISTANCEFACTOR;

			        if (listenerPos.X > 23 * DISTANCEFACTOR)
			            listenerPos.X = 23 * DISTANCEFACTOR;
			    }
			}

			// ==========================================================================================
			// UPDATE THE LISTENER
			// ==========================================================================================
			{
				FMOD.VECTOR forward = .{ X = 0.0f, Y = 0.0f, Z = 1.0f };
				FMOD.VECTOR up      = .{ X = 0.0f, Y = 1.0f, Z = 0.0f };
				FMOD.VECTOR vel     = .();

				if (listenerFlag)
					listenerPos.X = (float)Math.Sin(time * 0.05f) * 24.0f * DISTANCEFACTOR; // left right ping-pong

				// ********* NOTE ******* READ NEXT COMMENT!!!!!
				// vel = how far we moved last FRAME (m/f), then time compensate it to SECONDS (m/s).
				vel.X = (listenerPos.X - lastPos.X) * (1000 / INTERFACE_UPDATETIME);
				vel.Y = (listenerPos.Y - lastPos.Y) * (1000 / INTERFACE_UPDATETIME);
				vel.Z = (listenerPos.Z - lastPos.Z) * (1000 / INTERFACE_UPDATETIME);

				// store pos for next time
				lastPos = listenerPos;

				ERRCHECK!(system.Set3DListenerAttributes(0, ref listenerPos, ref vel, ref forward, ref up));

				time += (30 * (1.0f / (float)INTERFACE_UPDATETIME)); // time increments in 30m/s steps in this example
			}

			ERRCHECK!(system.Update());

			// Create small visual delay
			String s = scope .("|.............<1>......................<2>.......|");
			s[(int32)(listenerPos.X / DISTANCEFACTOR) + 25] = 'L';

			Common_Draw("==================================================");
			Common_Draw("3D Example.");
			Common_Draw("Copyright (c) Firelight Technologies 2004-2023.");
			Common_Draw("==================================================");
			Common_Draw("");
			Common_Draw("Press {0} to toggle sound 1 (16bit Mono 3D)", btnAct1Text);
			Common_Draw("Press {0} to toggle sound 2 (8bit Mono 3D)", btnAct2Text);
			Common_Draw("Press {0} to play a sound (16bit Stereo 2D)", btnAct3Text);
			Common_Draw("Press {0} or {1} to move listener in still mode", btnLeftText, btnRightText);
			Common_Draw("Press {0} to toggle listener auto movement", btnMoreText);
			Common_Draw("Press {0} to quit", btnQuitText);
			Common_Draw("");
			Common_Draw(s);

			Common_Sleep(INTERFACE_UPDATETIME - 1);
		} while (!Common_BtnDown(.BTN_QUIT));


		/*
			Shutdown and cleanup
		*/
		ERRCHECK!(sound1.Release());
		ERRCHECK!(sound2.Release());
		ERRCHECK!(sound3.Release());
		ERRCHECK!(system.Close());
		ERRCHECK!(system.Release());
		Common_Close();
		return 0;
	}
}