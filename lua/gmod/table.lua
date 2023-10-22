local tab = {}

function tab.Copy( t, lookup_table )
	if ( t == nil ) then return nil end

	local copy = {}
	setmetatable( copy, debug.getmetatable( t ) )
	for i, v in pairs( t ) do
		if ( type(v) ~= "table" ) then
			copy[ i ] = v
		else
			lookup_table = lookup_table or {}
			lookup_table[ t ] = copy
			if ( lookup_table[ v ] ) then
				copy[ i ] = lookup_table[ v ] -- we already copied this table. reuse the copy.
			else
				copy[ i ] = tab.Copy( v, lookup_table ) -- not yet copied. copy it.
			end
		end
	end
	return copy
end

function tab.HasValue( t, val )
	for k, v in pairs( t ) do
		if ( v == val ) then return true end
	end
	return false
end

do -- SortByMember
	local TableMemberSort = function(a, b, MemberName, bReverse)
		if type(a) ~= "table" then return not bReverse end
		if type(b) ~= "table" then return bReverse end
		if not a[MemberName] then return not bReverse end
		if not b[MemberName] then return bReverse end

		if type(a[MemberName]) == "string" then
			if ( bReverse ) then
				return a[MemberName]:lower() < b[MemberName]:lower()
			else
				return a[MemberName]:lower() > b[MemberName]:lower()
			end
		end

		if bReverse then
			return a[MemberName] < b[MemberName]
		else
			return a[MemberName] > b[MemberName]
		end
	end

	function tab.SortByMember(Table, MemberName, bAsc)
		table.sort(Table, function(a, b)
			return TableMemberSort(a, b, MemberName, bAsc or false)
		end)
	end
end

return tab
