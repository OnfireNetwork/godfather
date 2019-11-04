Dialog = Dialog or ImportPackage("dialogui")

local itemNames = {
    firework = "Firework",
    phone_book = "Phone Book",
    traffic_exam = "Traffic Exam",
    air_traffic_exam = "Air Traffic Exam",
    wp_deagle = "Desert Eagle",
    wp_m1911 = "M1911",
    wp_glock17 = "Glock 17",
    wp_beretta = "Beretta",
    wp_m4 = "M4 Shotgun",
    wp_pumpgun = "Pumpgun",
    wp_mp5sd = "MP5 SD",
    wp_mac10 = "MAC 10",
    wp_ump45 = "UMP 45",
    wp_m16 = "M16",
    wp_ak47 = "AK47",
    wp_ak47_gold = "Golden AK47",
    wp_g36 = "G36",
    wp_val = "VAL",
    wp_aks = "AKS",
    wp_fal = "FAL",
    wp_mk16 = "MK16",
    wp_hk416 = "HK 416",
    wp_awp = "AWP",
    mag_rifle = "Rifle Magazine",
    mag_pistol = "Pistol Magazine",
    mobile_phone = "Mobile Phone"
}

local inventoryMenu
local giveMenu

local inventoryItems = {}
local giveItem = ""

local function makePlayerOptions()
    local buttons = {}
    local playerList = GetPlayerPropertyValue(GetPlayerId(), "player_list")
    local streamed = GetStreamedPlayers()
    local x, y, z = GetPlayerLocation()
    for i=1,#streamed do
        local oX, oY, oZ = GetPlayerLocation(streamed[i])
        if GetDistance3D(x, y, z, oX, oY, oZ) < 300 then
            table.insert(buttons, playerList[streamed[i]].name.." ("..streamed[i]..")")
        end
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

AddEvent("OnTranslationReady", function()
    inventoryMenu = Dialog.create(_("inventory"), nil, _("use"), _("give"), _("cancel"))
    Dialog.addSelect(inventoryMenu, 1, nil, 8)
    Dialog.setAutoClose(inventoryMenu, false)
    giveMenu = Dialog.create(_("give"), nil, _("give"), _("cancel"))
    Dialog.addSelect(giveMenu, 1, _("player"), 1)
    Dialog.addTextInput(giveMenu, 1, _("amount"))
end)

AddEvent("OnKeyPress", function(key)
    if key ~= "I" then
        return
    end
    local items = {}
    for k,v in pairs(GetPlayerPropertyValue(GetPlayerId(), "inventory")) do
        items[k] = itemNames[k].." ["..v.."]"
    end
    Dialog.setSelectLabeledOptions(inventoryMenu, 1, 1, items)
    Dialog.show(inventoryMenu)
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    local args = {...}
    if dialog == inventoryMenu then
        local item = args[1]
        if button == 1 then
            if item:len() == 0 then
                return
            end
            Dialog.close()
            if item == "phone_book" then
                AddPlayerChat("The phone book isn't implemented yet!")
                return
            end
            CallRemoteEvent("InventoryUseItem", item)
        end
        if button == 2 then
            if item:len() == 0 then
                return
            end
            giveItem = item
            local playerOpts = makePlayerOptions()
            if #playerOpts == 0 then
                AddPlayerChat("There are no players close to you!")
                return
            end
            Dialog.setSelectOptions(giveMenu, 1, 1, table.unpack(playerOpts))
            Dialog.show(giveMenu)
        end
        if button == 3 then
            Dialog.close()
        end
    end
    if dialog == giveMenu then
        if button == 1 then
            local target = parseOptionId(args[1])
            local amount = tonumber(args[2])
            if amount == nil then
                AddPlayerChat(_("invalid_amount"))
                return
            end
            CallRemoteEvent("InventoryGiveItem", target, giveItem, amount)
        end
    end
end)

AddRemoteEvent("SpawnFirework", function(model, x, y, z, rx, ry, rz)
    CreateFireworks(model, x, y, z, rx, ry, rz)
end)