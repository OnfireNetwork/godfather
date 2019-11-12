AddRemoteEvent("TimeUpdate", function(data)
    -- add sync stuff
    local timeMode = data["time"]["mode"]
    if timeMode == nil then
        return
    end
    if timeMode == "real" then
        SetTime(data["time"]["server_time"] / 3600)
        return
    end
    if timeMode == "fixed" then
        SetTime(data["time"]["time"])
        return
    end
end)