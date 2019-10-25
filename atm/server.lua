AddRemoteEvent("ATMDeposit", function(player, amount)
    if player_data[player] == nil then
        return
    end
    if player_data[player].cash >= amount then
        player_data[player].cash = player_data[player].cash - amount
        player_data[player].balance = player_data[player].balance + amount
        AddPlayerChat(player, "Deposit successful!")
        SetPlayerPropertyValue(player, "cash", player_data[player].cash, true)
        SetPlayerPropertyValue(player, "balance", player_data[player].balance, true)
    else
        AddPlayerChat(player, "You don't have that much cash!")
    end
end)

AddRemoteEvent("ATMWithdraw", function(player, amount)
    if player_data[player] == nil then
        return
    end
    if player_data[player].balance >= amount then
        player_data[player].balance = player_data[player].balance - amount
        player_data[player].cash = player_data[player].cash + amount
        AddPlayerChat(player, "Withdraw successful!")
        SetPlayerPropertyValue(player, "cash", player_data[player].cash, true)
        SetPlayerPropertyValue(player, "balance", player_data[player].balance, true)
    else
        AddPlayerChat(player, "You don't have that much balance!")
    end
end)