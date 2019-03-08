local select = assert(select)
local table_unpack = assert(table.unpack or _G.unpack)

-- varargs1 the complex one
local exposed_varargs_mt = {}
exposed_varargs_mt.__metatable=true

-- varargs2 the simple one
local exposed_simple_varargs_mt = {}
exposed_simple_varargs_mt.__metatable=true

-- varargs1
local varargs_mt = {}
varargs_mt.__newindex = function() error("readonly object", 2) end
varargs_mt.__len = function(self)
	return self[shadowkey]["#"]
end
varargs_mt.__metatable = exposed_varargs_mt
varargs_mt.__ipairs = nil -- TODO

-- varargs2
local simple_varargs_mt = {}
simple_varargs_mt.__newindex = varargs_mt.__newindex
simple_varargs_mt.__metatable = exposed_simple_varargs_mt

local shadowkey = {}
local function varargs_unpack(self, i, j)
	local shadow = self[shadowkey]
	return table_unpack(shadow.values, i or 1, j or shadow["#"])
end

local function mkproxy(...)
	local len = select("#", ...)
	if #{...} == len then
		-- varargs1
		return setmetatable({unpack=table_unpack, ...}, simple_varargs_mt)
	else
		-- varargs2
		local proxy = {
			unpack = assert(varargs_unpack),
			[shadowkey] = {["#"]=select("#", ...),values={...}},
		}
		return setmetatable(proxy, varargs_mt)
	end
end

local M = {}
M.type = function(x)
	local x_mt = getmetatable(x)
	return x_mt and ( x_mt == exposed_varargs_mt or x_mt == exposed_simple_varargs_mt ) and "vararg" or nil
end
setmetatable(M, {__call = function(_, ...) return mkproxy(...) end})
M.pack = mkproxy
M.unpack = function(x, i, j)
	assert(M.type(x))
	assert(x.unpack)
	return x:unpack(i,j)
end
return M
