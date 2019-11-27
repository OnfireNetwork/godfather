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
    ["wp_tazer"] = { max = 10 },
    ["mag_rifle"] = {},
    ["mag_pistol"] = {},
    ["mobile_phone"] = {},
    ["chainsaw"] = {},
    ["log"] = {},
    ["planks"] = {},
    ["fishing_rod"] = {},
    ["fish"] = {},
    ["battery"] = {},
    ["ephedrine"] = {},
    ["meth"] = {},
    ["weed"] = {},
    ["cocaine"] = {},
    ["coca_leaf"] = {},
    ["dissolver"] = {},
    ["cutter"] = {}
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
    "wp_awp",
    "wp_tazer"
}

local function getWPItemModel(item)
    for i=1,#weaponItems do
        if weaponItems[i] == item then
            return i
        end
    end
    return 1
end

function AddPlayerInventoryItem(player, item, amount)
    if player_data[player] == nil then
        return
    end
    if player_data[player].inventory[item] == nil then
        player_data[player].inventory[item] = amount
    else
        player_data[player].inventory[item] = player_data[player].inventory[item] + amount
    end
    SetPlayerPropertyValue(player, "inventory", player_data[player].inventory, true)
end

function HasPlayerInventoryItem(player, item, amount)
    if player_data[player] == nil then
        return false
    end
    if player_data[player].inventory[item] == nil then
        return false
    end
    if player_data[player].inventory[item] < amount then
        return false
    end
    return true
end

function RemovePlayerInventoryItem(player, item, amount)
    if player_data[player] == nil then
        return
    end
    if player_data[player].inventory[item] == nil then
        return
    end
    if player_data[player].inventory[item]-amount < 1 then
        player_data[player].inventory[item] = nil
    else
        player_data[player].inventory[item] = player_data[player].inventory[item] - amount
    end
    SetPlayerPropertyValue(player, "inventory", player_data[player].inventory, true)
end

function GetPlayerInventoryItemAmount(player, item)
    if player_data[player] == nil then
        return 0
    end
    if player_data[player].inventory[item] == nil then
        return 0
    end
    return player_data[player].inventory[item]
end

function CanPlayerCarryItem(player, item, amount)
    local current = player_data[player].inventory[item]
    if current == nil then
        current = 0
    end
    return current + amount <= itemTypes[item].max
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
    if model ~= 1 then
        local mags = 0
        while ammo >= weapon_config[model].MagazineSize do
            mags = mags + 1
            ammo = ammo - weapon_config[model].MagazineSize
        end
        if mags > 0 then
            AddPlayerInventoryItem(player, magItem, mags)
        end
        AddPlayerInventoryItem(player, weaponItems[model], 1)
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
    SetPlayerWeapon(player, newModel, 0, true, slot, false)
end

AddCommand("packweapon", function(player)
    weaponPack(player, GetPlayerEquippedWeaponSlot(player))
    SetPlayerWeapon(player, 1, 0, false, GetPlayerEquippedWeaponSlot(player))
end)

AddEvent("OnPlayerJoin", function(player)
    for i=2,#weaponItems do
        SetPlayerWeaponStat(player, i, "name", _("item_"..weaponItems[i]))
    end
end)

