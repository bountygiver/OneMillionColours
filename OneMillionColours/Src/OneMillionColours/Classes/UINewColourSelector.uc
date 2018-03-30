class UINewColourSelector extends UIColorSelector;

var UIPanel barContainer;
var UIColorChip PreviewColor;

var UICheckbox CustomBox;
var UISlider SliderR, SliderG, SliderB;

var UIButton HexButton;

var XComCustomizationColourManager CustMgr;

simulated function float GetRealPercent(float percentage)
{
	if (percentage <= 1.00f)
	{
		return 0.00f;
	}
	return percentage;
}

simulated function UIColorSelector InitColorSelector(optional name InitName, 
															 optional float initX = 500,
															 optional float initY = 500,
															 optional float initWidth = 500,
															 optional float initHeight = 500,
												 			 optional array<string> initColors,
												 			 optional delegate<OnPreviewDelegate> initPreviewDelegate,
															 optional delegate<OnSetDelegate> initSetDelegate,
															 optional int initSelection = 0,
															 optional array<string> iniSecondaryColors) //TODO: implement secondary chips
{
	local float sR, sG, sB, step_size;
	local bool IsUsingCust;
	InitPanel(InitName);
	
	IsUsingCust = true;
	if (UICustomize(Screen) != none)
	{
		CustMgr = XComCustomizationColourManager(Movie.Pres.GetCustomizeManager());
	}
	else if (UIArmory_WeaponUpgrade(Screen) != none)
	{
		CustMgr = new class'XComCustomizationColourManager';
		initColors.Length = 0;
		initColors = CustMgr.GetColorList(eUICustomizeCat_WeaponColor);
		initPreviewDelegate = WeapUpgradPreview;
		initSetDelegate = WeapUpgradSet;
		height = initHeight - 200;
		initHeight -= 200;
	}
	else if (string(Screen.Class) == "UIShell_Photobooth" || Screen.LibID == 'PhotoboothScreen')
	{
		CustMgr = new class'XComCustomizationColourManager';
		initColors.Length = 0;
		initColors = CustMgr.GetColorList(20);
	}
	else
	{
		IsUsingCust = false;
		`log("Screen:" @ string(Screen.Class),, 'OneMilCol');
	}

	if (initColors.Length > max(1000, class'CustomColourManager'.default.NUM_COLOR_PER_BASE ** 3)) // To prevent MASSIVE LAG on unpatched units.
	{
		initColors.Length = initColors.Length - (class'CustomColourManager'.default.NUM_COLOR_PER_BASE ** 3);
	}
	else if (IsUsingCust && initHeight > 500)
	{
		initHeight = 500;
	}

	width = initWidth;
	height = initHeight;
	SetPosition(initX, initY);
	
	ChipContainer = Spawn(class'UIPanel', self).InitPanel();
	ChipContainer.bCascadeFocus = false;
	ChipContainer.bAnimateOnInit = false;
	ChipContainer.SetY(5); // offset slightly so the highlight for the chips shows up in the masked area
	ChipContainer.SetSelectedNavigation();

	if (CustMgr != none && CustMgr.GetColStartIndex() >= 0)
	{
		//`log("One Mil Colours detected...",, 'OneMilCol');
		barContainer = Spawn(class'UIPanel', self).InitPanel();
		barContainer.bAnimateOnInit = false;;
		barContainer.SetX(0);
		barContainer.SetY(initHeight + 50);
		barContainer.bCascadeFocus = false;

		Spawn(class'UIBGBox', barContainer).InitBG(,,,550, 180);

		class'CustomColourManager'.static.GetPercentOfIndex(CustMgr.CurrentColorSelection, initSelection, sR, sG, sB);

		PreviewColor = Spawn(class'UIColorChip', barContainer);
		PreviewColor.InitColorChip( '',, class'CustomColourManager'.static.GetHexOfSlider(CustMgr.CurrentColorSelection, sR, sG, sB), "P", 475, 10, 
								class'UIColorChip'.default.width,,, OnPreviewChipHover, OnPreviewChipClicked);

		CustomBox = Spawn(class'UICheckbox', barContainer).InitCheckbox(,, initSelection >= CustMgr.GetColStartIndex(), OnCustomCB);
		Spawn(class'UIText', barContainer).InitText(,"Use Custom").SetPosition(50, 0);
		step_size = 100.0f / float(class'CustomColourManager'.default.NUM_COLOR_PER_BASE);
		SliderR = Spawn(class'UISlider', barContainer);
		SliderR.bIsNavigable = false;
		SliderR.bAnimateOnInit = false;
		SliderR.InitSlider(, "Red", 0, SliderChanged, step_size);
		SliderG = Spawn(class'UISlider', barContainer);
		SliderG.bIsNavigable = false;
		SliderG.bAnimateOnInit = false;
		SliderG.InitSlider(, "Green", 0, SliderChanged, step_size);
		SliderB = Spawn(class'UISlider', barContainer);
		SliderB.bIsNavigable = false;
		SliderB.bAnimateOnInit = false;
		SliderB.InitSlider(, "Blue", 0, SliderChanged, step_size);

		SliderR.SetPercent(sR);
		SliderG.SetPercent(sG);
		SliderB.SetPercent(sB);

		SliderR.SetText("Red:" @ int(GetRealPercent(SliderR.percent)) $ "%");
		SliderG.SetText("Green:" @ int(GetRealPercent(SliderG.percent)) $ "%");
		SliderB.SetText("Blue:" @ int(GetRealPercent(SliderB.percent)) $ "%");

		SliderR.SetPosition(10, 50);
		SliderG.SetPosition(10, 80);
		SliderB.SetPosition(10, 110);

		Spawn(class'UIButton', barContainer).InitButton(, "OK", OnConfirmCustom).SetPosition(10, 140);
		HexButton = Spawn(class'UIButton', barContainer).InitButton(, class'CustomColourManager'.static.GetHexOfSlider(CustMgr.CurrentColorSelection, sR, sG, sB, 1.0), OnConfirmCustom);
		HexButton.SetPosition(300, 140);
	}

	if( initColors.Length == 0 )
		initColors = GenerateRandomColors(75);

	OnPreviewDelegate = initPreviewDelegate; 
	OnSetDelegate = initSetDelegate; 

	InitialSelection = initSelection;

	CreateColorChips(initColors);

	ChipContainer.Navigator.OnSelectedIndexChanged = OnSelectionIndexChanged;
	return self; 
}

