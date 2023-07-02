local str = {}

do -- string.Split, Explode
	local string_len = string.len
	local string_sub = string.sub

	function str.ToTable( str )
		local tbl = {}

		for i = 1, string_len( str ) do
			tbl[i] = string_sub( str, i, i )
		end

		return tbl
	end

	local totable = str.ToTable
	local string_find = string.find

	function string.Explode(separator, str, withpattern)
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

	function str.Split( str, delimiter )
		return str.Explode( delimiter, str )
	end
end

return str
