local select = assert(select)

local table_unpack = assert(table.unpack or _G.unpack)

local table_pack = table.pack
if table_pack == nil or table_pack(nil, nil).n ~= 2 then
	function table_pack(...)
		return {n=select("#", ...), ...}
	end
end

local function va_next(va, i)
	if i == nil then
		i = 1
	elseif type(i)=="number" and i < (va.n or #va) then
		i = i+1
	else
		return nil
	end
	return i, va[i]
end

local function va_ipairs(t, i)
	return va_next, t, i
end

local function va_unpack(self, i, j)
	return table_unpack(self, i or 1, j or self.n)
end

local vararg_mt = {}

vararg_mt.__len = function(self)
	return assert(self.n)
end
vararg_mt.__ipairs = va_ipairs

vararg_mt.__index = {
	unpack = assert(va_unpack),
}
local function va_pack(...)
	return setmetatable({n=select("#", ...), ...}, vararg_mt)
end


local function va_type(x)
	local x_mt = getmetatable(x)
	return x_mt and x_mt == vararg_mt and "vararg"
end

local M = {}
M.type   = va_type
M.pack   = va_pack
M.unpack = va_unpack
M.next   = va_next
M.ipairs = va_ipairs
setmetatable(M, {__call = function(_, ...) return va_pack(...) end})
return M
