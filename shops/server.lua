
local pricing = {
    gunstore = {
        wp_beretta = 1000,
        wp_glock17 = 1000,
        mag_pistol = 100,
        wp_pumpgun = 2000,
        wp_m16 = 5000,
        mag_rifle = 200
    }
}

local getPrice(store, item)
    if pricing[store] == nil then
        return 0
    end
    if pricing[store][item] == nil then
        return 0
    end
    return pricing[store][item]
end

AddRemoteEvent("StoreBuyItem", function(player, store, item)
    local price = getPrice(store, item)
    if price == 0 then
        return
    end
    if GetPlayerCash(player) < price then
        AddPlayerChat(player, _("not_enough_cash"))
        return
    end
    SetPlayerCash(player, GetPlayerCash(player) - price)
    AddPlayerInventoryItem(player, item, 1)
end)

AddRemoteEvent("StoreSellItem", function(player, store, item)
    local price = getPrice(store, item)
    if price == 0 then
        return
    end
    if GetPlayerInventoryItemAmount(player, item) < 1 then
        return
    end
    SetPlayerCash(player, GetPlayerCash(player) + price)
    RemovePlayerInventoryItem(player, item, 1)
end)