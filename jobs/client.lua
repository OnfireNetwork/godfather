AddEvent("OnPlayerStartEnterVehicle", function(vehicle)
    if GetVehiclePropertyValue(vehicle, "owner") == 0 then
        if GetVehiclePropertyValue(vehicle, "garbage_bags") ~= nil then
            if GetPlayerPropertyValue(GetPlayerId(), "job") ~= "GARBAGE" then
                return false
            end
        end
        if GetVehiclePropertyValue(vehicle, "delivery_packages") ~= nil then
            if GetPlayerPropertyValue(GetPlayerId(), "job") ~= "DELIVERY" then
                return false
            end
        end
    end
end)