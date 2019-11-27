
local pricing = {
    gunstore = {
        wp_beretta = 1000,
        wp_glock17 = 1000,
        mag_pistol = 100,
        wp_pumpgun = 2000,
        wp_m16 = 5000,
        mag_rifle = 200
    },
    hardware = {
        planks = 50
    },
    gasstation = {
        fish = 50,
        chainsaw = 200,
        fishing_rod = 100,
        mobile_phone = 300,
        dissolver = 50,
        battery = 50,
        cutter = 100
    }
}

local function getPrice(store, item)
    if pricing[store] == nil then
        return 0
    end
    if pricing[store][item] == nil then
        return 0
    end
    return pricing[store][item]
end

AddRemoteEvent("StoreBuyItem", function(player, store, item, amount)
    local price = getPrice(store, item) * amount
    if price == 0 then
        return
    end
    if GetPlayerCash(player) < price then
        AddPlayerChat(player, _("not_enough_cash"))
        return
    end
    SetPlayerCash(player, GetPlayerCash(player) - price)
    AddPlayerInventoryItem(player, item, amount)
end)

AddRemoteEvent("StoreSellItem", function(player, store, item, amount)
    local price = getPrice(store, item) * amount
    if price == 0 then
        return
    end
    if GetPlayerInventoryItemAmount(player, item) < amount then
        AddPlayerChat(_("not_enough_items", _("item_"..item)))
        return
    end
    SetPlayerCash(player, GetPlayerCash(player) + price)
    RemovePlayerInventoryItem(player, item, amount)
end)