AddRemoteEvent("OnSeat", function(player, x, y, z, h)
    SetPlayerLocation(player, x, y, z) 
    SetPlayerHeading(player, h)
    SetPlayerAnimation(player, "SIT04")
end)

AddRemoteEvent("OnSeatLeave", function(player)
    SetPlayerAnimation(player, "STOP")
end)