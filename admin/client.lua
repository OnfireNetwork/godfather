Dialog = Dialog or ImportPackage("dialogui")
_ = _ or function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

Dialog.setGlobalTheme("flat")

local adminMenu
local teleportMenu
local teleportPlaceMenu
local teleportCoordsMenu
local teleportToPlayerMenu
local teleportPlayerMenu
local moneyMenu
local vehicleMenu
local weaponMenu

local teleportPlaces

AddEvent("OnTranslationReady", function()
    teleportPlaces = {
        {
            name = "Gas Station",
            x = 125773,
            y = 80246,
            z = 1645
        },
        {
            name = "Town",
            x = -182821,
            y = -41675,
            z = 1160
        },
        {
            name = "Prison",
            x = -167958,
            y = 78089,
            z = 1569
        },
        {
            name = "Airport",
            x = 168904.359375,
            y = -148973.796875,
            z = 1250.2750244141
        },
        {
            name = "Diner",
            x = 212405,
            y = 94489,
            z = 1340
        }
    }
    local teleportPlaceNames = {}
    for i=1,#teleportPlaces do
        table.insert(teleportPlaceNames, teleportPlaces[i].name)
    end
    table.insert(teleportPlaceNames, _("cancel"))
    
    local vehicleModels = {
        "Sedan (1)",
        "Sedan Onecolor (19)",
        "Taxi (2)",
        "Police (3)",
        "Rolls Royce (4)",
        "Saloon (5)",
        "Nascar (6)",
        "Pickup (7)",
        "Coupè (11)",
        "Rally (12)",
        "Ambulance (8)",
        "Truck (17)",
        "Truck Camo (18)",
        "Garbage Truck (9)",
        "Transporter (22)",
        "Transporter Camo (23)",
        "HUMVEE (21)",
        "Heavy (13)",
        "Heavy Camo (14)",
        "Heavy Rescue (15)",
        "Heavy Military (16)",
        "Helicopter (10)",
        "Helicopter Onecolor (20)"
    }
    
    local weaponModels = {
        "Fist (1)",
        "Deagle (2)",
        "M1911 (3)",
        "Glock (4)",
        "Beretta (5)",
        "Modern shotgun (6)",
        "Shotgun (7)",
        "MP5 (8)",
        "MAC10 (9)",
        "UMP45 (10)",
        "M16 (11)",
        "AK-47 (12)",
        "AK-47 Gold (13)",
        "G36 (14)",
        "VAL (15)",
        "AKS (16)",
        "FAL (17)",
        "MK16 (18)",
        "HK416 (19)",
        "AWP (20)"
    }
    
    adminMenu = Dialog.create("Admin", nil, _("teleport"), _("give_money"), _("give_weapon"), _("spawn_vehicle"), _("copy_position"), _("toggle_spectator"),_("cancel"))
    teleportMenu = Dialog.create(_("teleport"), nil, _('to_place'), _("to_coords"), _("to_player"), _("teleport_player"), _("teleport_all"), _("cancel"))
    teleportPlaceMenu = Dialog.create(_("places"), nil, table.unpack(teleportPlaceNames))
    teleportCoordsMenu = Dialog.create(_("coords"), nil, _("teleport"), _("cancel"))
    Dialog.addTextInput(teleportCoordsMenu, 1, "X")
    Dialog.addTextInput(teleportCoordsMenu, 1, "Y")
    Dialog.addTextInput(teleportCoordsMenu, 1, "Z")
    teleportToPlayerMenu = Dialog.create(_("players"), nil, _("teleport"), _("cancel"))
    Dialog.addSelect(teleportToPlayerMenu, 1, _("player"), 1)
    teleportPlayerMenu = Dialog.create(_("players"), nil, _("teleport"), _("cancel"))
    Dialog.addSelect(teleportPlayerMenu, 1, _("player"), 1)
    moneyMenu = Dialog.create(_("give_money"), nil, _("give_money"), _("cancel"))
    Dialog.addSelect(moneyMenu, 1, _("type"), 1, _("cash"), _("balance"))
    Dialog.addSelect(moneyMenu, 1, _("player"), 1)
    Dialog.addTextInput(moneyMenu, 1, _("amount"))
    vehicleMenu = Dialog.create(_("spawn_vehicle"), nil, _("spawn"), _("cancel"))
    Dialog.addSelect(vehicleMenu, 1, _("model"), 1, table.unpack(vehicleModels))
    Dialog.addTextInput(vehicleMenu, 1, _("license_plate"))
    Dialog.addCheckbox(vehicleMenu, 1, _("radio"))
    Dialog.addCheckbox(vehicleMenu, 1, "Nitro")
    weaponMenu = Dialog.create(_("give_weapon"), nil, _("give_money"), _("cancel"))
    Dialog.addSelect(weaponMenu, 1, _("player"), 1)
    Dialog.addSelect(weaponMenu, 1, _("weapon"), 1, table.unpack(weaponModels))
    Dialog.addSelect(weaponMenu, 1, _("slot"), 1, "1", "2", "3")
    Dialog.addTextInput(weaponMenu, 1, _("ammo"))
    Dialog.addCheckbox(weaponMenu, 1, _("equip"))
end)

