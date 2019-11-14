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

SetOceanWaterLevel(1600, false)
SetOceanColor(RGBA(0,0,0,255), RGBA(0,0,0,255), RGBA(0,0,0,255), RGBA(0,0,0,255), RGBA(0,0,0,255))