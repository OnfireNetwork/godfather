Dialog = Dialog or ImportPackage("dialogui")
_ = _ or function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local shops = {
    {
        type = "gunstore",
        items = {
            wp_beretta = 1000,
            wp_glock17 = 1000,
            mag_pistol = 100,
            wp_pumpgun = 2000,
            wp_m16 = 5000,
            mag_rifle = 200
        },
        locations = {
            {128271.734375, 75061.875, 1566.9001464844},
            {-181943.796875, -40694.6953125, 1163.1500244141}
        }
    }
}

local shopMenu

AddEvent("OnTranslationReady", function()
    shopMenu = Dialog.create("{shop_title}", nil, _("cancel"))
    Dialog.addSelect(shopMenu, 1, "Your Inventory", 10)
    Dialog.setButtons(shopMenu, 1, "Sell")
    Dialog.addSelect(shopMenu, 2, "Shop Inventory", 10)
    Dialog.setButtons(shopMenu, 2, "Buy")
end)

AddEvent("OnKeyPress", function(key)
    if key ~= "E" then
        return
    end
    local x, y, z = GetPlayerLocation()
    for i=1,#shops do
        for j=1,#shops[i].locations do
            if GetDistance3D(x , y, z, shops[i].locations[j][1], shops[i].locations[j][2], shops[i].locations[j][3]) < 150 then
                Dialog.setVariable(shopMenu, "shop_title", "Gunstore")
                local items = {}
                for k,v in pairs(GetPlayerPropertyValue(GetPlayerId(), "inventory")) do
                    items[k] = _("item_"..k).." ["..v.."]"
                end
                Dialog.setSelectLabeledOptions(shopMenu, 1, 1, items)
                items = {}
                for k,v in pairs(shops[i].items) do
                    items[k] = _("item_"..k).." ["..v.." $]"
                end
                Dialog.setSelectLabeledOptions(shopMenu, 2, 1, items)
                Dialog.show(shopMenu)
                return
            end
        end
    end
end)