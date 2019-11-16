local vehicleShops = {
    {
        entity = -1,
        text = -1,
        model = 11,
        price = 15000,
        location = {-190210.84375,-50082.19140625,1060.0284423828,270},
        spawn = {-190053.34375, -51833.6953125, 1045.0548095703, 225}
    },
    {
        entity = -1,
        text = -1,
        model = 1,
        price = 40000,
        location = {-189801.265625,-50107.74609375,1050.5717773438,270},
        spawn = {-190053.34375, -51833.6953125, 1045.0548095703, 225}
    },
    {
        entity = -1,
        text = -1,
        model = 12,
        price = 250000,
        location = {-189409.53125,-50070.02734375,1050.5714111328,270},
        spawn = {-190053.34375, -51833.6953125, 1045.0548095703, 225}
    },
    {
        entity = -1,
        text = -1,
        model = 6,
        price = 100000,
        location = {-188998.546875,-50108.0859375,1049.6424560547,270},
        spawn = {-190053.34375, -51833.6953125, 1045.0548095703, 225}
    },
    {
        entity = -1,
        text = -1,
        model = 17,
        price = 650000,
        location = {-188438.171875,-50221.9453125,1044.9904785156,225},
        spawn = {-190053.34375, -51833.6953125, 1045.0548095703, 225}
    },
    {
        entity = -1,
        text = -1,
        model = 22,
        price = 300000,
        location = {-188382.234375,-50784.36328125,1047.5521240234,180},
        spawn = {-190053.34375, -51833.6953125, 1045.0548095703, 225}
    },
    {
        entity = -1,
        text = -1,
        model = 7,
        price = 150000,
        location = {-188311.328125,-51220.98046875,1048.5278320313,180},
        spawn = {-190053.34375, -51833.6953125, 1045.0548095703, 225}
    },
    {
        entity = -1,
        text = -1,
        model = 4,
        price = 1500000,
        location = {-188320.4375,-51664.44140625,1049.4560546875,180},
        spawn = {-190053.34375, -51833.6953125, 1045.0548095703, 225}
    },
    {
        entity = -1,
        text = -1,
        model = 5,
        price = 3000000,
        location = {-188281.6875,-52118.91796875,1052.1384277344,180},
        spawn = {-190053.34375, -51833.6953125, 1045.0548095703, 225}
    },
    {
        entity = -1,
        text = -1,
        model = 10,
        price = 8000000,
        location = {145256.078125,-159998.171875,1155.7541503906,340},
        spawn = {144363.96875, -161944.046875, 1155.7543945313, 340}
    }
}

for i=1,#vehicleShops do
    vehicleShops[i].entity = CreateVehicle(vehicleShops[i].model, vehicleShops[i].location[1], vehicleShops[i].location[2], vehicleShops[i].location[3], vehicleShops[i].location[4])
    local textOffset = 200
    if vehicleShops[i].model == 17 then
        textOffset = 350
    end
    if vehicleShops[i].model == 10 then
        textOffset = 400
    end
    if vehicleShops[i].model == 22 then
        textOffset = 250
    end
    if vehicleShops[i].model == 7 then
        textOffset = 250
    end
    vehicleShops[i].text = CreateText3D(_("vehicle_model_"..vehicleShops[i].model).." ("..vehicleShops[i].price.." $)", 15, vehicleShops[i].location[1], vehicleShops[i].location[2], vehicleShops[i].location[3] + textOffset, 0, 0, 0)
    SetVehicleRespawnParams(vehicleShops[i].entity, false)
    SetVehicleColor(vehicleShops[i].entity, 0xFFFFFF)
    SetVehiclePropertyValue(vehicleShops[i].entity, "dummy", true, true)
    SetVehiclePropertyValue(vehicleShops[i].entity, "vehicle_shop", i, true)
    SetVehiclePropertyValue(vehicleShops[i].entity, "vehicle_shop_price", vehicleShops[i].price, true)
end

AddRemoteEvent("VehicleShopBuy", function(player, shop)
    if vehicleShops[shop] == nil then
        return
    end
    if GetPlayerCash(player) < vehicleShops[shop].price then
        AddPlayerChat(player, _("not_enough_cash"))
        return
    end
    SetPlayerCash(player, GetPlayerCash(player) - vehicleShops[shop].price)
    mariadb_query(db, "INSERT INTO player_vehicles (owner,model) VALUES ('"..player.."','"..vehicleShops[shop].model.."');", function()
        local playerVehicle = {
            id = mariadb_get_insert_id(),
            model = vehicleShops[shop].model,
            color = 0xFFFFFF,
            license = "",
            towed = false,
            nitro = false,
            radio = false,
            x = 0,
            y = 0,
            z = 0,
            heading = 0,
            health = 2000,
            fuel = 100
        }
        playerVehicle.entity = CreateVehicle(playerVehicle.model, vehicleShops[shop].spawn[1], vehicleShops[shop].spawn[2], vehicleShops[shop].spawn[3], vehicleShops[shop].spawn[4])
        SetVehicleColor(playerVehicle.entity, playerVehicle.color)
        SetVehicleHealth(playerVehicle.entity, playerVehicle.health)
        SetVehicleLicensePlate(playerVehicle.entity, " ")
        SetVehiclePropertyValue(playerVehicle.entity, "owner", player, true)
        SetVehiclePropertyValue(playerVehicle.entity, "fuel", playerVehicle.fuel, true)
        SetVehiclePropertyValue(playerVehicle.entity, "locked", true, true)
        SetVehiclePropertyValue(playerVehicle.entity, "radio", false, true)
        SetVehiclePropertyValue(playerVehicle.entity, "radio_station", 0, true)
        SetVehiclePropertyValue(playerVehicle.entity, "radio_volume", 0, true)
        SetVehicleRespawnParams(vehicle, false)
        table.insert(player_data[player].vehicles, playerVehicle)
    end)
end)