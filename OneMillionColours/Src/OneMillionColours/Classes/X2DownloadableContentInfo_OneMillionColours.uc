//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_OneMillionColours.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_OneMillionColours extends X2DownloadableContentInfo;

var config array<name> SoldierTemplates;
var config array<string> ScreenClassNames;
var config array<name> ScreenLibNames;


/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{

}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{

}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed. When a new campaign is started the initial state of the world
/// is contained in a strategy start state. Never add additional history frames inside of InstallNewCampaign, add new state objects to the start state
/// or directly modify start state objects
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{

}

/// <summary>
/// Called just before the player launches into a tactical a mission while this DLC / Mod is installed.
/// Allows dlcs/mods to modify the start state before launching into the mission
/// </summary>
static event OnPreMission(XComGameState StartGameState, XComGameState_MissionSite MissionState)
{

}

/// <summary>
/// Called when the player completes a mission while this DLC / Mod is installed.
/// </summary>
static event OnPostMission()
{

}

/// <summary>
/// Called when the player is doing a direct tactical->tactical mission transfer. Allows mods to modify the
/// start state of the new transfer mission if needed
/// </summary>
static event ModifyTacticalTransferStartState(XComGameState TransferStartState)
{

}

/// <summary>
/// Called after the player exits the post-mission sequence while this DLC / Mod is installed.
/// </summary>
static event OnExitPostMissionSequence()
{

}

