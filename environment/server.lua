AddEvent("OnPlayerJoin", function(player)
    local data = {}
    data["time"] = config["time"]
    data["time"]["serverTime"] = GetTimeSeconds()
    CallRemoteEvent(player, "OnEnvironmentExchange", data)
end)