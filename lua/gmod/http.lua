local HTTP = require("gmod.globals").HTTP

local http = {}

--- onSuccess(sBody, iSize, tHeaders, iHttpCode)
--- onFailure(sErrorString)
http.Fetch = function(url, onSuccess, onFailure, headers)
	HTTP({
		url     = url,
		method  = "GET",
		success = onSuccess and function(c, r, h) onSuccess(r, #r, h, c) end,
		failed  = onFailure,
		headers = headers,
	})
end

--- onSuccess(sBody, iSize, tHeaders, iHttpCode)
--- onFailure(sErrorString)
http.Post = function(url, params, onSuccess, onFailure, headers)
	HTTP({
		url        = url,
		method     = "POST", -- post with parameters sends body as form-urlencoded
		parameters = params,
		success    = onSuccess and function(c, r, h) onSuccess(r, #r, h, c) end,
		failed     = onFailure,
		headers    = headers,
	})
end

return http
