Dialog = Dialog or ImportPackage("dialogui")
_ = _ or function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local radioStations = {
    {
        name = "KIIS FM",
        url = "http://c2icyelb.prod.playlists.ihrhls.com/185_icy"
    },
    {
        name = "KOST FM",
        url = "http://c8icyelb.prod.playlists.ihrhls.com/193_icy"
    }
}

local vehicleMenu
local refuelMenu
local refuelConfirmMenu
local radioMenu

AddEvent("OnTranslationReady", function()
    vehicleMenu = Dialog.create(_("vehicle_menu"), nil, "{lock}", "{engine}", "{refuel}", "{radio}", _("park"), _("unflip"), _("cancel"))
    refuelMenu = Dialog.create(_("refuel"), nil, _("refuel"), _("cancel"))
    Dialog.addTextInput(refuelMenu, 1, _("fuel_unit"))
    refuelConfirmMenu = Dialog.create(_("refuel_confirmation"), _("refuel_confirmation_text", _("currency_symbol")), _("yes"), _("no"))
    radioMenu = Dialog.create(_("vehicle_radio"), nil, _("radio_set_station"), _("cancel"))
    Dialog.addSelect(radioMenu, 1, _("radio_station"), 1, _("radio_station_none"), "KIIS FM", "KOST FM")
    Dialog.addSelect(radioMenu, 1, _("radio_volume"), 1, "100%", "75%", "50%", "25%", "10%")
end)

local radioSound = -1
local radioStation = 0

local lastVehicle = -1
local lastLiters = -1

local gasStations = {
    {126868, 78415, 1775, 750}
}

local function calcPrice(liter)
    return liter * 1.67
end

local function OpenMenu(vehicle)
    lastVehicle = vehicle
    if GetVehiclePropertyValue(vehicle, "locked") then
        Dialog.setVariable(vehicleMenu, "lock", _("unlock"))
    else
        Dialog.setVariable(vehicleMenu, "lock", _("lock"))
    end
    if IsPlayerInVehicle() then
        if GetVehicleEngineState(vehicle) then
            Dialog.setVariable(vehicleMenu, "engine", _("turn_off_engine"))
        else
            Dialog.setVariable(vehicleMenu, "engine", _("turn_on_engine"))
        end
        if GetVehiclePropertyValue(vehicle, "radio") == true then
            Dialog.setVariable(vehicleMenu, "radio", _("radio"))
        else
            Dialog.setVariable(vehicleMenu, "radio", "")
        end
    else
        Dialog.setVariable(vehicleMenu, "engine", "")
        Dialog.setVariable(vehicleMenu, "radio", "")
    end
    local x, y, z = GetPlayerLocation()
    local foundGasStation = false
    for i=1,#gasStations do
        if GetDistance3D(x, y, z, gasStations[i][1], gasStations[i][2], gasStations[i][3]) < gasStations[i][4] then
            Dialog.setVariable(vehicleMenu, "refuel", _("refuel"))
            foundGasStation = true
            break
        end
    end
    if not foundGasStation then
        Dialog.setVariable(vehicleMenu, "refuel", "")
    end
    Dialog.show(vehicleMenu)
end

AddEvent("OnKeyPress", function(key)
    if key ~= "E" then
        return
    end
    if IsPlayerInVehicle() then
        if GetVehicleForwardSpeed(GetPlayerVehicle()) < 3 then
            OpenMenu(GetPlayerVehicle())
        end
    else
        local x, y, z = GetPlayerLocation()
        local vehicles = GetStreamedVehicles()
        local vehicle = nil
        local distance = 10000
        for i=1,#vehicles do
            if not GetVehiclePropertyValue(vehicles[i], "dummy") then
                local dist = GetDistance3D(x, y, z, GetVehicleLocation(vehicles[i]))
                if dist < 500 then
                    if dist < distance then
                        vehicle = vehicles[i]
                        distance = dist
                    end
                end
            end
        end
        if vehicle ~= nil then
            OpenMenu(vehicle)
        end
    end
end)

AddEvent("OnDialogSubmit", function(dialog, button, ...)
    if dialog == vehicleMenu then
        if button == 1 then
            CallRemoteEvent("VehicleMenuAction", "Lock", lastVehicle)
            return
        end
        if button == 2 then
            CallRemoteEvent("VehicleMenuAction", "Engine", lastVehicle)
            return
        end
        if button == 3 then
            Dialog.show(refuelMenu)
            return
        end
        if button == 4 then
            Dialog.show(radioMenu)
            return
        end
        if button == 5 then
            CallRemoteEvent("VehicleMenuAction", "Park", lastVehicle)
            return
        end
        if button == 6 then
            CallRemoteEvent("VehicleMenuAction", "Unflip", lastVehicle)
            return
        end
        return
    end
    if dialog == refuelMenu then
        if button == 1 then
            local args = {...}
            local number = tonumber(args[1])
            if number ~= nil then
                if number <= 100 - GetVehiclePropertyValue(lastVehicle, "fuel")  then
                    local price = calcPrice(number)
                    if price > GetPlayerPropertyValue(GetPlayerId(), "cash") then
                        AddPlayerChat(_("not_enough_cash"))
                    else
                        lastLiters = number
                        Dialog.setVariable(refuelConfirmMenu, "price", price)
                        Dialog.show(refuelConfirmMenu)
                    end
                end
            else
                AddPlayerChat(_("invalid_amount"))
            end
        end
        return
    end
    if dialog == refuelConfirmMenu then
        if button == 1 then
            CallRemoteEvent("VehicleRefuel", lastVehicle, lastLiters)
        end
        return
    end
    if dialog == radioMenu then
        if button == 1 then
            local args = {...}
            local vol = tonumber(args[2]:sub(1,#args[2]-1))/100
            if args[1] == _("radio_station_none") then
                CallRemoteEvent("VehicleRadioStation", lastVehicle, 0, 0)
            else
                for i=1,#radioStations do
                    if radioStations[i].name == args[1] then
                        CallRemoteEvent("VehicleRadioStation", lastVehicle, i, vol)
                    end
                end
            end
        end
    end
end)

local function VehicleRadioUpdate()
    if not IsPlayerInVehicle() then
        if radioSound ~= -1 then
            DestroySound(radioSound)
        end
        radioSound = -1
        radioStation = 0
        return
    end
    local vehicle = GetPlayerVehicle()
    local station = GetVehiclePropertyValue(vehicle, "radio_station")
    if station ~= radioStation then
        if radioSound ~= -1 then
            DestroySound(radioSound)
            radioSound = -1
            radioStation = 0
        end
        if radioStations[station] ~= nil then
            radioSound = CreateSound(radioStations[station].url)
        end
        radioStation = station
    end
    if radioSound ~= -1 then
        SetSoundVolume(radioSound, GetVehiclePropertyValue(vehicle, "radio_volume") * 0.5)
    end
end

AddEvent("OnPlayerStartEnterVehicle", function(vehicle)
    local locked = GetVehiclePropertyValue(vehicle, "locked")
    if not locked then
        Delay(500, VehicleRadioUpdate)
    end
    return not locked
end)

AddEvent("OnPlayerStartExitVehicle", function(vehicle)
    local locked = GetVehiclePropertyValue(vehicle, "locked")
    if not locked then
        Delay(500, VehicleRadioUpdate)
    end
    return not locked
end)
AddRemoteEvent("VehicleRadioUpdate", VehicleRadioUpdate)