local function makePlayerOptions(allowAll)
    local buttons = {}
    local playerList = GetPlayerPropertyValue(GetPlayerId(), "player_list")
    for k,v in pairs(playerList) do
        table.insert(buttons, v.name.." ("..k..")")
    end
    if allowAll == true then
        table.insert(buttons, _("all_players"))
    end
    return buttons
end

local function isDigit(letter)
    local digits = "0123456789"
    for i=1,#digits do
        if digits:sub(i,i) == letter then
            return true
        end
    end
    return false
end

local function parseOptionId(option)
    if option == _("all_players") then
        return 0
    end
    local pt = #option - 1
    local str = ""
    while pt > 0 do
        if not isDigit(option:sub(pt,pt)) then
            break
        end
        str = option:sub(pt,pt)..str
        pt = pt - 1
    end
    return tonumber(str)
end

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    if dialog == adminMenu then
        if button == 1 then
            Dialog.show(teleportMenu)
            return
        end
        if button == 2 then
            Dialog.setSelectOptions(moneyMenu, 1, 2, table.unpack(makePlayerOptions(true)))
            Dialog.show(moneyMenu)
            return
        end
        if button == 3 then
            Dialog.setSelectOptions(weaponMenu, 1, 1, table.unpack(makePlayerOptions(true)))
            Dialog.show(weaponMenu)
            return
        end
        if button == 4 then
            Dialog.show(vehicleMenu)
            return
        end
        if button == 5 then
            local x, y, z = GetPlayerLocation()
            CopyToClipboard(x..", "..y..", "..z)
            return
        end
        if button == 6 then
            CallRemoteEvent("AdminToggleSpec")
            return
        end
    end
    if dialog == teleportMenu then
        if button == 1 then
            Dialog.show(teleportPlaceMenu)
        end
        if button == 2 then
            Dialog.show(teleportCoordsMenu)
        end
        if button == 3 then
            Dialog.setSelectOptions(teleportToPlayerMenu, 1, 1, table.unpack(makePlayerOptions()))
            Dialog.show(teleportToPlayerMenu)
        end
        if button == 4 then
            Dialog.setSelectOptions(teleportPlayerMenu, 1, 1, table.unpack(makePlayerOptions()))
            Dialog.show(teleportPlayerMenu)
        end
        if button == 5 then
            CallRemoteEvent("AdminTeleportAll")
        end
        return
    end
    if dialog == teleportPlaceMenu then
        if button <= #teleportPlaces then
            CallRemoteEvent("AdminTeleport", GetPlayerId(), teleportPlaces[button].x, teleportPlaces[button].y, teleportPlaces[button].z)
        end
        return
    end
    if dialog == teleportCoordsMenu then
        if button == 1 then
            local args = {...}
            CallRemoteEvent("AdminTeleport", GetPlayerId(), tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
        end
        return
    end
    if dialog == teleportToPlayerMenu then
        if button == 1 then
            local args = {...}
            local id = parseOptionId(args[1])
            CallRemoteEvent("AdminTeleportPlayer", GetPlayerId(), id)
        end
        return
    end
    if dialog == teleportPlayerMenu then
        if button == 1 then
            local args = {...}
            local id = parseOptionId(args[1])
            CallRemoteEvent("AdminTeleportPlayer", id, GetPlayerId())
        end
        return
    end
    if dialog == moneyMenu then
        local args = {...}
        if button == 1 then
            CallRemoteEvent("AdminAddMoney", parseOptionId(args[2]), args[1], tonumber(args[3]))
        end
        return
    end
    if dialog == weaponMenu then
        local args = {...}
        if button == 1 then
            CallRemoteEvent("AdminGiveWeapon", parseOptionId(args[1]), parseOptionId(args[2]), tonumber(args[3]), tonumber(args[4]), args[5])
        end
        return
    end
    if dialog == vehicleMenu then
        local args = {...}
        if button == 1 then
            CallRemoteEvent("AdminSpawnVehicle", parseOptionId(args[1]), args[2], args[3] == 1, args[4] == 1)
        end
        return
    end
end)

AddRemoteEvent("OpenAdminMenu", function()
    Dialog.show(adminMenu)
end)