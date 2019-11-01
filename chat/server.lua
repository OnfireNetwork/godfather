local gchat = false

local function isAdmin(player)
    return true
end

AddEvent("OnPlayerChat", function(player, message)
    message = GetPlayerName(player).." said: "..message
    local prefix = GetPlayerPropertyValue(player, "chat_prefix")
    if prefix ~= nil then
        message = prefix.." "..message
    end
    for id,v in pairs(player_data) do
        if GetPlayerDimension(player) == GetPlayerDimension(id) then
            if GetDistance3D(GetPlayerLocation(player), GetPlayerLocation(id)) < 4000 then
                AddPlayerChat(id, message)
            end
        end
    end
end)

AddCommand("g", function(player, ...)
    if not gchat then
        AddPlayerChat(player, "The global chat is deactivated!")
        return
    end
    local args = {...}
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message..args[i]
    end
    message = "[Global] "..GetPlayerName(player)..": "..message
    AddPlayerChatAll(message)
end)

AddCommand("toggleg", function(player)
    if not isAdmin(player) then
        return
    end
    gchat = not gchat
    if gchat then
        AddPlayerChatAll("The global chat has been enabled!")
    else
        AddPlayerChatAll("The global chat has been disabled!")
    end
end)

AddCommand("support", function(player, ...)
    local args = {...}
    local message = ""
    if isAdmin(player) then
        for i=2,#args do
            if i > 1 then
                message = message.." "
            end
            message..args[i]
        end
        AddPlayerChat(tonumber(args[1]), "[Support] Admin "..GetPlayerName(player).." (#"..player_data[player].id.."): "..message)
    else
        for i=1,#args do
            if i > 1 then
                message = message.." "
            end
            message..args[i]
        end
        for k,v in pairs(player_data) do
            if isAdmin(k) then
                AddPlayerChat(k, "[Support] "..GetPlayerName(player).." ("..player..", #"..player_data[player].db.."): "..message)
            end
        end
    end
end)

AddCommand("broadcast", function(player, ...)
    if not isAdmin(player) then
        return
    end
    local args = {...}
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message..args[i]
    end
    AddPlayerChatAll("[Admin Broadcast] "..message)
end)

