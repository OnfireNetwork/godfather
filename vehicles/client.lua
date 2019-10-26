Dialog = Dialog or ImportPackage("dialogui")

local vehicleMenu = Dialog.create("Vehicle Menu", nil, "{lock}", "Park", "Unflip", "Cancel")
local lastVehicle = -1

local function OpenMenu(vehicle)
    lastVehicle = vehicle
    if GetVehiclePropertyValue(vehicle, "locked") then
        Dialog.setVariable(vehicleMenu, "lock", "Unlock")
    else
        Dialog.setVariable(vehicleMenu, "lock", "Lock")
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

AddEvent("OnDialogSubmit", function(dialog, button)
    if dialog == vehicleMenu then
        if button == 1 then
            CallRemoteEvent("VehicleMenuAction", "Lock", lastVehicle)
            return
        end
        if button == 2 then
            CallRemoteEvent("VehicleMenuAction", "Park", lastVehicle)
            return
        end
        if button == 3 then
            CallRemoteEvent("VehicleMenuAction", "Unflip", lastVehicle)
            return
        end
    end
end)

local function OnEnterExit(vehicle) return not GetVehiclePropertyValue(vehicle, "locked") end
AddEvent("OnPlayerStartEnterVehicle", OnEnterExit)
AddEvent("OnPlayerStartExitVehicle", OnEnterExit)