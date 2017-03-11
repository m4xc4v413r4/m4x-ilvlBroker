local dropData = {};
m4xilvlBrokerDB = m4xilvlBrokerDB or {};

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:NewDataObject("m4xilvlBroker", {
	type = "data source",
	icon = "Interface\\Icons\\inv_axe_73",
	label = "ilvl"
});

local frame = CreateFrame("Frame")
local dropdown = CreateFrame("Button");

dropdown.displayMode = "MENU";

frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");

local function UpdateValues()
	local avgilvl, avgilvlEquip = GetAverageItemLevel();
	if m4xilvlBrokerDB["view"] == "full" then
		dataobj.text = string.format("%d (%d)", avgilvlEquip, avgilvl);
	elseif m4xilvlBrokerDB["view"] == "partial" then
		dataobj.text = string.format("%d", avgilvlEquip);
	end
	return avgilvl, avgilvlEquip;
end

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if not m4xilvlBrokerDB["view"] then
			m4xilvlBrokerDB["view"] = "partial";
		end
	end
	UpdateValues();
end);

dropdown.initialize = function(self, dropLevel)
	if not dropLevel then return end
	wipe(dropData);

	if dropLevel == 1 then
		dropData.isTitle = 1;
		dropData.notCheckable = 1;

		dropData.text = "m4x ilvlBroker";
		UIDropDownMenu_AddButton(dropData, dropLevel);

		dropData.isTitle = nil;
		dropData.disabled = nil;
		dropData.keepShownOnClick = 1;
		dropData.hasArrow = 1;
		dropData.notCheckable = 1;

		dropData.text = "View";
		UIDropDownMenu_AddButton(dropData, dropLevel);

		dropData.value = nil;
		dropData.hasArrow = nil;
		dropData.keepShownOnClick = nil;

		dropData.text = CLOSE;
		dropData.func = function() CloseDropDownMenus(); end
		dropData.checked = nil;
		UIDropDownMenu_AddButton(dropData, dropLevel);

	elseif dropLevel == 2 then
		avgilvl, avgilvlEquip = UpdateValues(avgilvl, avgilvlEquip);
		dropData.keepShownOnClick = 1;
		dropData.notCheckable = 1;

		dropData.text = string.format("%d (%d)", avgilvlEquip, avgilvl);
		dropData.func = function() m4xilvlBrokerDB["view"] = "full"; UpdateValues(); end
		UIDropDownMenu_AddButton(dropData, dropLevel);

		dropData.text = string.format("%d", avgilvlEquip);
		dropData.func = function() m4xilvlBrokerDB["view"] = "partial"; UpdateValues(); end
		UIDropDownMenu_AddButton(dropData, dropLevel);
	end
end

dataobj.OnClick = function(self, button)
	if button == "RightButton" then
		ToggleDropDownMenu(1, nil, dropdown, self:GetName(), 0, 0);
	end
end