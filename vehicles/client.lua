Dialog = Dialog or ImportPackage("dialogui")

local vehicleMenu = Dialog.create("Vehicle Menu", nil, "{refuel}", "{lock}", "{engine}", "Park", "Unflip", "Cancel")
local refuelMenu = Dialog.create("Vehicle Refuel Menu", nil, "Refuel", "Cancel")
Dialog.addTextInput(refuelMenu, "Liter")
local refuelConfirmMenu = Dialog.create("Vehicle Refuel Confirmation", "This will cost you {price}$ \n Are you sure?", "Yes", "No")

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
    if GetVehicleEngineState(vehicle) then
        Dialog.setVariable(vehicleMenu, "engine", "Turn engine off")
    else
        Dialog.setVariable(vehicleMenu, "engine", "Turn engine on")
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
    if foundGasStation == false then
        Dialog.setVariable(vehicleMenu, "refuel", "")
    end

    Dialog.show(vehicleMenu)
end

AddEvent("OnKeyPress", function(key)
    if key ~= "E" then
        return
    end
    if IsPlayerInVehicle() then
        OpenMenu(GetPlayerVehicle())
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
            Dialog.show(refuelMenu)
            return
        end
        if button == 2 then
            CallRemoteEvent("VehicleMenuAction", "Lock", lastVehicle)
            return
        end
        if button == 3 then
            CallRemoteEvent("VehicleMenuAction", "Engine", lastVehicle)
            return
        end
        if button == 4 then
            CallRemoteEvent("VehicleMenuAction", "Park", lastVehicle)
            return
        end
        if button == 5 then
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
                end
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
end)

local function OnEnterExit(vehicle) return not GetVehiclePropertyValue(vehicle, "locked") end
AddEvent("OnPlayerStartEnterVehicle", OnEnterExit)
AddEvent("OnPlayerStartExitVehicle", OnEnterExit)