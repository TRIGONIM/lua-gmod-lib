local util = {}

-- json related
do
	local included, json = pcall(require, "cjson")

	function util.JSONToTable(js)
		if not included then error("Missed dependency: cjson") end

		local decoded, res = pcall(json.decode, js) -- nil if can't decode
		if not decoded then
			print( debug.traceback("can't decode json\n\t" .. res) )
			return nil
		end
		return res
	end

	local prettyjson = require("gmod.deps.prettyjson")
	function util.TableToJSON(t, bPretty)
		if not included then error("Missed dependency: cjson") end

		local json_str = json.encode(t)
		if not bPretty then return json_str end
		return prettyjson(json_str, "\n", "\t", " ")
	end
end

-- base64 related
do
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

	function util.Base64Encode(data)
		return ((data:gsub('.', function(x)
			local r,b='',x:byte()
			for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
			return r;
		end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c=0
			for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
			return b:sub(c+1,c+1)
		end)..({ '', '==', '=' })[#data%3+1])
	end

	function util.Base64Decode(data)
		data = string.gsub(data, '[^'..b..'=]', '')
		return (data:gsub('.', function(x)
			if (x == '=') then return '' end
			local r,f='',(b:find(x)-1)
			for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
			return r;
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then return '' end
			local c=0
			for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
			return string.char(c)
		end))
	end
end

local hash = require("gmod.deps.hash")
util.SHA256 = hash.SHA256
util.MD5    = hash.MD5

return util
