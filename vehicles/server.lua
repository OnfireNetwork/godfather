local function isAdmin(player)
    return true
end

local function calcPrice(liter)
    return liter * 1.67
end

local fuelUsage = 30 / 3600

CreateTimer(function()
    local vehicles = GetAllVehicles()
    for i=1, #vehicles do
        if GetVehicleEngineState(vehicles[i]) then
            SetVehiclePropertyValue(vehicles[i], "fuel", GetVehiclePropertyValue(vehicles[i], "fuel") - fuelUsage, true)
        end
    end
end, 1000)

AddRemoteEvent("VehicleMenuAction", function(player, action, vehicle)
    if action == "Lock" then
        local owner = GetVehiclePropertyValue(vehicle, "owner")
        if owner == -1 then
            if not isAdmin(player) then
                AddPlayerChat(player, "This vehicle doesn't belong to you!")
                return
            end
        elseif owner == 0 then
            AddPlayerChat(player, "This vehicle has no lock!")
            return
        else
            if owner ~= player then
                AddPlayerChat(player, "This vehicle doesn't belong to you!")
                return
            end
        end
        SetVehiclePropertyValue(vehicle, "locked", not GetVehiclePropertyValue(vehicle, "locked"), true)
        if GetVehiclePropertyValue(vehicle, "locked") then
            AddPlayerChat(player, "The vehicle has been locked!")
        else
            AddPlayerChat(player, "The vehicle has been unlocked!")
        end
    end
    if action == "Engine" then
        if GetVehicleEngineState(vehicle) then
            StopVehicleEngine(vehicle)
        else
            StartVehicleEngine(vehicle)
        end
        return
    end
    if action == "Park" then
        local owner = GetVehiclePropertyValue(vehicle, "owner")
        if owner < 1 then
            AddPlayerChat(player, "This vehicle can't be parked!")
            return
        else
            if owner ~= player then
                AddPlayerChat(player, "This vehicle doesn't belong to you!")
                return
            end
        end
        AddPlayerChat(player, "Parking isn't implemented yet!")
        return
    end
    if action == "Unflip" then
        if GetVehiclePropertyValue(vehicle, "locked") then
            AddPlayerChat(player, "You have to unlock the vehicle first!")
            return
        end
        local rx, ry, rz = GetVehicleRotation(vehicle)
		SetVehicleRotation(vehicle, 0.0, ry, 0.0)
        AddPlayerChat(player, "Vehicle has been unflipped!")
        return
    end
end)

AddRemoteEvent("VehicleRefuel", function(player, vehicle, liter)
    local oldFuel = GetVehiclePropertyValue(vehicle, "fuel")
    if liter <= 100 - oldFuel then
        SetVehiclePropertyValue(vehicle, "fuel", oldFuel + liter, true)
        AddPlayerChat(player, "Your vehicle got refueled!")
    else
        AddPlayerChat("Your tank is too full! (server)")
    end
end)

AddRemoteEvent("VehicleRadioStation", function(player, vehicle, station, volume)
    AddPlayerChat(player, "VehicleRadioStation")
    SetVehiclePropertyValue(vehicle, "radio_station", station, true)
    SetVehiclePropertyValue(vehicle, "radio_volume", volume, true)
    for i=0,GetVehicleNumberOfSeats(vehicle) do
        local pass = GetVehiclePassenger(vehicle, i)
        if pass ~= 0 then
            Delay(500, function()
                CallRemoteEvent(pass, "VehicleRadioUpdate")
            end)
        end
    end
    if station == 0 then
        AddPlayerChat(player, "Radio turned off!")
    else
        AddPlayerChat(player, "Station changed!")
    end
end)

AddEvent("OnPlayerDataReady", function(player, data)
    mariadb_query(db, "SELECT * FROM player_vehicles WHERE owner='"..data.db.."';", function()
        player_data[player].vehicles = {}
        for row=1,mariadb_get_row_count() do
            local playerVehicle = {
                id = mariadb_get_value_name_int(row, "id"),
                entity = -1,
                model = mariadb_get_value_name_int(row, "model"),
                color = mariadb_get_value_name_int(row, "color"),
                towed = mariadb_get_value_name_int(row, "towed") == 1,
                nitro = mariadb_get_value_name_int(row, "nitro") == 1,
                radio = mariadb_get_value_name_int(row, "radio") == 1,
                x = mariadb_get_value_name_float(row, "x"),
                y = mariadb_get_value_name_float(row, "y"),
                z = mariadb_get_value_name_float(row, "z"),
                heading = mariadb_get_value_name_float(row, "heading"),
                health = mariadb_get_value_name_int(row, "health"),
                fuel = mariadb_get_value_name_float(row, "fuel")
            }
            if not playerVehicle.towed then
                playerVehicle.entity = CreateVehicle(playerVehicle.model, playerVehicle.x, playerVehicle.y, playerVehicle.z, playerVehicle.heading)
                SetVehicleColor(playerVehicle.entity, playerVehicle.color)
                AttachVehicleNitro(playerVehicle.entity, playerVehicle.nitro)
                SetVehicleHealth(playerVehicle.entity, playerVehicle.health)
                SetVehiclePropertyValue(playerVehicle.entity, "owner", player, true)
                SetVehiclePropertyValue(playerVehicle.entity, "fuel", playerVehicle.fuel, true)
                SetVehiclePropertyValue(playerVehicle.entity, "locked", true, true)
                SetVehiclePropertyValue(playerVehicle.entity, "radio", playerVehicle.radio, true)
                SetVehiclePropertyValue(playerVehicle.entity, "radio_station", 0, true)
                SetVehiclePropertyValue(playerVehicle.entity, "radio_volume", 0, true)
            end
            table.insert(player_data[player].vehicles, playerVehicle)
        end
    end)
end)

AddEvent("OnPlayerQuit", function(player)
    for i=1,#player_data[player].vehicles do
        local playerVehicle = player_data[player].vehicles[i]
        if not playerVehicle.towed then
            playerVehicle.fuel = GetVehiclePropertyValue(playerVehicle.entity, "fuel")
            playerVehicle.health = GetVehicleHealth(playerVehicle.entity)
            DestroyVehicle(playerVehicle.entity)
            mariadb_query(db, "UPDATE player_vehicles SET fuel='"..playerVehicle.fuel.."',health='"..playerVehicle.health.."' WHERE id='"..playerVehicle.id.."';")
        end
    end
end)