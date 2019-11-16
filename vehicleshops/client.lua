Dialog = Dialog or ImportPackage("dialogui")
_ = _ or function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local vehicleShopMenu
local lastShop = -1

AddEvent("OnTranslationReady", function()
    vehicleShopMenu = Dialog.create(_("buy_vehicle"), _("vehicle_shop_text", _("currency_symbol")), _("buy"), _("cancel"))
end)

AddEvent("OnPlayerStartEnterVehicle", function(vehicle)
    if GetVehiclePropertyValue(vehicle, "vehicle_shop") == nil then
        return
    end
    lastShop = GetVehiclePropertyValue(vehicle, "vehicle_shop")
    Dialog.setVariable(vehicleShopMenu, "model", _("vehicle_model_"..GetVehicleModel(vehicle)))
    Dialog.setVariable(vehicleShopMenu, "price", GetVehiclePropertyValue(vehicle, "vehicle_shop_price"))
    Dialog.show(vehicleShopMenu)
    return false
end)

AddEvent("OnDialogSubmit", function(dialog, button)
    if dialog == vehicleShopMenu then
        if button == 1 then
            CallRemoteEvent("VehicleShopBuy", lastShop)
        end
    end
end)