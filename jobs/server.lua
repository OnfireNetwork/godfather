function GetPlayerJob(player)
    return player_data[player].job
end

function SetPlayerJob(player, job)
    player_data[player].job = job
    SetPlayerPropertyValue(player, "job", job, true)
end

local garbageTruckSpawns = {
    {-192795.609375, -32457.486328125, 1049.3041992188, 0},
    {-192780.1875, -31989.021484375, 1049.1844482422, 0},
    {-192766.5625, -31560.921875, 1049.2416992188, 0},
    {-192754.09375, -31121.89453125, 1049.2163085938, 0}
}

for i=1,#garbageTruckSpawns do
    local v = CreateVehicle(9, garbageTruckSpawns[i][1], garbageTruckSpawns[i][2], garbageTruckSpawns[i][3], garbageTruckSpawns[i][4])
    SetVehiclePropertyValue(v, "owner", 0, true)
    SetVehicleLicensePlate(v, " ")
    SetVehiclePropertyValue(v, "locked", false, true)
    SetVehiclePropertyValue(v, "radio", false, true)
    SetVehiclePropertyValue(v, "radio_station", 0, true)
    SetVehiclePropertyValue(v, "radio_volume", 0, true)
    SetVehicleRespawnParams(v, true)
    SetVehiclePropertyValue(v, "garbage_bags", 0, true)
end

local deliveryTruckSpawns = {
    {-191864.5625, -37484.765625, 1047.6795654297, 270},
    {-191516.515625, -37474.97265625, 1047.6466064453, 270},
    {-191156.4375, -37467.81640625, 1047.6702880859, 270},
    {-190785.484375, -37466.9296875, 1047.6337890625, 270},
}

for i=1,#deliveryTruckSpawns do
    local v = CreateVehicle(22, deliveryTruckSpawns[i][1], deliveryTruckSpawns[i][2], deliveryTruckSpawns[i][3], deliveryTruckSpawns[i][4])
    SetVehiclePropertyValue(v, "owner", 0, true)
    SetVehicleLicensePlate(v, " ")
    SetVehiclePropertyValue(v, "locked", false, true)
    SetVehiclePropertyValue(v, "radio", false, true)
    SetVehiclePropertyValue(v, "radio_station", 0, true)
    SetVehiclePropertyValue(v, "radio_volume", 0, true)
    SetVehicleRespawnParams(v, true)
    SetVehiclePropertyValue(v, "delivery_packages", 10, true)
end