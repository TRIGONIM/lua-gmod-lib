--[[
-- To export everything as global functions, use this code:

local globals = require("gmod.globals")
for name, value in pairs(globals) do
	_G[name] = value
end
]]

local export = {}

function export.isnumber(v) return type(v) == "number"  end
function export.isbool(v)   return type(v) == "boolean" end
function export.istable(v)  return type(v) == "table"   end
function export.isstring(v) return type(v) == "string"  end


-- http.Fetch, http.Post in separate file
local ok, http = pcall(require, "http_async")
if not ok then
	function export.HTTP(tParams)
		print("Missing dependency: http_async (https://github.com/TRIGONIM/lua-requests-async)")
	end
else
	export.HTTP = http.request
end

return export