static function PrintPaletteEnum()
{
	local int i;
	for (i = 0; i < 12; i++)
	{
		`log("Palette" @ i $ ":" @ GetEnum(Enum'EColorPalette', i),, 'OneMilCol');
	}
	
	for (i = 0; i < 50; i++)
	{
		`log("Customize Category" @ i $ ":" @ GetEnum(Enum'EUICustomizeCategory', i),, 'OneMilCol');
	}
	
}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	local XComLinearColorPalette Palette;

	//PrintPaletteEnum();

	// ARMOR_TINT
	Palette = `CONTENT.GetColorPalette(ePalette_ArmorTint);
	class'CustomColourManager'.default.START_INDEX = min(class'CustomColourManager'.default.START_INDEX, Palette.Entries.Length);
	`log("Attempting to patch new colours [ArmorTint], current length:" @ Palette.Entries.Length @ "start index:" @ class'CustomColourManager'.default.START_INDEX,, 'OneMilCol');
	class'CustomColourManager'.default.NUM_COLOR_PER_BASE = Clamp(class'CustomColourManager'.default.NUM_COLOR_PER_BASE, 2, 1000);
	Palette.Entries.Length = (class'CustomColourManager'.default.NUM_COLOR_PER_BASE ** 3) + class'CustomColourManager'.default.START_INDEX;
	`log("New length:" @  Palette.Entries.Length,, 'OneMilCol');
	if (Palette.BaseOptions > class'CustomColourManager'.default.START_INDEX)
		Palette.BaseOptions = class'CustomColourManager'.default.START_INDEX;
	class'CustomColourManager'.static.InitColours(class'CustomColourManager'.default.START_INDEX, Palette.Entries);

	// EYE
	Palette = `CONTENT.GetColorPalette(ePalette_EyeColor);
	class'CustomColourManager'.default.START_INDEX_EYES = min(class'CustomColourManager'.default.START_INDEX_EYES, Palette.Entries.Length);
	`log("Attempting to patch new colours [EyeColor], current length:" @ Palette.Entries.Length @ "start index:" @ class'CustomColourManager'.default.START_INDEX_EYES,, 'OneMilCol');
	class'CustomColourManager'.default.NUM_COLOR_PER_BASE = Clamp(class'CustomColourManager'.default.NUM_COLOR_PER_BASE, 2, 1000);
	Palette.Entries.Length = (class'CustomColourManager'.default.NUM_COLOR_PER_BASE ** 3) + class'CustomColourManager'.default.START_INDEX_EYES;
	`log("New length:" @  Palette.Entries.Length,, 'OneMilCol');
	if (Palette.BaseOptions > class'CustomColourManager'.default.START_INDEX_EYES)
		Palette.BaseOptions = class'CustomColourManager'.default.START_INDEX_EYES;
	class'CustomColourManager'.static.InitColours(class'CustomColourManager'.default.START_INDEX_EYES, Palette.Entries, true);

	// HAIR
	Palette = `CONTENT.GetColorPalette(ePalette_HairColor);
	class'CustomColourManager'.default.START_INDEX_HAIR = min(class'CustomColourManager'.default.START_INDEX_HAIR, Palette.Entries.Length);
	`log("Attempting to patch new colours [HairColor], current length:" @ Palette.Entries.Length @ "start index:" @ class'CustomColourManager'.default.START_INDEX_HAIR,, 'OneMilCol');
	class'CustomColourManager'.default.NUM_COLOR_PER_BASE = Clamp(class'CustomColourManager'.default.NUM_COLOR_PER_BASE, 2, 1000);
	Palette.Entries.Length = (class'CustomColourManager'.default.NUM_COLOR_PER_BASE ** 3) + class'CustomColourManager'.default.START_INDEX_HAIR;
	`log("New length:" @  Palette.Entries.Length,, 'OneMilCol');
	if (Palette.BaseOptions > class'CustomColourManager'.default.START_INDEX_HAIR)
		Palette.BaseOptions = class'CustomColourManager'.default.START_INDEX_HAIR;
	class'CustomColourManager'.static.InitColours(class'CustomColourManager'.default.START_INDEX_HAIR, Palette.Entries, true);

	// SKIN - C
	Palette = `CONTENT.GetColorPalette(ePalette_CaucasianSkin);
	class'CustomColourManager'.default.START_INDEX_SKIN = min(class'CustomColourManager'.default.START_INDEX_SKIN, Palette.Entries.Length);
	`log("Attempting to patch new colours [CaucasianSkin], current length:" @ Palette.Entries.Length @ "start index:" @ class'CustomColourManager'.default.START_INDEX_SKIN,, 'OneMilCol');
	class'CustomColourManager'.default.NUM_COLOR_PER_BASE = Clamp(class'CustomColourManager'.default.NUM_COLOR_PER_BASE, 2, 1000);
	Palette.Entries.Length = (class'CustomColourManager'.default.NUM_COLOR_PER_BASE ** 3) + class'CustomColourManager'.default.START_INDEX_SKIN;
	`log("New length:" @  Palette.Entries.Length,, 'OneMilCol');
	if (Palette.BaseOptions > class'CustomColourManager'.default.START_INDEX_SKIN)
		Palette.BaseOptions = class'CustomColourManager'.default.START_INDEX_SKIN;
	class'CustomColourManager'.static.InitColours(class'CustomColourManager'.default.START_INDEX_SKIN, Palette.Entries, true);

	// SKIN - AS
	Palette = `CONTENT.GetColorPalette(ePalette_AsianSkin);
	class'CustomColourManager'.default.START_INDEX_SKIN = min(class'CustomColourManager'.default.START_INDEX_SKIN, Palette.Entries.Length);
	`log("Attempting to patch new colours [AsianSkin], current length:" @ Palette.Entries.Length @ "start index:" @ class'CustomColourManager'.default.START_INDEX_SKIN,, 'OneMilCol');
	class'CustomColourManager'.default.NUM_COLOR_PER_BASE = Clamp(class'CustomColourManager'.default.NUM_COLOR_PER_BASE, 2, 1000);
	Palette.Entries.Length = (class'CustomColourManager'.default.NUM_COLOR_PER_BASE ** 3) + class'CustomColourManager'.default.START_INDEX_SKIN;
	`log("New length:" @  Palette.Entries.Length,, 'OneMilCol');
	if (Palette.BaseOptions > class'CustomColourManager'.default.START_INDEX_SKIN)
		Palette.BaseOptions = class'CustomColourManager'.default.START_INDEX_SKIN;
	class'CustomColourManager'.static.InitColours(class'CustomColourManager'.default.START_INDEX_SKIN, Palette.Entries, true);

	// SKIN - AF
	Palette = `CONTENT.GetColorPalette(ePalette_AfricanSkin);
	class'CustomColourManager'.default.START_INDEX_SKIN = min(class'CustomColourManager'.default.START_INDEX_SKIN, Palette.Entries.Length);
	`log("Attempting to patch new colours [AfricanSkin], current length:" @ Palette.Entries.Length @ "start index:" @ class'CustomColourManager'.default.START_INDEX_SKIN,, 'OneMilCol');
	class'CustomColourManager'.default.NUM_COLOR_PER_BASE = Clamp(class'CustomColourManager'.default.NUM_COLOR_PER_BASE, 2, 1000);
	Palette.Entries.Length = (class'CustomColourManager'.default.NUM_COLOR_PER_BASE ** 3) + class'CustomColourManager'.default.START_INDEX_SKIN;
	`log("New length:" @  Palette.Entries.Length,, 'OneMilCol');
	if (Palette.BaseOptions > class'CustomColourManager'.default.START_INDEX_SKIN)
		Palette.BaseOptions = class'CustomColourManager'.default.START_INDEX_SKIN;
	class'CustomColourManager'.static.InitColours(class'CustomColourManager'.default.START_INDEX_SKIN, Palette.Entries, true);

	// SKIN - H
	Palette = `CONTENT.GetColorPalette(ePalette_HispanicSkin);
	class'CustomColourManager'.default.START_INDEX_SKIN = min(class'CustomColourManager'.default.START_INDEX_SKIN, Palette.Entries.Length);
	`log("Attempting to patch new colours [HispanicSkin], current length:" @ Palette.Entries.Length @ "start index:" @ class'CustomColourManager'.default.START_INDEX_SKIN,, 'OneMilCol');
	class'CustomColourManager'.default.NUM_COLOR_PER_BASE = Clamp(class'CustomColourManager'.default.NUM_COLOR_PER_BASE, 2, 1000);
	Palette.Entries.Length = (class'CustomColourManager'.default.NUM_COLOR_PER_BASE ** 3) + class'CustomColourManager'.default.START_INDEX_SKIN;
	`log("New length:" @  Palette.Entries.Length,, 'OneMilCol');
	if (Palette.BaseOptions > class'CustomColourManager'.default.START_INDEX_SKIN)
		Palette.BaseOptions = class'CustomColourManager'.default.START_INDEX_SKIN;
	class'CustomColourManager'.static.InitColours(class'CustomColourManager'.default.START_INDEX_SKIN, Palette.Entries, true);

	// FONT COLOUR
	// Check if WOTC exists
	if (class'Engine'.static.FindClassDefaultObject("UIShell_Photobooth") != none || class'Engine'.static.FindClassDefaultObject("UIArmory_Photobooth") != none)
	{
		Palette = `CONTENT.GetColorPalette(10);
		class'CustomColourManager'.default.START_INDEX_FONT = min(class'CustomColourManager'.default.START_INDEX_FONT, Palette.Entries.Length);
		`log("Attempting to patch new colours [Font], current length:" @ Palette.Entries.Length @ "start index:" @ class'CustomColourManager'.default.START_INDEX_FONT,, 'OneMilCol');
		class'CustomColourManager'.default.NUM_COLOR_PER_BASE = Clamp(class'CustomColourManager'.default.NUM_COLOR_PER_BASE, 2, 1000);
		//Palette.Entries.Length = (class'CustomColourManager'.default.NUM_COLOR_PER_BASE ** 3) + class'CustomColourManager'.default.START_INDEX_FONT;
		`log("New length:" @  Palette.Entries.Length,, 'OneMilCol');
		if (Palette.BaseOptions > class'CustomColourManager'.default.START_INDEX_FONT)
			Palette.BaseOptions = class'CustomColourManager'.default.START_INDEX_FONT;
		//class'CustomColourManager'.static.InitColours(class'CustomColourManager'.default.START_INDEX_FONT, Palette.Entries, true);
	}


	// Patching Soldier Customization
	PatchSoldier();
}

