AddCommand("admin", function(player)
    if not IsPlayerAdmin(player) then
        AddPlayerChat(player, "You are not an admin!")
        return
    end
    CallRemoteEvent(player, "OpenAdminMenu")
end)

-- to be removed (just for debugging)
AddCommand("anim", function(player, anim)
    SetPlayerAnimation(player, anim)
end)

AddRemoteEvent("AdminTeleport", function(player, id, x, y, z)
    if not IsPlayerAdmin(player) then
        return
    end
    if GetPlayerDimension(id) ~= 0 then
        SetPlayerDimension(id, 0)
    end
    SetPlayerLocation(id, x, y, z)
end)

AddRemoteEvent("AdminTeleportPlayer", function(player, id, target)
    if not IsPlayerAdmin(player) then
        return
    end
    local x, y, z = GetPlayerLocation(target)
    if GetPlayerDimension(id) ~= GetPlayerDimension(target) then
        SetPlayerDimension(id, GetPlayerDimension(target))
    end
    SetPlayerLocation(id, x, y, z+50)
end)

AddRemoteEvent("AdminTeleportAll", function(player)
    if not IsPlayerAdmin(player) then
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
    if not IsPlayerAdmin(player) then
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
    if type == _("cash") then
        for i=1,#targets do
            SetPlayerCash(targets[i], GetPlayerCash(targets[i]) + amount)
        end
        AddPlayerChat(player, "Added cash successfully!")
        return
    end
    if type == _("balance") then
        for i=1,#targets do
            SetPlayerBalance(targets[i], GetPlayerBalance(targets[i]) + amount)
        end
        AddPlayerChat(player, "Added balance successfully!")
        return
    end
end)

AddRemoteEvent("AdminGiveWeapon", function(player, target, weapon, slot, ammo, equip)
    if not IsPlayerAdmin(player) then
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
    if not IsPlayerAdmin(player) then
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
    SetVehicleRespawnParams(vehicle, false)
    SetPlayerInVehicle(player, vehicle)
end)

local spectating = {}

AddRemoteEvent("AdminToggleSpec", function(player)
    if not IsPlayerAdmin(player) then
        return
    end
    if spectating[player] == nil then
        SetPlayerSpectate(player, true)
        spectating[player] = 0
    else
        SetPlayerSpectate(player, false)
        spectating[player] = nil
    end
end)

AddCommand("anim", function(player, name)
    SetPlayerAnimation(player, name)
end)