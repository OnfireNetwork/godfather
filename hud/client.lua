ShowHealthHUD(false)
local web = CreateWebUI(0,0,0,0,1,16)
SetWebAlignment(web, 0,0)
SetWebAnchors(web, 0,0,1,1)
SetWebURL(web, "http://asset/godfather/hud/hud.html")
SetWebVisibility(web, WEB_HITINVISIBLE)
CreateTimer(function(player)
    ExecuteWebJS(web, "SetCash("..GetPlayerPropertyValue(player, "cash")..");")
end, 1000, GetPlayerId())

AddEvent("OnKeyPress", function(key)
    if key ~= "V" then
        return
    end
    EnableFirstPersonCamera(not IsFirstPersonCamera())
end)