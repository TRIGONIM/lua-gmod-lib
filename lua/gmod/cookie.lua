--[[
#todo

- The optional support for an SQLite database, as in Garry's Mod.
]]

local file = require("gmod.file")

local cookie = {}

local DATA_PATH

function cookie.SetDataPath(path)
	DATA_PATH = path
	file.CreateDir(DATA_PATH)
end

function cookie.GetString(name, default)
	assert(DATA_PATH, "Use cookie.SetDataPath(path) first to set the path for storing data")
	local content = file.Read(DATA_PATH .. "/" .. name .. ".txt")
	return content or default
end

function cookie.GetNumber(name, default)
	return tonumber( cookie.GetString(name) ) or default
end

function cookie.Set(name, value)
	assert(DATA_PATH, "Use cookie.SetDataPath(path) first to set the path for storing data")
	file.Write(DATA_PATH .. "/" .. name .. ".txt", value)
end

function cookie.Delete(name)
	assert(DATA_PATH, "Use cookie.SetDataPath(path) first to set the path for storing data")
	file.Delete(DATA_PATH .. "/" .. name .. ".txt") -- ok, err
end

return cookie
