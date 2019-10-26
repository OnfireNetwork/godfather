local function isAdmin(player)
    return true
end

AddCommand("admin", function(player)
    if not isAdmin(player) then
        AddPlayerChat("You are not an admin!")
        return
    end
    CallRemoteEvent(player, "OpenAdminMenu")
end)

AddRemoteEvent("AdminTeleport", function(player, id, x, y, z)
    if not isAdmin(player) then
        return
    end
    SetPlayerLocation(id, x, y, z)
end)

AddRemoteEvent("AdminTeleportPlayer", function(player, id, target)
    if not isAdmin(player) then
        return
    end
    local x, y, z = GetPlayerLocation(target)
    SetPlayerLocation(id, x, y, z+100)
end)

AddRemoteEvent("AdminAddMoney", function(player, target, type, amount)
    if not isAdmin(player) then
        return
    end
    if player_data[target] == nil then
        return
    end
    if type == "Cash" then
        player_data[target].cash = player_data[target].cash + amount
        SetPlayerPropertyValue(target, "cash", player_data[target].cash, true)
        AddPlayerChat(player, "Added cash successfully!")
        return
    end
    if type == "Bank" then
        player_data[target].balance = player_data[target].balance + amount
        SetPlayerPropertyValue(target, "balance", player_data[target].balance, true)
        AddPlayerChat(player, "Added balance successfully!")
        return
    end
end)

AddRemoteEvent("AdminSpawnVehicle", function(player, model, plate)
    if not isAdmin(player) then
        return
    end
    local vehicle = CreateVehicle(model, GetPlayerLocation(player))
    SetVehicleLicensePlate(vehicle, plate)
    SetVehiclePropertyValue(vehicle, "owner", -1, true)
    SetVehiclePropertyValue(vehicle, "locked", false, true)
    SetPlayerInVehicle(player, vehicle)
end)