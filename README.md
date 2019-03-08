# lua-vararg

A simple way to pack/unpack variable arguments.
The main feature is to correctly deals with nil values.

```lua
local vararg = require "vararg"

local function pack(...)
	return {...}
end

print(table.unpack(pack(1, 2, nil, 3, nil)))		-- 1       2
print(vararg.unpack(vararg.pack(1, 2, nil, 3, nil)))	-- 1       2       nil     3       nil
print(vararg(1, 2, nil, 3, nil):unpack())		-- 1       2       nil     3       nil
```
