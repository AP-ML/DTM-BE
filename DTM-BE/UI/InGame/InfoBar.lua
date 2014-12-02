include("InstanceManager")

local bIsRegistered = false

-- DO NOT CHANGE THIS VALUE!!!
local modVersion = 4

local savedData = Modding.OpenUserData("SummaryBar", 3)

local g_ButtonManager = InstanceManager:new("InfoInstance", "InfoButton", Controls.InfoStack)
local buttonUpdates = {}

local gNoInfoOverlay = false
LuaEvents.InfoOverlayOff.Add(function () gNoInfoOverlay = true; ContextPtr:SetHide(gNoInfoOverlay) end)
LuaEvents.InfoOverlayNotify()

-----
----- Addin Functions -----
-----
local g_InfoBarTabs = {}
local iPriority = 100

function OnInfoBarAddin(tab)
  if (not ContextPtr:IsHidden()) then
    if (tab.priority == nil) then
      tab.priority = iPriority
      iPriority = iPriority + 1
    end

    setDefaultToggle(tab.id, (tab.small == true))

    table.insert(g_InfoBarTabs, tab)
  end
end

function LoadAddins()
  LuaEvents.InfoBarAddin.Add(OnInfoBarAddin)

  infoAddins = {}
  for addin in Modding.GetActivatedModEntryPoints("InfoBarAddin") do
    local addinFile = addin.File;
    local extension = Path.GetExtension(addinFile);
    local path = string.sub(addinFile, 1, #addinFile - #extension);
    ptr = ContextPtr:LoadNewContext(path)
    table.insert(infoAddins, ptr)
  end

  table.sort(g_InfoBarTabs, byPriority)
end


-----
----- Hide the TopPanel overlay when the Civilopedia is active -----
-----
function SystemUpdateUIHandler(iType)
  if (iType == SystemUpdateUIType.BulkHideUI) then
    ContextPtr:SetHide(true)
  elseif (iType == SystemUpdateUIType.BulkShowUI) then
    ContextPtr:SetHide(gNoInfoOverlay)
  end
end
Events.SystemUpdateUI.Add(SystemUpdateUIHandler)


-----
----- Update Functions -----
-----
function OnClick(iTab)
  local tab = g_InfoBarTabs[iTab]

  tab.click(getButtonOffsetX(iTab), tab.button)
end

function OnRightClick(iTab)
  local tab = g_InfoBarTabs[iTab]

  if (tab.rclick) then
    tab.rclick(getButtonOffsetX(iTab), tab.button)
  else
    setToggle(tab.id, not (isToggle(tab.id) == true))

    OnUpdateButton(iTab)
  end
end

function OnUpdateToolTip(iTab)
  local tab = g_InfoBarTabs[iTab]
  local sLabel = nil

  if type(tab.tip) == "string" then
    sLabel = Locale.ConvertTextKey(tab.tip)
  elseif type(tab.tip) == "function" then
    sLabel = g_InfoBarTabs[iTab].tip(Game.GetActivePlayer())
  end

  tab.button:SetToolTipString(sLabel)
end

function OnUpdateButton(iTab)
  local tab = g_InfoBarTabs[iTab]
  local sText = ""

  if type(tab.text) == "string" then
    sText = Locale.ConvertTextKey(tab.text)

    if (isToggle(tab.id) == true) then
	  if (tab.short) then
        sText = Locale.ConvertTextKey(tab.short)
	  end
    end
  elseif type(tab.text) == "function" then
    sText = tab.text(Game.GetActivePlayer(), (isToggle(tab.id) == true))
  end

  tab.button:SetText(sText)
end

function OnUpdateButtons()
  for _,iTab in ipairs(buttonUpdates) do
    OnUpdateButton(iTab)
  end

  Controls.InfoStack:CalculateSize()
  Controls.InfoStack:ReprocessAnchoring()
end


-----
----- Helper Functions -----
-----
function getButtonOffsetX(iTab)
--  local iStackPadding = 10
--  local iButtonOffsetX = Controls.InfoStack:GetOffsetX() - iStackPadding
--
--  for i = 1, iTab, 1 do
--    iButtonOffsetX = iButtonOffsetX + g_InfoBarTabs[i].button:GetSizeX() + iStackPadding
--  end
--  
--  return iButtonOffsetX

  local iMouseX, iMouseY = UIManager:GetMousePos()
  return iMouseX
end

function byPriority(a, b)
  return (a.priority < b.priority)
end

function OnInfoBarBroadcast(broadcastModVersion, action, response)
  if (action == "present") then
    if (broadcastModVersion > modVersion) then
	  -- The broadcasting mod is more recent than I am, so pretend I'm not really here
      LuaEvents.ModBroadcast.Remove(OnModBroadcast)
	  ContextPtr:SetHide(true)
	else
	  -- I'm more recent (or got here first) than the broadcasting mod, so signal that I've already loaded the addins
      table.insert(response, "Already here!")
	end
  end
end

function isModInitialised()
  local response = {}
  LuaEvents.ModBroadcast(modVersion, "present", response)

  if (#response == 0) then
    LuaEvents.ModBroadcast.Add(OnInfoBarBroadcast)
  end

  return (#response ~= 0)
end

function setDefaultToggle(sKey, bValue)
  local value = savedData.GetValue(sKey)
  if (value == nil) then
    setToggle(sKey, bValue)
  end
end

function setToggle(sKey, bValue)
  local iValue = 0
  if (bValue == true) then iValue = 1 end

  savedData.SetValue(sKey, iValue)
end

function isToggle(sKey)
  local value = savedData.GetValue(sKey)

  return (value ~= nil and value == 1)
end


-----
----- Initialisation -----
-----
function Initialize()
  if (not isModInitialised()) then
    ContextPtr:SetHide(false)
	
    LoadAddins()

    for i,tab in ipairs(g_InfoBarTabs) do
        local controlTable = g_ButtonManager:GetInstance()
	    local button = controlTable.InfoButton

        print(string.format("Added InfoTab %s", tab.id))
	    tab.button = button

	    if (tab.callback) then
	      tab.callback(button)
	    end

        if type(tab.text) == "string" then
	      OnUpdateButton(i)
        elseif type(tab.text) == "function" then
	      table.insert(buttonUpdates, i)
	    end

        button:RegisterMouseOverCallback(function() OnUpdateToolTip(i) end)

	    if (tab.click) then
          button:RegisterCallback(Mouse.eLClick, function() OnClick(i) end)
	    end

        button:RegisterCallback(Mouse.eRClick, function() OnRightClick(i) end)
    end

    Events.SerialEventGameDataDirty.Add(OnUpdateButtons)
    Events.SerialEventCityInfoDirty.Add(OnUpdateButtons)
    Events.SerialEventTurnTimerDirty.Add(OnUpdateButtons)
    Events.GameplaySetActivePlayer.Add(OnUpdateButtons)

    OnUpdateButtons()
  else
    ContextPtr:SetHide(true)
  end
end

function SetActivePlayer(iPlayer, iPrevPlayer)
  if (not bIsRegistered) then
    -- This doesn't want to play nicely at load time!
	local control = ContextPtr:LookUpControl("/InGame/TopPanel/TopPanelInfoStack")
    
	if (control) then
	  bIsRegistered = true

      Controls.InfoStack:ChangeParent(control)
      control:ReprocessAnchoring()

	  OnUpdateButtons()
	end
  end
end
Events.GameplaySetActivePlayer.Add(SetActivePlayer)

Initialize()
