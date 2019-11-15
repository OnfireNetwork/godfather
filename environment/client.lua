AddRemoteEvent("TimeUpdate", function(data)
    -- add sync stuff
    local timeMode = data["mode"]
    if timeMode == nil then
        return
    end
    if timeMode == "real" then
        SetTime(data["server_time"] / 3600)
        return
    end
    if timeMode == "fixed" then
        SetTime(data["time"])
        return
    end
end)
