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

AddCommand("toggleg", function(player, message)
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