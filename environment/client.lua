AddRemoteEvent("OnEnvironmentExchange", function(data)
    -- add sync stuff
    local timeMode = data["time"]["mode"]
    if timeMode == nil then
        return
    end
    local serverTime = data["time"]["serverTime"]
    if timeMode == "realtime" then
        SetTime(serverTime / 3600)
        CreateTimer(function()
            serverTime = serverTime + 10
            if serverTime / 3600 > 24 then
                serverTime = 0
            end
            SetTime(serverTime / 3600)
        end, 10000)
        return
    end
end)