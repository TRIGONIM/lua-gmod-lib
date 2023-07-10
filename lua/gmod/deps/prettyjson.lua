-- https://github.com/bungle/lua-resty-prettycjson/blob/master/lib/resty/prettycjson.lua

local cat = table.concat
local sub = string.sub
local rep = string.rep

local pretty_json = function(json_str, newline, indent, spacing)
	newline, indent, spacing = newline or "\n", indent or "\t", spacing or " "
	local i, j, k, n, r, p, q  = 1, 0, 0, #json_str, {}, nil, nil
	local al = sub(spacing, -1) == "\n"
	for x = 1, n do
		local c = sub(json_str, x, x)
		if not q and (c == "{" or c == "[") then
			r[i] = p == ":" and cat{ c, newline } or cat{ rep(indent, j), c, newline }
			j = j + 1
		elseif not q and (c == "}" or c == "]") then
			j = j - 1
			if p == "{" or p == "[" then
				i = i - 1
				r[i] = cat{ rep(indent, j), p, c }
			else
				r[i] = cat{ newline, rep(indent, j), c }
			end
		elseif not q and c == "," then
			r[i] = cat{ c, newline }
			k = -1
		elseif not q and c == ":" then
			r[i] = cat{ c, spacing }
			if al then
				i = i + 1
				r[i] = rep(indent, j)
			end
		else
			if c == '"' and p ~= "\\" then
				q = not q and true or nil
			end
			if j ~= k then
				r[i] = rep(indent, j)
				i, k = i + 1, j
			end
			r[i] = c
		end
		p, i = c, i + 1
	end
	return cat(r)
end

-- local ok, cjson = pcall(require, "cjson.safe")
-- local pretty_cjson = function(arr, newline, indent, spacing)
-- 	local json_str, e = cjson.encode(arr)
-- 	if not json_str then return json_str, e end
-- 	return pretty_json(json_str, newline, indent, spacing)
-- end

return pretty_json
