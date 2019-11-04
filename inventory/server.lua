local itemTypes = {
    ["firework"] = {},
    ["phone_book"] = {},
    ["traffic_exam"] = { max = 1, give = false },
    ["air_traffic_exam"] = { max = 1, give = false },
    ["wp_deagle"] = { max = 10 },
    ["wp_m1911"] = { max = 10 },
    ["wp_glock17"] = { max = 10 },
    ["wp_beretta"] = { max = 10 },
    ["wp_m4"] = { max = 10 },
    ["wp_pumpgun"] = { max = 10 },
    ["wp_mp5sd"] = { max = 10 },
    ["wp_mac10"] = { max = 10 },
    ["wp_ump45"] = { max = 10 },
    ["wp_m16"] = { max = 10 },
    ["wp_ak47"] = { max = 10 },
    ["wp_ak47_gold"] = { max = 10 },
    ["wp_g36"] = { max = 10 },
    ["wp_val"] = { max = 10 },
    ["wp_aks"] = { max = 10 },
    ["wp_fal"] = { max = 10 },
    ["wp_mk16"] = { max = 10 },
    ["wp_hk416"] = { max = 10 },
    ["wp_awp"] = { max = 10 },
    ["mag_rifle"] = {},
    ["mag_pistol"] = {},
    ["mobile_phone"] = {}
}

for k,v in pairs(itemTypes) do
    itemTypes[k].max = itemTypes[k].max or 1000
    itemTypes[k].give = itemTypes[k].give or true
end

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
        while ammo >= weapon_config[model + 1].MagazineSize do
            mags = mags + 1
            ammo = ammo - weapon_config[model + 1].MagazineSize
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

AddEvent("OnPlayerJoin", function(player)
    for i=2,#weaponItems do
        SetPlayerWeaponStat(player, i, "name", _("item_"..weaponItems[i]))
    end
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
            SetPlayerWeapon(player, model + 1, ammo + weapon_config[model + 1].MagazineSize, true, 2)
            used = true
        end
    end
    if item == "mag_pistol" then
        local model, ammo = GetPlayerWeapon(player, 3)
        if model ~= 0 then
            SetPlayerWeapon(player, model + 1, ammo + weapon_config[model + 1].MagazineSize, true, 3)
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
    AddPlayerChat(player, _("inventory_gave_to_player", GetPlayerName(target), _("item_"..item), amount))
    AddPlayerChat(target, _("inventory_got_by_player", GetPlayerName(target), _("item_"..item), amount))
end)