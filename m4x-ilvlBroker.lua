local m4xilvlData = LibStub("LibDataBroker-1.1"):NewDataObject("m4xilvlBroker", {
	type = "data source",
	icon = "Interface\\Icons\\inv_axe_73",
	label = "ilvl"
})

local frame = CreateFrame("Frame", "m4xilvlBrokerFrame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");

frame:SetScript("OnEvent", function(self, event, ...)
    local avgilvl, avgilvlEquip = GetAverageItemLevel();
    m4xilvlData.text = string.format("%d", avgilvlEquip);
    m4xilvlData.value = string.format("%d (%d)", avgilvlEquip, avgilvl);
end);