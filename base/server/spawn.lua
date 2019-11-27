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
                role = mariadb_get_value_name(1, "role"),
                cash = mariadb_get_value_name_int(1, "cash"),
                balance = mariadb_get_value_name_int(1, "balance"),
                xp = mariadb_get_value_name_int(1, "xp"),
                payday = mariadb_get_value_name_int(1, "payday"),
                salary = mariadb_get_value_name_int(1, "salary"),
                first_join = false,
                phone_bill = mariadb_get_value_name_int(1, "phone_bill"),
                inventory = json_decode(mariadb_get_value_name(1, "inventory")),
                licenses = json_decode(mariadb_get_value_name(1, "licenses")),
                spawn = mariadb_get_value_name_int(1, "spawn"),
                job = mariadb_get_value_name(1, "job"),
                dead = false
            }
            SetPlayerWeapon(player, mariadb_get_value_name_int(1, "prim_weapon"), mariadb_get_value_name_int(1, "prim_ammo"), false, 2, true)
            SetPlayerWeapon(player, mariadb_get_value_name_int(1, "sec_weapon"), mariadb_get_value_name_int(1, "sec_ammo"), false, 3, true)
            SetPlayerPropertyValue(player, "cash", player_data[player].cash, true)
            SetPlayerPropertyValue(player, "balance", player_data[player].balance, true)
            SetPlayerPropertyValue(player, "inventory", player_data[player].inventory, true)
            SetPlayerPropertyValue(player, "licenses", player_data[player].licenses, true)
            SetPlayerPropertyValue(player, "job", player_data[player].job, true)
            CallEvent("OnPlayerDataReady", player, player_data[player])
        else
            mariadb_query(db, "INSERT INTO players (steam_id,name,inventory,licenses) VALUES ('"..steamId.."','"..GetPlayerName(player).."','{}','{}');", function()
                player_data[player] = {
                    db = mariadb_get_insert_id(),
                    steam = steamId,
                    name = GetPlayerName(player),
                    role = "PLAYER",
                    cash = 500,
                    balance = 4500,
                    xp = 0,
                    payday = 0,
                    salary = 0,
                    first_join = true,
                    phone_bill = 0,
                    inventory = {},
                    licenses = {},
                    spawn = 0,
                    job = "NONE",
                    dead = false
                }
                SetPlayerPropertyValue(player, "cash", player_data[player].cash, true)
                SetPlayerPropertyValue(player, "balance", player_data[player].balance, true)
                SetPlayerPropertyValue(player, "inventory", player_data[player].inventory, true)
                SetPlayerPropertyValue(player, "licenses", player_data[player].licenses, true)
                CallEvent("OnPlayerDataReady", player, player_data[player])
            end)
        end
    end)
end)

function SetPlayerCash(player, cash)
    if player_data[player] == nil then
        return
    end
    player_data[player].cash = cash
    SetPlayerPropertyValue(player, "cash", player_data[player].cash, true)
end

function GetPlayerCash(player)
    if player_data[player] == nil then
        return 0
    end
    return player_data[player].cash
end

function SetPlayerBalance(player, balance)
    if player_data[player] == nil then
        return
    end
    player_data[player].balance = balance
    SetPlayerPropertyValue(player, "balance", player_data[player].balance, true)
end

function GetPlayerBalance(player)
    if player_data[player] == nil then
        return 0
    end
    return player_data[player].balance
end

function GetPlayerIdByDbId(id)
    for k,v in pairs(player_data) do
        if v.db == id then
            return k
        end
    end
    return 0
end

local function updatePlayerList()
    local playerList = {}
    for k,v in pairs(player_data) do
        playerList[k] = {
            name = v.name
        }
    end
    local ids = GetAllPlayers()
    for i=1,#ids do
        SetPlayerPropertyValue(ids[i], "player_list", playerList, true)
    end
end

AddEvent("OnPlayerDataReady", function(player, data)
    updatePlayerList()
end)

function GFSavePlayerData(player)
    local primModel, primAmmo = GetPlayerWeapon(player)
    local secModel, secAmmo = GetPlayerWeapon(player)
    mariadb_query(db, "UPDATE players SET job='"..player_data[player].job.."',spawn='"..player_data[player].spawn.."',role='"..player_data[player].role.."',cash='"..player_data[player].cash.."',balance='"..player_data[player].balance.."',xp='"..player_data[player].xp.."',payday='"..player_data[player].payday.."',salary='"..player_data[player].salary.."',phone_bill='"..player_data[player].phone_bill.."',inventory='"..json_encode(player_data[player].inventory).."',licenses='"..json_encode(player_data[player].licenses).."',prim_weapon='"..primModel.."',prim_ammo='"..primAmmo.."',sec_weapon='"..secModel.."',sec_ammo='"..secAmmo.."' WHERE id='"..player_data[player].db.."';")
end

function IsPlayerAdmin(player)
    if player_data[player] == nil then
        return false
    end
    if player_data[player].role == "ADMIN" then
        return true
    end
    return false
end

AddEvent("OnPlayerQuit", function(player)
    if player_data[player] == nil then
        return
    end
    CallEvent("OnPlayerDataFinish", player)
    GFSavePlayerData(player)
    player_data[player] = nil
    updatePlayerList()
end)

CreateTimer(function()
    for i,v in pairs(player_data) do
        player_data[i].payday = player_data[i].payday + 1
        if player_data[i].payday == 60 then
            player_data[i].payday = 0
            player_data[i].xp = player_data[i].xp + 1
            AddPlayerChat(i, "-----------------------------------------------------------------------------")
            AddPlayerChat(i, "                                  ".._("payday"))
            AddPlayerChat(i, "-----------------------------------------------------------------------------")
            AddPlayerChat(i, "  ".._("payday_old_balance")..": "..player_data[i].balance.." ".._("currency_symbol"))
            player_data[i].balance = player_data[i].balance + player_data[i].salary - player_data[i].phone_bill
            SetPlayerPropertyValue(i, "balance", player_data[i].balance, true)
            AddPlayerChat(i, "  ".._("payday_salary")..": +"..player_data[i].salary.." ".._("currency_symbol"))
            AddPlayerChat(i, "  ".._("payday_phone_bill")..": -"..player_data[i].phone_bill.." ".._("currency_symbol"))
            AddPlayerChat(i, "  ".._("payday_new_balance")..": "..player_data[i].balance.." ".._("currency_symbol"))
            AddPlayerChat(i, "-----------------------------------------------------------------------------")
            player_data[i].salary = 0
            player_data[i].phone_bill = 0
        end
    end
end, 60000)

function GFIsPlayerDead(player)
    return player_data[player].dead
end

AddEvent("OnPlayerDamage", function(player, type, amount)
    if GFIsPlayerDead(player) then
        SetPlayerHealth(player, GetPlayerHealth(player)+amount)
        return
    end
    if amount >= GetPlayerHealth(player) then
        SetPlayerHealth(player, 100+amount)
        SetPlayerAnimation(player, "LAY13")
        player_data[player].dead = true
    end
end)