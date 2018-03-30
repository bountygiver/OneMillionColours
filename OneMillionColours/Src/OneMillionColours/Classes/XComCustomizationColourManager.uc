class XComCustomizationColourManager extends XComCharacterCustomization;

var EColorPalette CurrentColorSelection;

simulated function array<string> GetColorList( int catType )
{
	local XComLinearColorPalette Palette;
	local array<string> Colors; 
	local int i; 

	switch (catType)
	{
	case eUICustomizeCat_Skin:	
		Palette = `CONTENT.GetColorPalette(XComHumanPawn(ActorPawn).HeadContent.SkinPalette);
		CurrentColorSelection = XComHumanPawn(ActorPawn).HeadContent.SkinPalette;
		for( i = 0; i < Palette.Entries.length && i < class'CustomColourManager'.default.START_INDEX_SKIN; i++ )
		{
			Colors.AddItem( class'UIUtilities_Colors'.static.LinearColorToFlashHex( Palette.Entries[i].Primary, UIColorBrightnessAdjust ) );
		}
		break;
	case eUICustomizeCat_HairColor:	
		Palette = `CONTENT.GetColorPalette(ePalette_HairColor);
		CurrentColorSelection = ePalette_HairColor;
		for( i = 0; i < Palette.Entries.length && i < class'CustomColourManager'.default.START_INDEX_HAIR; i++ )
		{
			Colors.AddItem( class'UIUtilities_Colors'.static.LinearColorToFlashHex( Palette.Entries[i].Primary, UIColorBrightnessAdjust ) );
		}
		break;
	case eUICustomizeCat_EyeColor:	
		Palette = `CONTENT.GetColorPalette(ePalette_EyeColor);
		CurrentColorSelection = ePalette_EyeColor;
		for( i = 0; i < Palette.Entries.length && i < class'CustomColourManager'.default.START_INDEX_EYES; i++ )
		{
			Colors.AddItem( class'UIUtilities_Colors'.static.LinearColorToFlashHex( Palette.Entries[i].Primary, UIColorBrightnessAdjust ) );
		}
		break;
	case eUICustomizeCat_SecondaryArmorColor:
		Palette = `CONTENT.GetColorPalette(ePalette_ArmorTint);
		CurrentColorSelection = ePalette_ArmorTint;
		for(i = 0; i < Palette.Entries.length && i < class'CustomColourManager'.default.START_INDEX; i++)
		{
			Colors.AddItem(class'UIUtilities_Colors'.static.LinearColorToFlashHex(Palette.Entries[i].Secondary, UIColorBrightnessAdjust));
		}
		break;
	case eUICustomizeCat_PrimaryArmorColor:
	case eUICustomizeCat_WeaponColor:
	case eUICustomizeCat_TattooColor:
		Palette = `CONTENT.GetColorPalette(ePalette_ArmorTint);
		CurrentColorSelection = ePalette_ArmorTint;
		for(i = 0; i < Palette.Entries.length && i < class'CustomColourManager'.default.START_INDEX; i++)
		{
			Colors.AddItem(class'UIUtilities_Colors'.static.LinearColorToFlashHex(Palette.Entries[i].Primary, UIColorBrightnessAdjust));
		}
		break;
	case 20:
		Palette = `CONTENT.GetColorPalette(10);
		CurrentColorSelection = 10;
		for(i = 0; i < Palette.Entries.length && i < class'CustomColourManager'.default.START_INDEX_FONT; i++)
		{
			Colors.AddItem(class'UIUtilities_Colors'.static.LinearColorToFlashHex(Palette.Entries[i].Primary, UIColorBrightnessAdjust));
		}
		break;
	default:
		CurrentColorSelection = ePalette_ShirtColor;
		break;
	}
	//`log("Returning colour list. Length:" @ Colors.Length,, 'OneMilCol');
	return Colors;
}

function int GetColStartIndex()
{
	switch(CurrentColorSelection)
	{
		case ePalette_CaucasianSkin:	
		case ePalette_AsianSkin:	
		case ePalette_AfricanSkin:	
		case ePalette_HispanicSkin:	
			return class'CustomColourManager'.default.START_INDEX_SKIN;
		case ePalette_HairColor:	
			return class'CustomColourManager'.default.START_INDEX_HAIR;
		case ePalette_EyeColor:	
			return class'CustomColourManager'.default.START_INDEX_EYES;
		case ePalette_ArmorTint:
			return class'CustomColourManager'.default.START_INDEX;
		case 10:
			return class'CustomColourManager'.default.START_INDEX_FONT;
		default:
			break;
	}
	return 0;
}

defaultproperties
{
	CurrentColorSelection=ePalette_ShirtColor;
}