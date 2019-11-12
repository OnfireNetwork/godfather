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
        local players = GetAllPlayers()
        for i=1,#players do
            CallRemoteEvent(players[i], "TimeUpdate", data)
        end
    end, 60000)
end