simulated function OnCustomCB(UICheckbox checkboxControl)
{
	local int start_idx;
	start_idx = CustMgr != none ? CustMgr.GetColStartIndex() : -1;
	if (start_idx == -1)
	{
		CustomBox.SetChecked(false, false);
		return;
	}

	if (CustomBox.bChecked)
	{
		OnPreviewDelegate(class'CustomColourManager'.static.GetColourIndexSlider(start_idx, GetRealPercent(SliderR.percent), GetRealPercent(SliderG.percent), GetRealPercent(SliderB.percent)) );
		PreviewColor.SetColor(class'CustomColourManager'.static.GetHexOfSlider(CustMgr.CurrentColorSelection, GetRealPercent(SliderR.percent), GetRealPercent(SliderG.percent), GetRealPercent(SliderB.percent)));
		HexButton.SetText(class'CustomColourManager'.static.GetHexOfSlider(CustMgr.CurrentColorSelection, GetRealPercent(SliderR.percent), GetRealPercent(SliderG.percent), GetRealPercent(SliderB.percent), 1.0));
	}
	else
	{
		OnPreviewDelegate(InitialSelection);
	}
}

simulated function SliderChanged(UISlider sliderControl)
{
	local int start_idx;
	start_idx = CustMgr != none ? CustMgr.GetColStartIndex() : -1;
	if (start_idx == -1)
		return;

	if (!CustomBox.bChecked)
		CustomBox.SetChecked(true, false);

	PreviewColor.SetColor(class'CustomColourManager'.static.GetHexOfSlider(CustMgr.CurrentColorSelection, GetRealPercent(SliderR.percent), GetRealPercent(SliderG.percent), GetRealPercent(SliderB.percent)));
	HexButton.SetText(class'CustomColourManager'.static.GetHexOfSlider(CustMgr.CurrentColorSelection, GetRealPercent(SliderR.percent), GetRealPercent(SliderG.percent), GetRealPercent(SliderB.percent), 1.0));
	OnPreviewDelegate(class'CustomColourManager'.static.GetColourIndexSlider(start_idx, GetRealPercent(SliderR.percent), GetRealPercent(SliderG.percent), GetRealPercent(SliderB.percent)) );
	SliderR.SetText("Red:" @ int(GetRealPercent(SliderR.percent)) $ "%");
	SliderG.SetText("Green:" @ int(GetRealPercent(SliderG.percent)) $ "%");
	SliderB.SetText("Blue:" @ int(GetRealPercent(SliderB.percent)) $ "%");
}

