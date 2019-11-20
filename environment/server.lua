local data = config["time"]

AddEvent("OnPlayerJoin", function(player)
    if data["mode"] == "real" then
        data["server_time"] = GetTimeSeconds()
    end
    CallRemoteEvent(player, "TimeUpdate", data)
end)

if data["mode"] == "real" then
    CreateTimer(function()
        local data = config["time"]
        data["server_time"] = GetTimeSeconds()
        local players = GetAllPlayers()
        for i=1,#players do
            CallRemoteEvent(players[i], "TimeUpdate", data)
        end
    end, 60000)
end