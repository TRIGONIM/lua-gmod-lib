local de = {}

local Msg = require("gmod.globals").Msg

function de.Trace()
	local level = 1
	Msg("\nTrace:\n")

	while true do
		local info = debug.getinfo( level, "Sln" )
		if ( not info ) then break end

		if ( info.what ) == "C" then
			Msg( string.format( "\t%i: C function\t\"%s\"\n", level, info.name or "" ) ) -- or for lua 5.1
		else
			Msg( string.format( "\t%i: Line %d\t\"%s\"\t\t%s\n", level, info.currentline, info.name or "", info.short_src ) )
		end

		level = level + 1
	end

	Msg("\n")
end

return de
