--[[
#todo

- Find a more elegant way to set the path for storing data
- Support not only Linux but also Windows
- The optional support for an SQLite database, as in Garry's Mod.
]]

local cookie = {}

local tmppath = GG_COOKIE_DATADIR or "gmodlib"
os.execute("mkdir -p " .. tmppath)

function cookie.GetString(name, default)
	local f = io.open(tmppath .. "/" .. name .. ".txt", "r")
	if not f then return default end

	local result = f:read("*all")
	f:close()
	return result
end

function cookie.GetNumber(name, default)
	return tonumber( cookie.GetString(name) ) or default
end

function cookie.Set(name, value)
	local f = assert(io.open(tmppath .. "/" .. name .. ".txt", "w"))
	f:write(value)
	f:close()
end

function cookie.Delete(name)
	local ok, err = os.remove(tmppath .. "/" .. name .. ".txt")
	return ok, err
end

return cookie
