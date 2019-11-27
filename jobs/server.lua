function GetPlayerJob(player)
    return player_data[player].job
end

function SetPlayerJob(player, job)
    player_data[player].job = job
    SetPlayerPropertyValue(player, "job", job, true)
end

local garbageTrucks = {
    {-1, -192795.609375, -32457.486328125, 1049.3041992188, 0},
    {-1, -192780.1875, -31989.021484375, 1049.1844482422, 0},
    {-1, -192766.5625, -31560.921875, 1049.2416992188, 0},
    {-1, -192754.09375, -31121.89453125, 1049.2163085938, 0}
}

local garbage = {}
for i=1,38 do
    garbage[i] = true
end

for i=1,#garbageTrucks do
    local v = CreateVehicle(9, garbageTrucks[i][2], garbageTrucks[i][3], garbageTrucks[i][4], garbageTrucks[i][5])
    SetVehiclePropertyValue(v, "owner", 0, true)
    SetVehicleLicensePlate(v, " ")
    SetVehiclePropertyValue(v, "locked", false, true)
    SetVehiclePropertyValue(v, "radio", false, true)
    SetVehiclePropertyValue(v, "radio_station", 0, true)
    SetVehiclePropertyValue(v, "radio_volume", 0, true)
    SetVehicleRespawnParams(v, false)
    SetVehiclePropertyValue(v, "garbage_bags", 0, true)
    garbageTrucks[i][1] = v
end

local deliveryTrucks = {
    {-1, -191864.5625, -37484.765625, 1047.6795654297, 270},
    {-1, -191516.515625, -37474.97265625, 1047.6466064453, 270},
    {-1, -191156.4375, -37467.81640625, 1047.6702880859, 270},
    {-1, -190785.484375, -37466.9296875, 1047.6337890625, 270},
}

for i=1,#deliveryTrucks do
    local v = CreateVehicle(22, deliveryTrucks[i][2], deliveryTrucks[i][3], deliveryTrucks[i][4], deliveryTrucks[i][5])
    SetVehiclePropertyValue(v, "owner", 0, true)
    SetVehicleLicensePlate(v, " ")
    SetVehiclePropertyValue(v, "locked", false, true)
    SetVehiclePropertyValue(v, "radio", false, true)
    SetVehiclePropertyValue(v, "radio_station", 0, true)
    SetVehiclePropertyValue(v, "radio_volume", 0, true)
    SetVehicleRespawnParams(v, false)
    SetVehiclePropertyValue(v, "delivery_packages", 10, true)
    deliveryTrucks[i][1] = v
end

local deliveryPoints = {
    {-171000.421875, -33466.25, 1227.6971435547},
    {-174832.296875, -36621.96484375, 1227.1726074219},
    {-177775.0625, -36968.03515625, 1232.1761474609},
    {-177808.453125, -41703.95703125, 1227.4689941406},
    {-174132.265625, -42024.71484375, 1227.0222167969},
    {-169766.84375, -45728.04296875, 1237.1525878906},
    {-174619.734375, -46827.60546875, 1237.1765136719},
    {-177765.703125, -45769.59375, 1232.1630859375},
    {-177499.15625, -49685.515625, 1237.4119873047},
    {-162252.421875, -36704.33984375, 1182.3640136719},
    {-161348.671875, -39832.46484375, 1182.1553955078},
    {-158432.078125, -39682.453125, 1183.7580566406},
    {-158361.1875, -36869.93359375, 1182.3640136719},
    {-155139.625, -38035.80078125, 1182.3640136719},
    {-155360.65625, -35692.38671875, 1182.1553955078},
    {-178885.734375, -55772.125, 1227.7380371094},
    {-180344.265625, -58874.5390625, 1247.1533203125},
    {-183806.1875, -55767.91015625, 1227.4790039063},
    {-184703.578125, -59495.83203125, 1227.6677246094},
    {-187943.40625, -55767.58984375, 1227.6694335938},
    {-187442.9375, -58979.546875, 1227.6531982422},
    {-193317.703125, -53825.0625, 1232.0913085938},
    {-187992.78125, -62791.9609375, 1227.4311523438},
    {-184515.765625, -62431.81640625, 1227.7380371094},
    {-181525.671875, -63100.46484375, 1228.0900878906},
    {-172675.140625, -88305.8671875, 1598.4008789063},
    {-180063.203125, -83200.5546875, 1737.4022216797},
    {-173912.359375, -50595.3359375, 1227.9490966797}
}

