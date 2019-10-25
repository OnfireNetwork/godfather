local dbJson = ""
for line in io.lines("db.json") do
    dbJson = dbJson..line
end
local dbConfig = json_decode(dbJson)
db = mariadb_connect(dbConfig.host, dbConfig.username, dbConfig.password, dbConfig.database)