local function isAdmin(player)
    return true
end

AddRemoteEvent("VehicleMenuAction", function(player, action, vehicle)
    if action == "Lock" then
        local owner = GetVehiclePropertyValue(vehicle, "owner")
        if owner == -1 then
            if not isAdmin(player) then
                AddPlayerChat(player, "This vehicle doesn't belong to you!")
                return
            end
        elseif owner == 0 then
            AddPlayerChat(player, "This vehicle has no lock!")
            return
        else
            if owner ~= player then
                AddPlayerChat(player, "This vehicle doesn't belong to you!")
                return
            end
        end
        SetVehiclePropertyValue(vehicle, "locked", not GetVehiclePropertyValue(vehicle, "locked"), true)
        if GetVehiclePropertyValue(vehicle, "locked") then
            AddPlayerChat(player, "The vehicle has been locked!")
        else
            AddPlayerChat(player, "The vehicle has been unlocked!")
        end
    end
    if action == "Park" then
        local owner = GetVehiclePropertyValue(vehicle, "owner")
        if owner < 1 then
            AddPlayerChat(player, "This vehicle can't be parked!")
            return
        else
            if owner ~= player then
                AddPlayerChat(player, "This vehicle doesn't belong to you!")
                return
            end
        end
        AddPlayerChat(player, "Parking isn't implemented yet!")
        return
    end
    if action == "Unflip" then
        if GetVehiclePropertyValue(vehicle, "locked") then
            AddPlayerChat(player, "You have to unlock the vehicle first!")
            return
        end
        local rx, ry, rz = GetVehicleRotation(vehicle)
		SetVehicleRotation(vehicle, 0.0, ry, 0.0)
        AddPlayerChat(player, "Vehicle has been unflipped!")
        return
    end
end)