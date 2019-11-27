local gchat = false

AddEvent("OnPlayerChat", function(player, message)
    message = GetPlayerName(player)..": "..message
    local prefix = GetPlayerPropertyValue(player, "chat_prefix")
    if prefix ~= nil then
        message = prefix.." "..message
    end
    for id,v in pairs(player_data) do
        if GetPlayerDimension(player) == GetPlayerDimension(id) then
            local pX, pY, pZ = GetPlayerLocation(player)
            local oX, oY, oZ = GetPlayerLocation(id)
            if GetDistance3D(pX, pY, pZ, oX, oY, oZ) < 4000 then
                AddPlayerChat(id, message)
            end
        end
    end
end)

AddCommand("g", function(player, ...)
    if not gchat then
        AddPlayerChat(player, _("global_chat_is_disabled"))
        return
    end
    local args = {...}
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message = message..args[i]
    end
    message = "[Global] "..GetPlayerName(player)..": "..message
    AddPlayerChatAll(message)
end)

AddCommand("toggleg", function(player)
    if not IsPlayerAdmin(player) then
        return
    end
    gchat = not gchat
    if gchat then
        AddPlayerChatAll(_("global_chat_enabled"))
    else
        AddPlayerChatAll(_("global_chat_disabled"))
    end
end)

AddCommand("support", function(player, ...)
    local args = {...}
    local message = ""
    if IsPlayerAdmin(player) then
        for i=2,#args do
            if i > 1 then
                message = message.." "
            end
            message = message..args[i]
        end
        AddPlayerChat(tonumber(args[1]), "[Support] Admin "..GetPlayerName(player).." (#"..player_data[player].id.."): "..message)
    else
        for i=1,#args do
            if i > 1 then
                message = message.." "
            end
            message = message..args[i]
        end
        for k,v in pairs(player_data) do
            if IsPlayerAdmin(k) then
                AddPlayerChat(k, "[Support] "..GetPlayerName(player).." ("..player..", #"..player_data[player].db.."): "..message)
            end
        end
    end
end)

AddCommand("broadcast", function(player, ...)
    if not IsPlayerAdmin(player) then
        return
    end
    local args = {...}
    local message = ""
    for i=1,#args do
        if i > 1 then
            message = message.." "
        end
        message = message..args[i]
    end
    AddPlayerChatAll("[Admin Broadcast] "..message)
end)

AddCommand("sms", function(player, ...)
    if player_data[player] == nil then
        return
    end
    if player_data[player].inventory.mobile_phone == nil then
        AddPlayerChat(player, _("sms_phone_required"))
        return
    end
    local args = {...}
    if #args < 2 then
        AddPlayerChat(player, "/sms <id> <message>")
        return
    end
    local target = GetPlayerIdByDbId(tonumber(args[1]))
    if target == 0 then
        AddPlayerChat(player, _("player_not_found"))
        return
    end
    local message = ""
    for i=2,#args do
        if i > 2 then
            message = message.." "
        end
        message = message..args[i]
    end
    AddPlayerChat(target, "[SMS] "..GetPlayerName(player)..": "..message)
    player_data[player].phone_bill = player_data[player].phone_bill + 30
end)

AddCommand("id", function(player)
    AddPlayerChat(player, "Your ID: "..player_data[player].db)
end)