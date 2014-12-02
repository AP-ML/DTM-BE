local g_button = nil

function OnInfoClockGetButton(retVal)
  retVal.button = g_button
end
LuaEvents.InfoClockGetButton.Add(OnInfoClockGetButton)

function OnGetTextHook(iPlayer, bShort)
  local retVal = {}
  LuaEvents.InfoClockGetText(iPlayer, bShort, retVal) 
  return retVal.text
end

function OnGetTooltipHook(iPlayer)
  local retVal = {}
  LuaEvents.InfoClockGetTooltip(iPlayer, retVal) 
  return retVal.text
end

function OnClickHook(iButtonOffsetX, button)
  LuaEvents.InfoClockClick(iButtonOffsetX, button)
end

function OnCallbackHook(button)
  g_button = button
  LuaEvents.InfoClockCallback(button)
end

LuaEvents.InfoBarAddin({
  id="Clock",
  priority=-100,
  text=OnGetTextHook,
  tip=OnGetTooltipHook,
  click=OnClickHook,
  callback=OnCallbackHook
})
