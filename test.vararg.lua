local vararg = require"vararg"

local x = vararg(1, 2, 3)
local y = vararg(1, 2, nil, 3, nil, nil)
local z = {1, 2, 3}

assert(vararg.type(x))
print(x:unpack())

assert(vararg.type(y))
print(y:unpack())

assert(not vararg.type(z))

assert(y:unpack(4,4)==3)
assert(y:unpack(5,5)==nil)
