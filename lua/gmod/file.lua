local file = {}

function file.Write(path, content)
	local f = assert(io.open(path, "w"))
	f:write(content)
	f:close()
end

function file.Append(path, content)
	local f = assert(io.open(path, "a"))
	f:write(content)
	f:close()
end

function file.Read(path)
	local f = assert(io.open(path, "r"))
	local content = f:read("*all")
	f:close()
	return content
end

return file
