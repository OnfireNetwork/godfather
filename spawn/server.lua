player_data = {}

AddEvent("OnPlayerJoin", function(player)
    SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1645.000000, 90.0)
end)

AddEvent("OnPlayerSteamAuth", function(player)
    local steamId = tostring(GetPlayerSteamId(player))
    mariadb_query(db, "SELECT * FROM players WHERE steam_id='"..steamId.."';", function()
        if mariadb_get_row_count() > 0 then
            player_data[player] = {
                db = mariadb_get_value_name_int(1, "id"),
                steam = steamId,
                name = mariadb_get_value_name(1, "name"),
                cash = mariadb_get_value_name_int(1, "cash"),
                balance = mariadb_get_value_name_int(1, "balance"),
                first_join = false
            }
            SetPlayerPropertyValue(player, "cash", player_data[player].cash, true)
            SetPlayerPropertyValue(player, "balance", player_data[player].balance, true)
            CallEvent("OnPlayerDataReady", player, player_data[player])
        else
            mariadb_query(db, "INSERT INTO players (steam_id,name) VALUES ('"..steamId.."','"..GetPlayerName(player).."');", function()
                player_data[player] = {
                    db = mariadb_get_insert_id(),
                    steam = steamId,
                    name = GetPlayerName(player),
                    cash = 500,
                    balance = 4500,
                    first_join = true
                }
                SetPlayerPropertyValue(player, "cash", player_data[player].cash, true)
                SetPlayerPropertyValue(player, "balance", player_data[player].balance, true)
                CallEvent("OnPlayerDataReady", player, player_data[player])
            end)
        end
    end)
end)

AddEvent("OnPlayerQuit", function(player)
    if player_data[player] == nil then
        return
    end
    mariadb_query(db, "UPDATE players SET cash='"..player_data[player].cash.."',balance='"..player_data[player].balance.."' WHERE id='"..player_data[player].db.."';")
    player_data[player] = nil
end)