static function PatchSoldier()
{	
	local X2CharacterTemplateManager CharMgr;
	local X2CharacterTemplate SoldierTemplate;
	local array<X2DataTemplate> SoldierTempaltes;
	local X2DataTemplate DataTemplate;
	local name TemplateName;

	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	foreach default.SoldierTemplates(TemplateName)
	{
		CharMgr.FindDataTemplateAllDifficulties(TemplateName, SoldierTempaltes);
		`log(TemplateName @ "patched to use new XComCustomizeManager",, 'OneMilCol');
		foreach SoldierTempaltes(DataTemplate)
		{
			SoldierTemplate = X2CharacterTemplate(DataTemplate);
			if (SoldierTemplate != none)
			{
				SoldierTemplate.CustomizationManagerClass = class'XComCustomizationColourManager';
			}
		}
	}
}

/// <summary>
/// Called when the difficulty changes and this DLC is active
/// </summary>
static event OnDifficultyChanged()
{

}

simulated function EnableDLCContentPopupCallback(eUIAction eAction)
{

}

/// <summary>
/// Called when viewing mission blades with the Shadow Chamber panel, used primarily to modify tactical tags for spawning
/// Returns true when the mission's spawning info needs to be updated
/// </summary>
static function bool UpdateShadowChamberMissionInfo(StateObjectReference MissionRef)
{
	return false;
}

/// <summary>
/// Called from X2AbilityTag:ExpandHandler after processing the base game tags. Return true (and fill OutString correctly)
/// to indicate the tag has been expanded properly and no further processing is needed.
/// </summary>
static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	return false;
}
/// <summary>
/// Called from XComGameState_Unit:GatherUnitAbilitiesForInit after the game has built what it believes is the full list of
/// abilities for the unit based on character, class, equipment, et cetera. You can add or remove abilities in SetupData.
/// </summary>
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{

}