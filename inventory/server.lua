local itemTypes = {
    ["firework"] = { name = "Firework", max = 10, give = true },
    ["phone_book"] = { name = "Phone Book", max = 1, give = true },
    ["traffic_exam"] = { name = "Traffic Exam", max = 1, give = false },
    ["air_traffic_exam"] = { name = "Air Traffic Exam", max = 1, give = false },
    ["wp_deagle"] = { name = "Desert Eagle", max = 10, give = true },
    ["wp_m1911"] = { name = "M1911", max = 10, give = true },
    ["wp_glock17"] = { name = "Glock 17", max = 10, give = true },
    ["wp_beretta"] = { name = "Beretta", max = 10, give = true },
    ["wp_m4"] = { name = "M4 Shotgun", max = 10, give = true },
    ["wp_pumpgun"] = { name = "Pumpgun", max = 10, give = true },
    ["wp_mp5sd"] = { name = "MP5 SD", max = 10, give = true },
    ["wp_mac10"] = { name = "MAC 10", max = 10, give = true },
    ["wp_ump45"] = { name = "UMP 45", max = 10, give = true },
    ["wp_m16"] = { name = "M16", max = 10, give = true },
    ["wp_ak47"] = { name = "AK47", max = 10, give = true },
    ["wp_ak47_gold"] = { name = "Golden AK47", max = 10, give = true },
    ["wp_g36"] = { name = "G36", max = 10, give = true },
    ["wp_val"] = { name = "VAL", max = 10, give = true },
    ["wp_aks"] = { name = "AKS", max = 10, give = true },
    ["wp_fal"] = { name = "FAL", max = 10, give = true },
    ["wp_mk16"] = { name = "MK16", max = 10, give = true },
    ["wp_hk416"] = { name = "HK 416", max = 10, give = true },
    ["wp_awp"] = { name = "AWP", max = 10, give = true },
    ["mag_rifle"] = { name = "Rifle Magazine", max = 100, give = true },
    ["mag_pistol"] = { name = "Pistol Magazine", max = 100, give = true }
}

local weaponItems = {
    "wp_none",
    "wp_deagle",
    "wp_m1911",
    "wp_glock17",
    "wp_beretta",
    "wp_m4",
    "wp_pumpgun",
    "wp_mp5sd",
    "wp_mac10",
    "wp_ump45",
    "wp_m16",
    "wp_ak47",
    "wp_ak47_gold",
    "wp_g36",
    "wp_val",
    "wp_aks",
    "wp_fal",
    "wp_mk16",
    "wp_hk416",
    "wp_awp"
}

local weaponMagSize = {
    0,
    8,
    10,
    14,
    9,
    12,
    10,
    40,
    50,
    35,
    31,
    31,
    31,
    31,
    20,
    36,
    20,
    30,
    20,
    7
}

local function getWPItemModel(item)
    for i=1,#weaponItems do
        if weaponItems[i] == item then
            return i
        end
    end
    return 1
end

local function addInvItem(player, item, amount)
    if player_data[player].inventory[item] == nil then
        player_data[player].inventory[item] = amount
    else
        player_data[player].inventory[item] = player_data[player].inventory[item] + amount
    end
    SetPlayerPropertyValue(player, "inventory", player_data[player].inventory, true)
end

local function weaponPack(player, slot)
    if slot == 1 then
        return
    end
    local magItem = "mag_rifle"
    if slot == 3 then
        magItem = "mag_pistol"
    end
    local model, ammo = GetPlayerWeapon(player, slot)
    if model ~= 0 then
        local mags = 0
        while ammo >= weaponMagSize[model + 1] do
            mags = mags + 1
            ammo = ammo - weaponMagSize[model + 1]
        end
        if mags > 0 then
            addInvItem(player, magItem, mags)
        end
        addInvItem(player, weaponItems[model + 1], 1)
    end
end

local function useWeaponItem(player, item)
    local newModel = getWPItemModel(item)
    if newModel == 1 then
        return
    end
    local slot = 2
    if newModel < 6 then
        slot = 3
    end
    weaponPack(player, slot)
    SetPlayerWeapon(player, newModel, 0, true, slot)
end

AddCommand("packweapon", function(player)
    weaponPack(player, GetPlayerEquippedWeaponSlot(player) + 1)
    SetPlayerWeapon(player, 1, 0, false, GetPlayerEquippedWeaponSlot(player) + 1)
end)

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
    if getWPItemModel(item) ~= 1 then
        useWeaponItem(player, item)
        used = true
    end
    if item == "mag_rifle" then
        local model, ammo = GetPlayerWeapon(player, 2)
        if model ~= 0 then
            SetPlayerWeapon(player, model + 1, ammo + weaponMagSize[model + 1], true, 2)
            used = true
        end
    end
    if item == "mag_pistol" then
        local model, ammo = GetPlayerWeapon(player, 3)
        if model ~= 0 then
            SetPlayerWeapon(player, model + 1, ammo + weaponMagSize[model + 1], true, 3)
            used = true
        end
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