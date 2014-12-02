----------------------------------------------------------------        
----------------------------------------------------------------        
include( "TradeLogic" );

Controls.WhatWillMakeThisWorkButton:RegisterCallback( Mouse.eLClick, OnEqualizeDeal );
Controls.WhatWillEndThisWarButton:RegisterCallback( Mouse.eLClick, OnEqualizeDeal );
Controls.WhatConcessionsButton:RegisterCallback( Mouse.eLClick, OnEqualizeDeal );
Controls.WhatDoYouWantButton:RegisterCallback( Mouse.eLClick, OnWhatDoesAIWant );
Controls.WhatWillYouGiveMeButton:RegisterCallback( Mouse.eLClick, OnWhatWillAIGive );

ContextPtr:SetInputHandler( InputHandler );


Events.AILeaderMessage.Add( LeaderMessageHandler );

----------------------------------------------------------------        
function OnLeavingLeader()
    UIManager:DequeuePopup( ContextPtr );
end
Events.LeavingLeaderViewMode.Add( OnLeavingLeader );

-- Added by robk for InfoAddict mod, 2010.11.02
function OnInfoAddict()
  local InfoAddictControl = MapModData.InfoAddict.InfoAddictScreenContext;
  UIManager:PushModal(InfoAddictControl);
end;
Controls.InfoAddictButton:RegisterCallback( Mouse.eLClick, OnInfoAddict );
-- END robk Edit
