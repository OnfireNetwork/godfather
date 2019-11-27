AddRemoteEvent("SetWaypoint", function(slot, name, x, y, z)
    SetWaypoint(slot, "", 0, 0, 0)
    if name:len() > 0 then
        SetWaypoint(slot, name, x, y, z)
    end
end)