simulated function OnConfirmCustom(UIButton btnAccept)
{
	local int start_idx;
	if (CustomBox.bChecked)
	{
		start_idx = CustMgr != none ? CustMgr.GetColStartIndex() : -1;
		if (start_idx == -1)
			OnSetDelegate( InitialSelection );
		if(OnSetDelegate != none)
			OnSetDelegate( class'CustomColourManager'.static.GetColourIndexSlider(start_idx, GetRealPercent(SliderR.percent), GetRealPercent(SliderG.percent), GetRealPercent(SliderB.percent)) );
	}
	else
	{
		if(OnSetDelegate != none)
			OnSetDelegate( InitialSelection );
	}
}

simulated function OnHexPicker(UIButton btnAccept)
{
	local TInputDialogData kData;
	local int start_idx;
	start_idx = CustMgr != none ? CustMgr.GetColStartIndex() : -1;
	if (start_idx == -1)
		return;

	kData.strTitle = "ENTER HEX";
	kData.iMaxChars = 6;
	kData.strInputBoxText = Right(class'CustomColourManager'.static.GetHexOfSlider(CustMgr.CurrentColorSelection, GetRealPercent(SliderR.percent), GetRealPercent(SliderG.percent), GetRealPercent(SliderB.percent), 1.0), 6);
	kData.fnCallback = OnHexPicked;

	Movie.Pres.UIInputDialog(kData);
}

function OnInvalidColour(string text)
{
	local TDialogueBoxData DialogData;

	DialogData.eType = eDialog_Warning;
	DialogData.strTitle = "Invalid colour!";
	DialogData.strText = text @ "is not a valid input";
	DialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
	Movie.Pres.UIRaiseDialog(DialogData);
}

function int HexToInt(string hex)
{
	local int returnInt, i, weight;
	local string s;
	weight = 1;
	while(Len(hex) > 0)
	{
		s = Right(hex, 1);
		i = int(s);
		if (i > 0)
		{
			returnInt += i * weight;
		}
		switch(s)
		{
			case "0":
				break;
			case "a":
			case "A":
				returnInt += 10 * weight;
				break;
			case "b":
			case "B":
				returnInt += 11 * weight;
				break;
			case "c":
			case "C":
				returnInt += 12 * weight;
				break;
			case "d":
			case "D":
				returnInt += 13 * weight;
				break;
			case "e":
			case "E":
				returnInt += 14 * weight;
				break;
			case "f":
			case "F":
				returnInt += 15 * weight;
				break;
			default:
				return -1;
		}
		hex = Left(hex, Len(hex) - 1);
		weight *= 16;
	}
	return returnInt;
}

function OnHexPicked(string text)
{
	// Verify Hex
	// Set
	local int r, g, b;

	if (Len(text) != 6)
	{
		OnInvalidColour(text);
		return;
	}

	b = HexToInt(Right(text, 2));
	g = HexToInt(Mid(text, 2, 2));
	r = HexToInt(Left(text, 2));

	if (r < 0 || g < 0 || b < 0)
	{
		OnInvalidColour(text);
		return;
	}

	SliderR.SetPercent(100.0f / 256.0f * r);
	SliderG.SetPercent(100.0f / 256.0f * g);
	SliderB.SetPercent(100.0f / 256.0f * b);

	SliderChanged(SliderB);
}

simulated function OnPreviewChipClicked(int iIndex)
{
	CustomBox.SetChecked(true, false);
	OnConfirmCustom(none);
}

