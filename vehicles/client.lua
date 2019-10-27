Dialog = Dialog or ImportPackage("dialogui")

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

local vehicleMenu = Dialog.create("Vehicle Menu", nil, "{lock}", "{engine}", "{refuel}", "{radio}", "Park", "Unflip", "Cancel")
local refuelMenu = Dialog.create("Refuel", nil, "Refuel", "Cancel")
Dialog.addTextInput(refuelMenu, 1, "Liter")
local refuelConfirmMenu = Dialog.create("Refuel Confirmation", "Refueling will cost you {price} $. Are you sure?", "Yes", "No")
local radioMenu = Dialog.create("Vehicle Radio", nil, "Set Station", "Cancel")
Dialog.addSelect(radioMenu, 1, "Station", 1, "None", "KIIS FM", "KOST FM")
Dialog.addSelect(radioMenu, 1, "Volume", 1, "100%", "75%", "50%", "25%", "10%")

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
        Dialog.setVariable(vehicleMenu, "lock", "Unlock")
    else
        Dialog.setVariable(vehicleMenu, "lock", "Lock")
    end
    if IsPlayerInVehicle() then
        if GetVehicleEngineState(vehicle) then
            Dialog.setVariable(vehicleMenu, "engine", "Turn engine off")
        else
            Dialog.setVariable(vehicleMenu, "engine", "Turn engine on")
        end
        if GetVehiclePropertyValue(vehicle, "radio") == true then
            Dialog.setVariable(vehicleMenu, "radio", "Radio")
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
            Dialog.setVariable(vehicleMenu, "refuel", "Refuel")
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
        if GetVehicleForwardSpeed(GetPlayerVehicle()) == 0 then
            OpenMenu(GetPlayerVehicle())
        end
    else
        local x, y, z = GetPlayerLocation()
        local vehicles = GetStreamedVehicles()
        local vehicle = nil
        local distance = 10000
        for i=1,#vehicles do
            local dist = GetDistance3D(x, y, z, GetVehicleLocation(vehicles[i]))
            if dist < 500 then
                if dist < distance then
                    vehicle = vehicles[i]
                    distance = dist
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
                        AddPlayerChat("You can't afford that!")
                    else
                        lastLiters = number
                        Dialog.setVariable(refuelConfirmMenu, "price", price)
                        Dialog.show(refuelConfirmMenu)
                    end
                else
                    AddPlayerChat("Your tank is too full!")
                end
            else
                AddPlayerChat("Invalid amount!")
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
            if args[1] == "None" then
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