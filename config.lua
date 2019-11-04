_ = _ or function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local function readFile(name)
    local fh = io.open(name, "r")
    if fh == nil then
        return nil
    end
    fh:close()
    local content = ""
    for line in io.lines(name) do
        content = content..line
    end
    return content
end

local function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then io.close(f) return true else return false end
end

local dbJson = ""
for line in io.lines("db.json") do
    dbJson = dbJson..line
end
local dbConfig = json_decode(dbJson)
db = mariadb_connect(dbConfig.host, dbConfig.username, dbConfig.password, dbConfig.database)

-- Default config values
config = {
    time = {
        mode = "realtime"
    }
}

if not file_exists("godfather.json") then
    fho, err = io.open("godfather.json", "w")
    if err then print(_("config_save_failed")); return; end
    fho:write(json_encode(config))
    fho:close()
else
    local configJson = ""
    for line in io.lines("godfather.json") do
        configJson = configJson..line
    end
    config = json_decode(configJson)
end

weapon_config = json_decode(readFile("weapons.json")).weapons