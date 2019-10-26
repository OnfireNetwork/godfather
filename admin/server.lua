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

-- to be removed (just for debugging)
AddCommand("anim", function(player, anim)
    SetPlayerAnimation(player, anim)
end)

AddRemoteEvent("AdminTeleport", function(player, id, x, y, z)
    if not isAdmin(player) then
        return
    end
    if GetPlayerDimension(id) ~= 0 then
        SetPlayerDimension(id, 0)
    end
    SetPlayerLocation(id, x, y, z)
end)

AddRemoteEvent("AdminTeleportPlayer", function(player, id, target)
    if not isAdmin(player) then
        return
    end
    local x, y, z = GetPlayerLocation(target)
    if GetPlayerDimension(id) ~= GetPlayerDimension(target) then
        SetPlayerDimension(id, GetPlayerDimension(target))
    end
    SetPlayerLocation(id, x, y, z+50)
end)

AddRemoteEvent("AdminTeleportAll", function(player)
    if not isAdmin(player) then
        return
    end
    local x, y, z = GetPlayerLocation(player)
    for k,v in pairs(player_data) do
        if k ~= player then
            if GetPlayerDimension(player) ~= GetPlayerDimension(k) then
                SetPlayerDimension(k, GetPlayerDimension(player))
            end
            SetPlayerLocation(k, x, y, z+50)
        end
    end
end)

AddRemoteEvent("AdminAddMoney", function(player, target, type, amount)
    if not isAdmin(player) then
        return
    end
    local targets = {}
    if target == 0 then
        for k,v in pairs(player_data) do
            table.insert(targets, k)
        end
    else
        if player_data[target] == nil then
            return
        end
        targets = {target}
    end
    if type == "Cash" then
        for i=1,#targets do
            player_data[targets[i]].cash = player_data[targets[i]].cash + amount
            SetPlayerPropertyValue(targets[i], "cash", player_data[targets[i]].cash, true)
        end
        AddPlayerChat(player, "Added cash successfully!")
        return
    end
    if type == "Bank" then
        for i=1,#targets do
            player_data[targets[i]].balance = player_data[targets[i]].balance + amount
            SetPlayerPropertyValue(targets[i], "balance", player_data[targets[i]].balance, true)
        end
        AddPlayerChat(player, "Added balance successfully!")
        return
    end
end)

AddRemoteEvent("AdminGiveWeapon", function(player, target, weapon, slot, ammo, equip)
    if not isAdmin(player) then
        return
    end
    local targets = {}
    if target == 0 then
        for k,v in pairs(player_data) do
            table.insert(targets, k)
        end
    else
        if player_data[target] == nil then
            return
        end
        targets = {target}
    end
    for i=1,#targets do
        SetPlayerWeapon(targets[i], weapon, ammo, equip, slot)
    end
    AddPlayerChat(player, "Weapon set successfully!")
end)

AddRemoteEvent("AdminSpawnVehicle", function(player, model, plate, radio, nitro)
    if not isAdmin(player) then
        return
    end
    local vehicle = CreateVehicle(model, GetPlayerLocation(player))
    SetVehicleLicensePlate(vehicle, plate)
    AttachVehicleNitro(vehicle, nitro)
    SetVehiclePropertyValue(vehicle, "owner", -1, true)
    SetVehiclePropertyValue(vehicle, "locked", false, true)
    SetVehiclePropertyValue(vehicle, "fuel", 100, true)
    SetVehiclePropertyValue(vehicle, "radio", radio, true)
    SetVehiclePropertyValue(vehicle, "radio_station", 0, true)
    SetVehiclePropertyValue(vehicle, "radio_volume", 0, true)
    SetPlayerInVehicle(player, vehicle)
end)