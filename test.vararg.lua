local vararg = require"vararg"
--local vararg = require "table_pack"

local w = table.pack and table.pack(1, 2, nil, 3, nil, nil)
local x = vararg(1, 2, 3)
local y = vararg(1, 2, nil, 3, nil, nil)
local z = {1, 2, 3}

for i,v in vararg.next, y, nil do
	print("-", i, v)
end

print(table.pack and table.unpack(w) or "no table.pack")

assert(vararg.type(x))
print(x:unpack())

assert(vararg.type(y))
print(y:unpack())

assert(not vararg.type(z))

assert(y:unpack(4,4)==3)
assert(y:unpack(5,5)==nil)
