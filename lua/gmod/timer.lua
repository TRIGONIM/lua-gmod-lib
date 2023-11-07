local ok, res = pcall(require, "copas.timer")
if not ok then error("Missed dependency: copas.timer") end

local timer = {}

local co_timer = res
co_timer.map = co_timer.map or {}

function timer.Create(name, delay, reps, callback)
	reps = math.floor(reps) -- float will cause an infinite loop

	if name and co_timer.map[name] then
		timer.Remove(name)
	end

	local t = co_timer.new({
		name      = name,
		delay     = delay,
		recurring = reps ~= 1, -- <=0 for inf loop (until got Removed)
		callback  = function(self)
			callback()
			reps = reps - 1
			if reps == 0 then
				self:cancel()
			end
		end,

		callback_orig = callback,
	})

	if name then -- skip timer.Simple
		co_timer.map[t.name] = t
	end

	return t
end

function timer.Simple(delay, callback)
	return timer.Create(nil, delay, 1, callback)
end

function timer.Adjust(identifier, delay, repetitions, func)
	local t = timer.Remove(identifier)
	if not t then return false end

	delay       = delay       or t.delay
	repetitions = repetitions or t.repetitions
	func        = func        or t.callback_orig

	return timer.Create(identifier, delay, repetitions, func)
end

function timer.Remove(name)
	local t = co_timer.map[name]
	if t then
		t:cancel()
		co_timer.map[name] = nil
		return t
	end
end

return timer
