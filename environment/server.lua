AddEvent("OnPlayerJoin", function(player)
    local data = config["time"]
    if data["time"]["mode"] == "real" then
        data["time"]["server_time"] = GetTimeSeconds()
    end
    CallRemoteEvent(player, "TimeUpdate", data)
end)

if data["time"]["mode"] == "real" then
    CreateTimer(function()
        local data = config["time"]
        data["time"]["server_time"] = GetTimeSeconds()
        CallRemoteEvent(player, "TimeUpdate", data)
    end, 60000)
end