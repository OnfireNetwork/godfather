local itemTypes = {
    ["firework"] = { name = "Firework", max = 10 },
    ["phone_book"] = { name = "Phone Book", max = 1 }
}

AddRemoteEvent("InventoryUseItem", function(player, item)
    if player_data[player].inventory[item] == nil then
        return
    end
    local used = false
    if item == "firework" then
        local x, y, z = GetPlayerLocation(player)
        Delay(1500, function()
            for k,v in pairs(player_data) do
                CallRemoteEvent(k, "SpawnFirework", Random(1, 13), x, y, z, 90, 0, 0)
            end
        end)
        
        used = true
    end
    if used then
        if player_data[player].inventory[item] > 1 then
            player_data[player].inventory[item] = player_data[player].inventory[item] - 1
        else
            player_data[player].inventory[item] = nil
        end
        SetPlayerPropertyValue(player, "inventory", player_data[player].inventory, true)
    end
end)

AddRemoteEvent("InventoryGiveItem", function(player, target, item, amount)
    if player == target then
        return
    end
    if player_data[player] == nil then
        return
    end
    if player_data[target] == nil then
        return
    end
    if amount < 1 then
        return
    end
    if player_data[player].inventory[item] == nil then
        return
    end
    if player_data[player].inventory[item] < amount then
        return
    end
    local old = 0
    if player_data[target].inventory[item] ~= nil then
        if player_data[target].inventory[item] + amount > itemTypes[item].max then
            AddPlayerChat(player, _("inventory_other_cannot_carry"))
            return
        end
        old = player_data[target].inventory[item]
    end
    if player_data[player].inventory[item] == amount then
        player_data[player].inventory[item] = nil
    else
        player_data[player].inventory[item] = player_data[player].inventory[item] - amount
    end
    player_data[target].inventory[item] = old + amount
    SetPlayerPropertyValue(player, "inventory", player_data[player].inventory, true)
    SetPlayerPropertyValue(target, "inventory", player_data[target].inventory, true)
    AddPlayerChat(player, _("inventory_gave_to_player", GetPlayerName(target), itemTypes[item].name, amount))
    AddPlayerChat(target, _("inventory_got_by_player", GetPlayerName(target), itemTypes[item].name, amount))
end)