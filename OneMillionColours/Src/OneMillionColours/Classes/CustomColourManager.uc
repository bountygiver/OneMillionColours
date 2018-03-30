class CustomColourManager extends Object config(Game);

var config int START_INDEX;
var config int NUM_COLOR_PER_BASE;

var config int START_INDEX_HAIR;
var config int START_INDEX_EYES;
var config int START_INDEX_SKIN;
var config int START_INDEX_FONT;

var config array<XComLinearColorPaletteEntry> DefaultOneMilCol;

public static function int GetColStartIndex(EColorPalette CurrentColorSelection)
{
	switch(CurrentColorSelection)
	{
		case ePalette_CaucasianSkin:	
		case ePalette_AsianSkin:	
		case ePalette_AfricanSkin:	
		case ePalette_HispanicSkin:	
			return default.START_INDEX_SKIN;
		case ePalette_HairColor:	
			return default.START_INDEX_HAIR;
		case ePalette_EyeColor:	
			return default.START_INDEX_EYES;
		case ePalette_ArmorTint:
			return default.START_INDEX;
		case 10:
			return default.START_INDEX_FONT;
		default:
			break;
	}
	return 0;
}

public static function string GetHexOfSlider(EColorPalette paletteType, float r, float g, float b, optional float Brightness = class'XComCharacterCustomization'.default.UIColorBrightnessAdjust)
{
	local XComLinearColorPalette Palette;
	local int idx;

	idx = GetColourIndexSlider(GetColStartIndex(paletteType), r, g, b);

	Palette = `CONTENT.GetColorPalette(paletteType);
	if (idx < Palette.Entries.Length)
	{
		return class'UIUtilities_Colors'.static.LinearColorToFlashHex( Palette.Entries[idx].Primary, Brightness );
	}
	else
	{
		idx = GetColourIndexSlider(0, r, g, b);
		return class'UIUtilities_Colors'.static.LinearColorToFlashHex( default.DefaultOneMilCol[idx].Primary, Brightness );
	}
}

public static function GetPercentOfIndex(EColorPalette paletteType, int idx, out float r, out float g, out float b)
{
	local XComLinearColorPalette Palette;

	Palette = `CONTENT.GetColorPalette(paletteType);
	if (idx < Palette.Entries.Length)
	{
		r = Palette.Entries[idx].Primary.R * 100.0f;
		g = Palette.Entries[idx].Primary.G * 100.0f;
		b = Palette.Entries[idx].Primary.B * 100.0f;
	}
	else
	{
		idx -= GetColStartIndex(paletteType);
		r = default.DefaultOneMilCol[idx].Primary.R * 100.0f;
		g = default.DefaultOneMilCol[idx].Primary.G * 100.0f;
		b = default.DefaultOneMilCol[idx].Primary.B * 100.0f;
	}
}

public static function int GetColourIndexSlider(int starting_index, float r, float g, float b)
{
	local int i_r, i_g, i_b;
	i_r = Clamp(FFloor(r * default.NUM_COLOR_PER_BASE / 100.0f), 0, default.NUM_COLOR_PER_BASE - 1);
	i_g = Clamp(FFloor(g * default.NUM_COLOR_PER_BASE / 100.0f), 0, default.NUM_COLOR_PER_BASE - 1);
	i_b = Clamp(FFloor(b * default.NUM_COLOR_PER_BASE / 100.0f), 0, default.NUM_COLOR_PER_BASE - 1);

	return starting_index + (i_r * (default.NUM_COLOR_PER_BASE ** 2)) + (i_g * default.NUM_COLOR_PER_BASE) + i_b;
}

public static function int GetColourIndex(int starting_index, int r, int g, int b)
{
	r = Clamp(FFloor(float(r) * default.NUM_COLOR_PER_BASE / 255.0f), 0, default.NUM_COLOR_PER_BASE - 1);
	g = Clamp(FFloor(float(g) * default.NUM_COLOR_PER_BASE / 255.0f), 0, default.NUM_COLOR_PER_BASE - 1);
	b = Clamp(FFloor(float(b) * default.NUM_COLOR_PER_BASE / 255.0f), 0, default.NUM_COLOR_PER_BASE - 1);

	return starting_index + (r * (default.NUM_COLOR_PER_BASE ** 2)) + (g * default.NUM_COLOR_PER_BASE) + b;
}

public static function InitColours(int starting_index, out array<XComLinearColorPaletteEntry> Col, optional bool BlackSecondary = false)
{
	local int i_r, i_g, i_b;
	local float r, g, b;
	local int index;

	default.DefaultOneMilCol.Length = default.NUM_COLOR_PER_BASE ** 3;

	for (i_r = 0; i_r < default.NUM_COLOR_PER_BASE; i_r++)
	{
		r = float(i_r) / (default.NUM_COLOR_PER_BASE - 1);
		for (i_g = 0; i_g < default.NUM_COLOR_PER_BASE; i_g++)
		{
			g = float(i_g) / (default.NUM_COLOR_PER_BASE - 1);
			for (i_b = 0; i_b < default.NUM_COLOR_PER_BASE; i_b++)
			{
				b = float(i_b) / (default.NUM_COLOR_PER_BASE - 1);
				index = starting_index + (i_r * (default.NUM_COLOR_PER_BASE ** 2)) + (i_g * default.NUM_COLOR_PER_BASE) + i_b;
				Col[index].Primary.R = r;
				Col[index].Primary.G = g;
				Col[index].Primary.B = b;
				Col[index].Primary.A = 1;
				default.DefaultOneMilCol[index - starting_index].Primary = Col[index].Primary;
				if (BlackSecondary)
				{
					Col[index].Secondary.R = 0;
					Col[index].Secondary.G = 0;
					Col[index].Secondary.B = 0;
				}
				else
				{
					Col[index].Secondary.R = r;
					Col[index].Secondary.G = g;
					Col[index].Secondary.B = b;
				}
				Col[index].Secondary.A = 1;
				//`log("Color" @ index @ ":" @ r @ g @ b,, 'OneMilCol');
			}
		}
	}
	`log("All colours patched",, 'OneMilCol');
}