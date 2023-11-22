local ma = {}

-- Round to the nearest integer
function ma.Round( num, idp )
	local mult = 10 ^ ( idp or 0 )
	return math.floor( num * mult + 0.5 ) / mult
end

function ma.Clamp( _in, low, high )
	return math.min( math.max( _in, low ), high )
end

return ma