simulated function OnPreviewChipHover(int iIndex)
{
	CustomBox.SetChecked(true, true);
}

simulated function OnPreviewColor(int iIndex)
{
	if (CustMgr != none && CustMgr.GetColStartIndex() >= 0 && iIndex < CustMgr.GetColStartIndex())
	{
		CustomBox.SetChecked(false, false);
	}
	if(OnPreviewDelegate != none)
		OnPreviewDelegate( iIndex );
}

simulated function WeapUpgradPreview(int iIndex)
{
	local UIArmory_WeaponUpgrade WScr;
	WScr = UIArmory_WeaponUpgrade(Screen);
	if (WScr == none)
		return;
	WScr.CreateCustomizationState();
	WScr.UpdatedWeapon.WeaponAppearance.iWeaponTint = iIndex;
	XComWeapon(WScr.ActorPawn).m_kGameWeapon.SetAppearance(WScr.UpdatedWeapon.WeaponAppearance);
	WScr.CleanupCustomizationState();
}

simulated function WeapUpgradSet(int iIndex)
{
	local UIArmory_WeaponUpgrade WScr;
	local XComGameState_Unit Unit;
	WScr = UIArmory_WeaponUpgrade(Screen);
	if (WScr == none)
		return;

	WScr.CreateCustomizationState();
	WScr.UpdatedWeapon.WeaponAppearance.iWeaponTint = iIndex;
	XComWeapon(WScr.ActorPawn).m_kGameWeapon.SetAppearance(WScr.UpdatedWeapon.WeaponAppearance);

	// Transfer the new weapon color back to the owner Unit's appearance data ONLY IF the weapon is otherwise unmodified
	Unit = WScr.GetUnit();
	if (Unit != none && !WScr.UpdatedWeapon.HasBeenModified())
	{
		Unit = XComGameState_Unit(WScr.CustomizationState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
		WScr.CustomizationState.AddStateObject(Unit);
		Unit.kAppearance.iWeaponTint = WScr.UpdatedWeapon.WeaponAppearance.iWeaponTint;
	}

	WScr.SubmitCustomizationChanges();

	WScr.CloseColorSelector();
	WScr.CustomizeList.Show();
	WScr.UpdateCustomization(none);
	WScr.ShowListItems();
}

simulated function SetInitialSelection()
{
	local float sR, sG, sB;

	ChipContainer.Navigator.ClearSelectionHierarchy();
	
	if (CustMgr != none && CustMgr.GetColStartIndex() >= 0)
	{
		class'CustomColourManager'.static.GetPercentOfIndex(CustMgr.CurrentColorSelection, InitialSelection, sR, sG, sB);

		SliderR.SetPercent(sR);
		SliderG.SetPercent(sG);
		SliderB.SetPercent(sB);

		PreviewColor.SetColor(class'CustomColourManager'.static.GetHexOfSlider(CustMgr.CurrentColorSelection, GetRealPercent(SliderR.percent), GetRealPercent(SliderG.percent), GetRealPercent(SliderB.percent)));
		HexButton.SetText(class'CustomColourManager'.static.GetHexOfSlider(CustMgr.CurrentColorSelection, GetRealPercent(SliderR.percent), GetRealPercent(SliderG.percent), GetRealPercent(SliderB.percent), 1.0));
		SliderR.SetText("Red:" @ int(GetRealPercent(SliderR.percent)) $ "%");
		SliderG.SetText("Green:" @ int(GetRealPercent(SliderG.percent)) $ "%");
		SliderB.SetText("Blue:" @ int(GetRealPercent(SliderB.percent)) $ "%");
	}

	if (ColorChips.Length > 0)
	{
		if (InitialSelection > -1 && InitialSelection < ColorChips.Length )
		{
			ChipContainer.Navigator.SetSelected(ColorChips[InitialSelection]);
		}
		else
		{
			if (CustMgr != none && CustMgr.GetColStartIndex() >= 0)
			{
				SliderChanged(SliderB);
				return;
			}
			else
			{
				ChipContainer.Navigator.SetSelected(ColorChips[0]);
			}
		}
	}
	ScrollToRow(UIColorChip(ChipContainer.Navigator.GetSelected()).Row);
}