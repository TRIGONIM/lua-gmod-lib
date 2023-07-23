local ok, req = pcall(require, "http_async")
if not ok then error("Missed dependency: https://github.com/TRIGONIM/lua-requests-async/ or copas") end

local http = {}

--- onSuccess(sBody, iSize, tHeaders, iHttpCode)
--- onFailure(sErrorString)
http.Fetch = function(url, onSuccess, onFailure, headers)
	return req.get(url, onSuccess, onFailure, headers)
end

--- onSuccess(sBody, iSize, tHeaders, iHttpCode)
--- onFailure(sErrorString)
http.Post = function(url, params, onSuccess, onFailure, headers)
	return req.post(url, params, onSuccess, onFailure, headers)
end

return http
