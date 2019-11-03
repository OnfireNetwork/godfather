AddRemoteEvent("ATMDeposit", function(player, amount)
    if player_data[player] == nil then
        return
    end
    if player_data[player].cash >= amount then
        player_data[player].cash = player_data[player].cash - amount
        player_data[player].balance = player_data[player].balance + amount
        AddPlayerChat(player, _("deposit_successful"))
        SetPlayerPropertyValue(player, "cash", player_data[player].cash, true)
        SetPlayerPropertyValue(player, "balance", player_data[player].balance, true)
    else
        AddPlayerChat(player, _("not_enough_cash"))
    end
end)

AddRemoteEvent("ATMWithdraw", function(player, amount)
    if player_data[player] == nil then
        return
    end
    if player_data[player].balance >= amount then
        player_data[player].balance = player_data[player].balance - amount
        player_data[player].cash = player_data[player].cash + amount
        AddPlayerChat(player, _("withdraw_successful"))
        SetPlayerPropertyValue(player, "cash", player_data[player].cash, true)
        SetPlayerPropertyValue(player, "balance", player_data[player].balance, true)
    else
        AddPlayerChat(player, _("not_enough_balance"))
    end
end)