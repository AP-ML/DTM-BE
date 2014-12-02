-- InfoAddictInit
-- Author: robk
-- DateCreated: 11/29/2010 10:29:21 PM
--------------------------------------------------------------

-- Init file for Info Addict. This file gets called by InGameUIAddin and is the entry
-- point for most of the mod. The contexts below are loaded after all the contexts in
-- InGame.xml. 

-- Setting up the main shared table for the mod
MapModData.InfoAddict = {};

-- Data manager for InfoAddict. Data collection and ongoing data managment happens here.
ContextPtr:LoadNewContext("InfoAddictDataManager");

-- Main UI context for the InfoAddict GUI. To reference the context pointer for
-- InfoAddictScreen from other places(these contexts don't appear in ContextPtr:LookUpControl()
-- as far as I know), I'm saving the context pointer in the shared MapModData table.

MapModData.InfoAddict.InfoAddictScreenContext = ContextPtr:LoadNewContext("InfoAddictScreen");
MapModData.InfoAddict.InfoAddictScreenContext:SetHide(true);

-- Add an item to the DiploCorner drop down to access InfoAddict

function OnDiploCornerPopup()
  UIManager:PushModal(MapModData.InfoAddict.InfoAddictScreenContext)
end

function OnAdditionalInformationDropdownGatherEntries(additionalEntries)
  table.insert(additionalEntries, {
    text=Locale.ConvertTextKey("TXT_KEY_INFOADDICT_MAIN_TITLE"), 
    call=OnDiploCornerPopup
  })
end
LuaEvents.AdditionalInformationDropdownGatherEntries.Add(OnAdditionalInformationDropdownGatherEntries)
LuaEvents.RequestRefreshAdditionalInformationDropdownEntries()

