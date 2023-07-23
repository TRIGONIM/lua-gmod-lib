local file = {}

-- #todo Support not only Linux but also Windows
function file.CreateDir(name)
	os.execute("mkdir -p " .. name)
end

function file.Write(path, content)
	local f = io.open(path, "w")
	if f then
		f:write(content)
		f:close()
	end
	return nil
end

function file.Append(path, content)
	local f = io.open(path, "a")
	if f then
		f:write(content)
		f:close()
	end
	return nil
end

function file.Read(path)
	local f = io.open(path, "r")
	if f then
		local content = f:read("*all")
		f:close()
		return content
	end
	return nil
end

return file
