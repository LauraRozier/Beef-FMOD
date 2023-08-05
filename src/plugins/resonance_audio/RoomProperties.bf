// Copyright 2017 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS-IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
namespace Beef_FMOD.vraudio;

using System;

/// Room surface material names, used to set room properties.
/// Note that this enum is C-compatible by design to be used across external C/C++ and C# implementations.
[CRepr]
public enum MaterialName
{
	kTransparent = 0,
	kAcousticCeilingTiles,
	kBrickBare,
	kBrickPainted,
	kConcreteBlockCoarse,
	kConcreteBlockPainted,
	kCurtainHeavy,
	kFiberGlassInsulation,
	kGlassThin,
	kGlassThick,
	kGrass,
	kLinoleumOnConcrete,
	kMarble,
	kMetal,
	kParquetOnConcrete,
	kPlasterRough,
	kPlasterSmooth,
	kPlywoodPanel,
	kPolishedConcreteOrTile,
	kSheetrock,
	kWaterOrIceSurface,
	kWoodCeiling,
	kWoodPanel,
	kUniform,
	kNumMaterialNames
}

/// Acoustic room properties.  This struct can be used to describe an acoustic environment with a given geometry and surface properties.
/// Note that this struct is C-compatible by design to be used across external C/C++ and C# implementations.
[CRepr]
public struct RoomProperties
{
	/// Center position of the room in world space, uses right-handed coordinate system.
	public float[3] position = .(0.0f, 0.0f, 0.0f);
	
	/// Rotation (quaternion) of the room in world space, uses right-handed coordinate system.
	public float[4] rotation = .(0.0f, 0.0f, 0.0f, 1.0f);
	
	/// Size of the shoebox room in world space, uses right-handed coordinate system.
	public float[3] dimensions = .(0.0f, 0.0f, 0.0f);
	
	/// Material name of each surface of the shoebox room in this order:
	/// [0] (-)ive x-axis wall (left)
	/// [1] (+)ive x-axis wall (right)
	/// [2] (-)ive y-axis wall (bottom)
	/// [3] (+)ive y-axis wall (top)
	/// [4] (-)ive z-axis wall (front)
	/// [5] (+)ive z-axis wall (back)
	public MaterialName[6] material_names = .(
		.kTransparent, .kTransparent,
		.kTransparent, .kTransparent,
		.kTransparent, .kTransparent
	);
	
	/// User defined uniform scaling factor for all reflection coefficients.
	public float reflection_scalar = 1.0f;
	
	/// User defined reverb tail gain multiplier.
	public float reverb_gain = 1.0f;
	
	/// Adjusts the reverberation time across all frequency bands.  RT60 values are multiplied by this factor. Has no effect when set to 1.0f.
	public float reverb_time = 1.0f;
	
	/// Controls the slope of a line from the lowest to the highest RT60 values (increases high frequency RT60s when positive, decreases when negative).
	/// Has no effect when set to 0.0f.
	public float reverb_brightness = 0.0f;
}
