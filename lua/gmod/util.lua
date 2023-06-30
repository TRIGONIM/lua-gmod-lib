local ok, json = pcall(require, "cjson")
if not ok then error("Missed dependency: cjson") end

local util = {}

function util.JSONToTable(js)
	local ok, res = pcall(json.decode, js) -- nil if can't decode
	if not ok then
		print( debug.traceback("can't decode json\n\t" .. res) )
		return nil
	end
	return res
end

function util.TableToJSON(t)
	return json.encode(t)
end

return util
