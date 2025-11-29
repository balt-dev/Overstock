OVERSTOCK = SMODS.current_mod
assert(SMODS.current_mod.lovely, "Lovely patches were not loaded! Make sure your mod is in the right place.")

OVERSTOCK.mod_path = SMODS.current_mod.path .. ""

local function load_file(path, ...)
	local f, err = SMODS.load_file(path)
	if err then error(err) end
	return f(...)
end

function OVERSTOCK.load_module(mod)
	local f, err, path_prefix
	if OVERSTOCK.current_module == nil then
		path_prefix = ""
	else
		path_prefix = OVERSTOCK.current_module .. "/"
	end
	local old_mod = OVERSTOCK.current_module
	OVERSTOCK.current_module = (old_mod and (old_mod .. "/" .. mod)) or mod
	if NFS.getInfo(OVERSTOCK.mod_path .. "/" .. path_prefix .. mod .. "/mod.lua") ~= nil then
		print("[OVERSTOCK] Loading module " .. path_prefix .. mod .. "/mod.lua...")
		
		load_file(path_prefix .. mod .. "/mod.lua")
	else
		print("[OVERSTOCK] Loading module " .. path_prefix .. mod .. ".lua...")
		load_file(path_prefix .. mod .. ".lua")
	end
	OVERSTOCK.current_module = old_mod
	print("[OVERSTOCK] Loaded module " .. path_prefix .. mod)
end

OVERSTOCK.current_module = nil

OVERSTOCK.load_module "src"
