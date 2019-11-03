Dialog = Dialog or ImportPackage("dialogui")
_ = _ or function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local adminMenuOptions = {
    "Teleport",
    "Give Money",
    "Give Weapon",
    "Spawn Vehicle",
    "Cancel"
}
if CopyToClipboard ~= nil then
    adminMenuOptions = {
        "Teleport",
        "Give Money",
        "Give Weapon",
        "Spawn Vehicle",
        "Copy Position",
        "Cancel"
    }
end

local teleportPlaces = {
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
table.insert(teleportPlaceNames, "Cancel")

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

local adminMenu = Dialog.create("Admin", nil, table.unpack(adminMenuOptions))
local teleportMenu = Dialog.create("Teleport", nil, "To Place", "To Coords", "To Player", "Teleport Player", "Teleport All", "Cancel")
local teleportPlaceMenu = Dialog.create("Places", "Select a place to teleport to", table.unpack(teleportPlaceNames))
local teleportCoordsMenu = Dialog.create("Coords", "Enter coords to teleport to", "Teleport", "Cancel")
Dialog.addTextInput(teleportCoordsMenu, 1, "X")
Dialog.addTextInput(teleportCoordsMenu, 1, "Y")
Dialog.addTextInput(teleportCoordsMenu, 1, "Z")
local teleportToPlayerMenu = Dialog.create("Players", "Select a player to teleport to", "Teleport", "Cancel")
Dialog.addSelect(teleportToPlayerMenu, 1, "Player", 1)
local teleportPlayerMenu = Dialog.create("Players", "Select a player to teleport to you", "Teleport", "Cancel")
Dialog.addSelect(teleportPlayerMenu, 1, "Player", 1)
local moneyMenu = Dialog.create("Give Money", nil, "Give", "Cancel")
Dialog.addSelect(moneyMenu, 1, "Type", 1, "Cash", "Bank")
Dialog.addSelect(moneyMenu, 1, "Player", 1)
Dialog.addTextInput(moneyMenu, 1, "Amount")
local vehicleMenu = Dialog.create("Spawn Vehicle", nil, "Spawn", "Cancel")
Dialog.addSelect(vehicleMenu, 1, "Model", 1, table.unpack(vehicleModels))
Dialog.addTextInput(vehicleMenu, 1, "License Plate")
Dialog.addCheckbox(vehicleMenu, 1, "Radio")
Dialog.addCheckbox(vehicleMenu, 1, "Nitro")
local weaponMenu = Dialog.create("Give Weapon", nil, "Give", "Cancel")
Dialog.addSelect(weaponMenu, 1, "Player", 1)
Dialog.addSelect(weaponMenu, 1, "Weapon", 1, table.unpack(weaponModels))
Dialog.addSelect(weaponMenu, 1, "Slot", 1, "1", "2", "3")
Dialog.addTextInput(weaponMenu, 1, "Ammo")
Dialog.addCheckbox(weaponMenu, 1, "Equip")

local function makePlayerOptions(allowAll)
    local buttons = {}
    local playerList = GetPlayerPropertyValue(GetPlayerId(), "player_list")
    for k,v in pairs(playerList) do
        table.insert(buttons, v.name.." ("..k..")")
    end
    if allowAll == true then
        table.insert(buttons, "All Players")
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
    if option == "All Players" then
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
        local option = adminMenuOptions[button]
        if option == "Copy Position" then
            local x, y, z = GetPlayerLocation()
            CopyToClipboard(x..", "..y..", "..z)
            return
        end
        if option == "Teleport" then
            Dialog.show(teleportMenu)
            return
        end
        if option == "Give Money" then
            Dialog.setSelectOptions(moneyMenu, 1, 2, table.unpack(makePlayerOptions(true)))
            Dialog.show(moneyMenu)
            return
        end
        if option == "Give Weapon" then
            Dialog.setSelectOptions(weaponMenu, 1, 1, table.unpack(makePlayerOptions(true)))
            Dialog.show(weaponMenu)
            return
        end
        if option == "Spawn Vehicle" then
            Dialog.show(vehicleMenu)
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
            local id = parsePlayerOptionId(args[1])
            CallRemoteEvent("AdminTeleportPlayer", GetPlayerId(), id)
        end
        return
    end
    if dialog == teleportPlayerMenu then
        if button == 1 then
            local args = {...}
            local id = parsePlayerOptionId(args[1])
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