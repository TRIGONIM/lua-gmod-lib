--[[
#todo

- Find a more elegant way to set the path for storing data
- The optional support for an SQLite database, as in Garry's Mod.
]]

local file = require("gmod.file")

local cookie = {}

---@diagnostic disable-next-line: undefined-global
local DATA_PATH = GG_COOKIE_DATADIR or "data"
file.CreateDir(DATA_PATH)

function cookie.GetString(name, default)
	local content = file.Read(DATA_PATH .. "/" .. name .. ".txt")
	return content or default
end

function cookie.GetNumber(name, default)
	return tonumber( cookie.GetString(name) ) or default
end

function cookie.Set(name, value)
	file.Write(DATA_PATH .. "/" .. name .. ".txt", value)
end

function cookie.Delete(name)
	local ok, err = os.remove(DATA_PATH .. "/" .. name .. ".txt")
	return ok, err
end

return cookie
