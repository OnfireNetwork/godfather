local categoryMenu
local places

AddEvent("OnTranslationReady", function()
    places = {
        {
            name = "ATM's",
            menu = -1,
            places = {
                {
                    name = "ATM Gas Station",
                    x = 129146,
                    y = 77939,
                    z = 1576
                },
                {
                    name = "ATM Gun Store",
                    x = -181957,
                    y = -40253,
                    z = 1163
                }
            }
        },
        {
            name = "Shops",
            menu = -1,
            places = {
                {
                    name = "Gun Store",
                    x = -181944,
                    y = -40695,
                    z = 1163
                },
                {
                    name = "Car Dealer",
                    x = -189761,
                    y = -51442,
                    z = 1148
                },
                {
                    name = "Aircraft Dealer",
                    x = 146135,
                    y = -160287,
                    z = 1252
                }
            }
        }
    }
    categoryMenu = Dialog.create("GPS", nil, places[1].name, places[2].name, _("cancel"))
    for i=1,#places do
        local buttons = {}
        for j=1,#places[i].places do
            table.insert(buttons, places[i].places[j].name)
        end
        buttons[#buttons+1] = _("cancel")
        places[i].menu = Dialog.create(places[i].name, nil, table.unpack(buttons))
    end
end)

AddEvent("OnDialogSubmit", function(dialog, button)
    if dialog == categoryMenu then
        if places[button] ~= nil then
            Dialog.show(places[button].menu)
        end
        return
    end
    for i=1,#places do
        if dialog == places[i].menu then
            if places[i].places[button] ~= nil then
                SetWaypoint(1, "", 0, 0, 0)
                SetWaypoint(1, places[i].places[button].name, places[i].places[button].x, places[i].places[button].y, places[i].places[button].z)
            else
                Dialog.show(categoryMenu)
            end
            return
        end
    end
end)

AddRemoteEvent("OpenGPS", function()
    Dialog.show(categoryMenu)
end)

SetPostEffect("DepthOfField", "DepthBlurRadius", 0)

AddEvent("OnDialogUIReady", function()
    Dialog.setGlobalTheme("saitama")
end)