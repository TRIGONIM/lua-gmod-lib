local str = {}

local string_len = string.len
local string_sub = string.sub

do -- string.Split, Explode
	function str.ToTable(input)
		local tbl = {}
		local s = tostring(input)
		for i = 1, #s do
			tbl[i] = string.sub(s, i, i)
		end
		return tbl
	end

	local totable = str.ToTable
	local string_find = string.find

	function str.Explode(separator, str, withpattern)
		if ( separator == "" ) then return totable( str ) end
		if ( withpattern == nil ) then withpattern = false end

		local ret = {}
		local current_pos = 1

		for i = 1, string_len( str ) do
			local start_pos, end_pos = string_find( str, separator, current_pos, not withpattern )
			if ( not start_pos ) then break end
			ret[ i ] = string_sub( str, current_pos, start_pos - 1 )
			current_pos = end_pos + 1
		end

		ret[ #ret + 1 ] = string_sub( str, current_pos )

		return ret
	end

	function str.Split( s, delimiter )
		return str.Explode( delimiter, s )
	end
end

local pattern_escape_replacements = {
	["("] = "%(",
	[")"] = "%)",
	["."] = "%.",
	["%"] = "%%",
	["+"] = "%+",
	["-"] = "%-",
	["*"] = "%*",
	["?"] = "%?",
	["["] = "%[",
	["]"] = "%]",
	["^"] = "%^",
	["$"] = "%$",
	["\0"] = "%z"
}

function str.PatternSafe( str )
	return ( str:gsub( ".", pattern_escape_replacements ) )
end

function str.Trim( s, char )
	if ( char ) then char = str.PatternSafe(char) else char = "%s" end
	return string.match( s, "^" .. char .. "*(.-)" .. char .. "*$" ) or s
end

function str.Interpolate( s, lookuptable ) -- "Hello {name}", {name = "world"} -> "Hello world"
	return ( string.gsub( s, "{([_%a][_%w]*)}", lookuptable ) )
end

function str.Comma( number, s )
	local replace = s == nil and "%1,%2" or "%1" .. s .. "%2"

	if ( type( number ) == "number" ) then
		number = string.format( "%f", number )
		number = string.match( number, "^(.-)%.?0*$" ) -- Remove trailing zeros
	end

	local index = -1
	while index ~= 0 do number, index = string.gsub( number, "^(-?%d+)(%d%d%d)", replace ) end

	return number
end

function str.StartWith( String, Start )
	return string_sub( String, 1, string_len( Start ) ) == Start
end
str.StartsWith = str.StartWith

return str
