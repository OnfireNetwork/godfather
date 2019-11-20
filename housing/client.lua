local buyMenu
local lastHouse

AddEvent("OnTranslationReady", function()
    buyMenu = Dialog.create(_("buy_house"), _("house_buy_text", _("currency_symbol")), _("buy"), _("cancel"))
    
end)

AddRemoteEvent("ShowHouseBuyDialog", function(house, id, price)
    lastHouse = house
    Dialog.setVariable(buyMenu, "price", price)
    Dialog.show(buyMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button)
    if dialog == buyMenu then
        if button == 1 then
            CallRemoteEvent("BuyHouse", lastHouse)
        end
    end
end)