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
            {-181943.796875, -40694.6953125, 1163.1500244141}
        }
    },
    {
        type = "hardware",
        items = {
            planks = 50
        },
        locations = {
            {-168889.1875, -41391.2578125, 1146.94921875}
        }
    },
    {
        type = "gasstation",
        items = {
            chainsaw = 200,
            fishing_rod = 100,
            fish = 50,
            mobile_phone = 300,
            dissolver = 50,
            battery = 50,
            cutter = 100
        },
        locations = {
            {-169170.609375, -39257.78515625, 1149.6500244141},
            {128764.2890625, 77793.34375, 1577.6500244141}
        }
    }
}

local shopMenu

AddEvent("OnTranslationReady", function()
    shopMenu = Dialog.create("{shop_title}", nil, _("cancel"))
    Dialog.addSelect(shopMenu, 1, _("your_inventory"), 10)
    Dialog.addTextInput(shopMenu, 1, _("amount"))
    Dialog.setButtons(shopMenu, 1, _("sell"))
    Dialog.addSelect(shopMenu, 2, _("shop_inventory"), 10)
    Dialog.addTextInput(shopMenu, 2, _("amount"))
    Dialog.setButtons(shopMenu, 2, _("buy"))
end)

local lastStore

AddEvent("OnKeyPress", function(key)
    if key ~= "E" then
        return
    end
    local x, y, z = GetPlayerLocation()
    for i=1,#shops do
        for j=1,#shops[i].locations do
            if GetDistance3D(x , y, z, shops[i].locations[j][1], shops[i].locations[j][2], shops[i].locations[j][3]) < 150 then
                lastStore = shops[i].type
                Dialog.setVariable(shopMenu, "shop_title", _("shop_"..shops[i].type))
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

AddEvent("OnDialogSubmit", function(dialog, button, leftSelection, leftAmount, rightSelection, rightAmount)
    if dialog == shopMenu then
        if button == 1 then
            if leftSelection == "" then
                return
            end
            local amount = tonumber(leftAmount)
            if amount == nil then
                amount = 1
            end
            CallRemoteEvent("StoreSellItem", lastStore, leftSelection, amount)
        end
        if button == 2 then
            if rightSelection == "" then
                return
            end
            local amount = tonumber(rightAmount)
            if amount == nil then
                amount = 1
            end
            CallRemoteEvent("StoreBuyItem", lastStore, rightSelection, amount)
        end
    end
end)