AddRemoteEvent("InventoryUseItem", function(player, item)
    if not HasPlayerInventoryItem(player, item, 1) then
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
            SetPlayerWeapon(player, model, ammo + weapon_config[model].MagazineSize, true, 2, true)
            used = true
        end
    end
    if item == "mag_pistol" then
        local model, ammo = GetPlayerWeapon(player, 3)
        if model ~= 0 then
            SetPlayerWeapon(player, model, ammo + weapon_config[model].MagazineSize, true, 3, true)
            used = true
        end
    end
    if item == "chainsaw" then
        local px,py,pz = GetPlayerLocation(player)
        if GetDistance3D(px, py, pz,-222532, -70046, 850) < 5000 then
            SetAttachedItem(player, "hand_r", 1047)
            SetPlayerAnimation(player, "LOCKDOOR")
            CallRemoteEvent(player, "LockControlMove", true)
            Delay(3000, function()
                SetPlayerAnimation(player, "LOCKDOOR")
            end)
            Delay(6000, function()
                SetPlayerAnimation(player, "LOCKDOOR")
            end)
            Delay(10000, function()
                CallRemoteEvent(player, "LockControlMove", false)
                SetAttachedItem(player, "hand_r", 0)
                AddPlayerInventoryItem(player, "log", 1)
            end)
        end
    end
    if item == "log" then
        local px,py,pz = GetPlayerLocation(player)
        if GetDistance3D(px, py, pz,-193169, -34121, 1148) < 300 then
            used = true
            SetAttachedItem(player, "hand_r", 1075)
            SetPlayerAnimation(player, "LOCKDOOR")
            CallRemoteEvent(player, "LockControlMove", true)
            Delay(3000, function()
                SetPlayerAnimation(player, "LOCKDOOR")
            end)
            Delay(6000, function()
                SetPlayerAnimation(player, "LOCKDOOR")
            end)
            Delay(10000, function()
                CallRemoteEvent(player, "LockControlMove", false)
                SetAttachedItem(player, "hand_r", 0)
                AddPlayerInventoryItem(player, "planks", 1)
            end)
        end
    end
    if item == "fishing_rod" then
        local px,py,pz = GetPlayerLocation(player)
        SetAttachedItem(player, "hand_r", 1111)
        SetPlayerAnimation(player, "LOCKDOOR")
        CallRemoteEvent(player, "LockControlMove", true)
        Delay(16000, function()
            SetPlayerAnimation(player, "LOCKDOOR")
        end)
        Delay(20000, function()
            CallRemoteEvent(player, "LockControlMove", false)
            SetAttachedItem(player, "hand_r", 0)
            AddPlayerInventoryItem(player, "fish", 1)
        end)
    end
    if item == "ephedrine" then
        local px,py,pz = GetPlayerLocation(player)
        if GetDistance3D(px, py, pz, 199377.3125, 55606.8671875, 1408.3077392578) < 300 then
            if GetPlayerInventoryItemAmount(player, "battery") > 0 then
                used = true
                RemovePlayerInventoryItem(player, "battery", 1)
                SetPlayerAnimation(player, "COMBINE")
                CallRemoteEvent(player, "LockControlMove", true)
                Delay(4000, function()
                    SetPlayerAnimation(player, "COMBINE")
                end)
                Delay(8000, function()
                    SetPlayerAnimation(player, "COMBINE")
                end)
                Delay(13000, function()
                    CallRemoteEvent(player, "LockControlMove", false)
                    AddPlayerInventoryItem(player, "meth", 1)
                end)
            else
                AddPlayerChat(player, _("not_enough_items", _("item_battery")))
            end
        end
    end
    if item == "coca_leaf" then
        local px,py,pz = GetPlayerLocation(player)
        if GetDistance3D(px, py, pz, 199377.3125, 55606.8671875, 1408.3077392578) < 300 then
            if GetPlayerInventoryItemAmount(player, "dissolver") > 0 then
                used = true
                RemovePlayerInventoryItem(player, "dissolver", 1)
                SetPlayerAnimation(player, "COMBINE")
                CallRemoteEvent(player, "LockControlMove", true)
                Delay(4000, function()
                    SetPlayerAnimation(player, "COMBINE")
                end)
                Delay(8000, function()
                    SetPlayerAnimation(player, "COMBINE")
                end)
                Delay(13000, function()
                    CallRemoteEvent(player, "LockControlMove", false)
                    AddPlayerInventoryItem(player, "cocaine", 1)
                end)
            else
                AddPlayerChat(player, _("not_enough_items", _("item_dissolver")))
            end
        end
    end
    if item == "cutter" then
        local px,py,pz = GetPlayerLocation(player)
        if GetDistance3D(px, py, pz, 166593.921875, 140630.359375, 7604.8002929688) < 300 then
            SetPlayerAnimation(player, "LOCKDOOR")
            CallRemoteEvent(player, "LockControlMove", true)
            Delay(3000, function()
                SetPlayerAnimation(player, "PICKUP_MIDDLE")
            end)
            Delay(6000, function()
                SetPlayerAnimation(player, "COMBINE")
            end)
            Delay(11000, function()
                CallRemoteEvent(player, "LockControlMove", false)
                AddPlayerInventoryItem(player, "ephedrine", 1)
            end)
        end
        if GetDistance3D(px, py, pz, 84737.2890625, 128046.6875, 5133.4516601563) < 300 then
            SetPlayerAnimation(player, "LOCKDOOR")
            CallRemoteEvent(player, "LockControlMove", true)
            Delay(3000, function()
                SetPlayerAnimation(player, "PICKUP_MIDDLE")
            end)
            Delay(6000, function()
                SetPlayerAnimation(player, "PICKUP_LOWER")
            end)
            Delay(10000, function()
                CallRemoteEvent(player, "LockControlMove", false)
                AddPlayerInventoryItem(player, "coca_leaf", 1)
            end)
        end
    end
    if used then
        RemovePlayerInventoryItem(player, item, 1)
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
    if not HasPlayerInventoryItem(player, item, amount) then
        return
    end
    if not CanPlayerCarryItem(target, item, amount) then
        AddPlayerChat(player, _("inventory_other_cannot_carry"))
        return
    end
    RemovePlayerInventoryItem(player, item, amount)
    AddPlayerInventoryItem(target, item, amount)
    AddPlayerChat(player, _("inventory_gave_to_player", GetPlayerName(target), _("item_"..item), amount))
    AddPlayerChat(target, _("inventory_got_by_player", GetPlayerName(target), _("item_"..item), amount))
end)