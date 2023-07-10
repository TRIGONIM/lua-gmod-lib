--[[
-- To export everything as global functions, use this code:

local globals = require("gmod.globals")
for name, value in pairs(globals) do
	_G[name] = value
end
]]

-- package.path = string.format("../?.lua;%s", package.path)

local ma = require("gmod.math")

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

function export.Color(r, g, b, a)
	return {r = r or 255, g = g or 255, b = b or 255, a = a or 255}
end

do -- Msg, MsgN, MsgC
	export.Msg = io.write

	local Msg = export.Msg
	function export.MsgN(...)
		return Msg(..., "\n")
	end

	-- https://stackoverflow.com/questions/15682537/ansi-color-specific-rgb-sequence-bash?answertab=votes#tab-top
	local rgbToAnsi256 = function(r, g, b)
		if (r == g) and (g == b) then
			if (r < 8)   then return 16  end
			if (r > 248) then return 231 end
			return ma.Round(((r - 8) / 247) * 24) + 232
		end

		return 16 + (36 * ma.Round(r / 255 * 5)) + (6 * ma.Round(g / 255 * 5)) + ma.Round(b / 255 * 5)
	end

	local colorClearSequence = '\27[0m'
	function export.MsgC(...)
		local outText = colorClearSequence

		for _, v in ipairs({...}) do
			if type(v) == "table" and v.r and v.g and v.b then
				local code = rgbToAnsi256(v.r, v.g, v.b)
				outText = outText .. '\27[38;5;' .. string.match(code, "(%d*)%.?%d*") .. 'm' -- match убирает мантиссу. В гмоде ее нет, а в pure lua чет есть
			else -- str, int, just append
				outText = outText .. v
			end
		end

		io.write(outText .. colorClearSequence)
	end
	-- local col = export.Color export.MsgC(col(255, 0, 0), "foo", col(0, 255, 0), "bar", col(0, 0, 255), "baz")
end

do -- PrintTable
	local function GetTextSize(x) return x:len(), 1 end

	local function FixTabs(x, width)
		local curw = GetTextSize(x)
		local ret = ""
		while (curw < width) do -- not using string.rep since linux
			x    = x .. " "
			ret  = ret .. " "
			curw = GetTextSize(x)
		end
		return ret
	end

	local replacements = {
		["\n"] = "\\n", ["\r"] = "\\r",
		["\v"] = "\\v", ["\f"] = "\\f",
		["\x00"] = "\\x00", ["\\"] = "\\\\", ["\""] = "\\\"",
	}

	local typesmap = {
		boolean = true, ["function"] = true,
		number = true, string = true,
		table = true, func = true,
	}

	local function DebugFixToString(obj)
		local typ = type(obj)
		if typ == "string" then
			return "\"" .. obj:gsub(".", replacements) .. "\""
		end

		if typesmap[typ] then
			return tostring(obj)
		end

		return "(" .. typ .. ") " .. tostring(obj)
	end

	local MsgC, MsgN = export.MsgC, export.MsgN
	function export.PrintTable(tbl, spaces, done)
		spaces = spaces or 0
		done = done or {}

		local buffer = {}
		local rbuf = {}
		local maxwidth = 0

		done[tbl] = true
		for key,val in pairs(tbl) do
			rbuf[#rbuf + 1]  = key
			buffer[#buffer + 1] = "[" .. DebugFixToString(key) .. "] "
			maxwidth = math.max(GetTextSize(buffer[#buffer]), maxwidth)
		end
		local str = string.rep(" ", spaces)
		if (spaces == 0) then MsgN("\n") end
		MsgC("{\n")
		local tabbed = str .. string.rep(" ", 4)

		for i = 1, #buffer do
			local key = rbuf[i]
			local value = tbl[key]
			MsgC(tabbed .. "[")
			MsgC( DebugFixToString(key) )
			MsgC("] " .. FixTabs(buffer[i], maxwidth), "= ")
			if (type(value) == "table" and not done[value]) then
				export.PrintTable(tbl[key], spaces + 4, done)
			else
				MsgC( DebugFixToString(value) )
			end
			MsgC(",")
			MsgN("")
		end
		MsgC(str .. "}")
		if (spaces == 0) then
			MsgN("")
		end
	end
end

return export