CreateTimer(function()
    for i=1,#garbageTrucks do
        vx, vy, vz = GetVehicleLocation(garbageTrucks[i][1])
            if GetDistance3D(vx, vy, vz, -191923.46875, -32086.419921875, 1148.1510009766) < 3000 then
                if GetVehiclePropertyValue(garbageTrucks[i][1], "garbage_bags") ~= nil then
                    if GetVehiclePropertyValue(garbageTrucks[i][1], "garbage_bags") > 0 then
                        if GetVehicleDriver(garbageTrucks[i][1]) ~= nil then
                            player_data[GetVehicleDriver(garbageTrucks[i][1])].salary = player_data[GetVehicleDriver(garbageTrucks[i][1])].salary + (GetVehiclePropertyValue(garbageTrucks[i][1], "garbage_bags") * 40)
                            SetVehiclePropertyValue(garbageTrucks[i][1], "garbage_bags", 0, true)
                        end
                    end
                end
            end
            for player,data in pairs(player_data) do
                if data.job == "GARBAGE" then
                    if GetAttachedItem(player, "hand_r") == 620 then
                        local px, py, pz = GetPlayerLocation(player)
                        if GetDistance3D(vx, vy, vz, px, py, pz) < 400 then
                            SetAttachedItem(player, "hand_r", 0)
                            SetVehiclePropertyValue(garbageTrucks[i][1], "garbage_bags", GetVehiclePropertyValue(garbageTrucks[i][1], "garbage_bags") + 1, true)
                        end
                    end
                end
            end
    end
    for i=1,#deliveryTrucks do
        vx, vy, vz = GetVehicleLocation(deliveryTrucks[i][1])
        if GetDistance3D(vx, vy, vz, -191019.265625, -38077.92578125, 1148.1510009766) < 3000 then
            if GetVehiclePropertyValue(deliveryTrucks[i][1], "delivery_packages") ~= nil then
                if GetVehiclePropertyValue(deliveryTrucks[i][1], "delivery_packages") < 10 then
                    SetVehiclePropertyValue(deliveryTrucks[i][1], "delivery_packages", 10, true)
                end
            end
        end
    end
    for player,data in pairs(player_data) do
        if data.job == "DELIVERY" then
            if GetPlayerPropertyValue(player, "delivery_dest") ~= nil then
                local px, py, pz = GetPlayerLocation(player)
                if GetAttachedItem(player, "hand_r") == 654 then
                    if GetDistance3D(deliveryPoints[GetPlayerPropertyValue(player, "delivery_dest")][1], deliveryPoints[GetPlayerPropertyValue(player, "delivery_dest")][2], deliveryPoints[GetPlayerPropertyValue(player, "delivery_dest")][3], px, py, pz) < 100 then
                        SetAttachedItem(player, "hand_r", 0)
                        SetPlayerPropertyValue(player, "delivery_dest", nil)
                        player_data[player].salary = player_data[player].salary + 100
                        SetWaypoint(player, 1, "", 0, 0, 0)
                    end
                else
                    if GetAttachedItem(player, "hand_r") == 0 then
                        if GetDistance3D(px, py, pz, deliveryPoints[GetPlayerPropertyValue(player, "delivery_dest")][1], deliveryPoints[GetPlayerPropertyValue(player, "delivery_dest")][2], deliveryPoints[GetPlayerPropertyValue(player, "delivery_dest")][3]) < 4000 then
                            if GetPlayerVehicle(player) == 0 then
                                for i=1,#deliveryTrucks do
                                    vx, vy, vz = GetVehicleLocation(deliveryTrucks[i][1])
                                    if GetDistance3D(vx, vy, vz, px, py, pz) < 400 then
                                        if GetVehiclePropertyValue(deliveryTrucks[i][1], "delivery_packages") > 0 then
                                            SetVehiclePropertyValue(deliveryTrucks[i][1], "delivery_packages", GetVehiclePropertyValue(deliveryTrucks[i][1], "delivery_packages") - 1, true)
                                            SetAttachedItem(player, "hand_r", 654)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end, 1000)

AddRemoteEvent("GarbageCollect", function(player, container)
    if player_data[player].job ~= "GARBAGE" then
        return
    end
    if GetAttachedItem(player, "hand_r") ~= 0 then
        return
    end
    if garbage[container] == true then
        garbage[container] = false
        SetAttachedItem(player, "hand_r", 620)
        Delay(600000, function()
            garbage[container] = true
        end)
    else
        AddPlayerChat(player, "This container is empty!")
    end
end)

AddCommand("deliver", function(player)
    if player_data[player].job ~= "DELIVERY" then
        return
    end
    if GetPlayerPropertyValue(player, "delivery_dest") ~= nil then
        AddPlayerChat(player, "You already have a destination!")
        return
    end
    local point = Random(1,#deliveryPoints)
    SetPlayerPropertyValue(player, "delivery_dest", point)
    SetWaypoint(player, 1, "Delivery", deliveryPoints[point][1], deliveryPoints[point][2], deliveryPoints[point][3])
end)