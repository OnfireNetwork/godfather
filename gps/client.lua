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
                    name = "Hardware Store",
                    x = -168889.1875,
                    y = -41391.2578125,
                    z = 1146.94921875
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
        },
        {
            name = "Jobs",
            menu = -1,
            places = {
                {
                    name = "Forest (Woodcutting)",
                    x = -222532,
                    y = -70046,
                    z = 850
                },
                {
                    name = "Sawmill (Woodcutting)",
                    x = -193169,
                    y = -34121,
                    z = 1148
                },
                {
                    name = "Drug Camp",
                    x = 197947.21875,
                    y = 56014.87890625,
                    z = 1408.3077392578
                },
                {
                    name = "Ephedra Plants (Methcooking)",
                    x = 166593.921875,
                    y = 140630.359375,
                    z = 7604.8002929688
                },
                {
                    name = "Coca Field (Cocainecooking)",
                    x = 84737.2890625,
                    y = 128046.6875,
                    z = 5133.4516601563
                }
            }
        }
    }
    categoryMenu = Dialog.create("GPS", nil, places[1].name, places[2].name, places[3].name, _("cancel"))
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