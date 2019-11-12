Dialog = Dialog or ImportPackage("dialogui")
_ = _ or function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local cardealers = {
    {}
}

local menu
local confirmMenu

local lastVehicle
local lastRadio

AddEvent("OnTranslationReady", function()
    local vehicleModels = {
        "Sedan (1) (1000$)",
        "Sedan Onecolor (19) (1000$)",
        "Taxi (2) (1000$)",
        "Police (3) (1000$)",
        "Rolls Royce (4) (1000$)",
        "Saloon (5) (1000$)",
        "Nascar (6) (1000$)",
        "Pickup (7) (1000$)",
        "Coupè (11) (1000$)",
        "Rally (12) (1000$)",
        "Ambulance (8) (1000$)",
        "Truck (17) (1000$)",
        "Truck Camo (18) (1000$)",
        "Garbage Truck (9) (1000$)",
        "Transporter (22) (1000$)",
        "Transporter Camo (23) (1000$)",
        "HUMVEE (21) (1000$)",
        "Heavy (13) (1000$)",
        "Heavy Camo (14) (1000$)",
        "Heavy Rescue (15) (1000$)",
        "Heavy Military (16) (1000$)",
        "Helicopter (10) (1000$)",
        "Helicopter Onecolor (20) (1000$)"
    }
    
    menu = Dialog.create("Cardealer", nil, "Buy vehicle", _("cancel"))
    Dialog.addSelect(menu, 1, _("model"), 1, table.unpack(vehicleModels))  
    Dialog.addCheckbox(menu, 1, _("radio"))
    confirmMenu = Dialog.create("Do you want to buy the car?", nil, _("yes"), _("no"))
end)

AddEvent("OnKeyPress", function(key)
    if key ~= "E" then
        return
    end
    local x, y, z = GetPlayerLocation()
    for i=1,#cardealers do
        if GetDistance3D(x, y, z, cardealers[i][1], cardealers[i][2], cardealers[i][3]) < 100 then
            Dialog.show(menu)
            return
        end
    end
end)

AddEvent("OnDialogSubmit", function(dialog, button, model, radio)
    if dialog == menu then
        if button == 1 then
            -- TODO: PARSE
            lastVehicle = car
            lastRadio = radio
            Dialog.show(confirmMenu)
        end
        return
    end
    if dialog == confirmMenu then
        if button == 1 then
            CallRemoteEvent("BuyVehicle", lastVehicle, lastRadio)
        end
    end
end)
