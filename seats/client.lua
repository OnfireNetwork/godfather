local seats = {
    {128370, 79027, 1560, 180},
    {-181840, -44584, 1150, 90},
    {-181785, -44584, 1150, 90},
    {-181727.5, -44584, 1150, 90},
    {-181645, -44584, 1150, 90}
}

local sitting = false

AddEvent("OnKeyPress", function(key)
    if key ~= "E" then
        return
    end
    if not sitting then
        local x, y, z = GetPlayerLocation()
        for i=1,#seats do
            local seat = seats[i]
            if GetDistance3D(x, y, z, seat[1], seat[2], seat[3]) < 30 then
                --seat logic
                CallRemoteEvent("OnSeat", seat[1], seat[2], seat[3], seat[4])
                sitting = true
            end
        end
    else
        CallRemoteEvent("OnSeatLeave")
        sitting = false
    end
end)