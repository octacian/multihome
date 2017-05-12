-- multihome/init.lua

multihome = {}

local max = minetest.setting_get("multihome.max") or 5

---
--- API
---

-- [local function] Check attribute
local function check_attr(player)
  if not player:get_attribute("multihome") then
    player:set_attribute("multihome", minetest.serialize({}))
  end
end

-- [local function] Count homes
local function count_homes(list)
  local count = 0
  for _, h in pairs(list) do
    count = count + 1
  end
  return count
end

-- [function] Set home
function multihome.set(player, name)
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local pos   = vector.round(player:getpos())
  local homes = minetest.deserialize(player:get_attribute("multihome"))

  -- Check for space
  if count_homes(homes) >= max then
    return false, "Too many homes. Remove one with /multihome remove <name>"
  end

  homes[name] = pos
  player:set_attribute("multihome", minetest.serialize(homes))

  return true, "Set home \""..name.."\" to "..minetest.pos_to_string(pos)
end

-- [function] Remove home
function multihome.remove(player, name)
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local homes = minetest.deserialize(player:get_attribute("multihome"))
  if homes[name] then
    homes[name] = nil
    player:set_attribute("multihome", minetest.serialize(homes))
    return true, "Removed home \""..name.."\""
  else
    return false, "Home \""..name.."\" does not exist!"
  end
end

-- [function] Get home position
function multihome.get(player, name)
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local homes = minetest.deserialize(player:get_attribute("multihome"))
  return homes[name]
end

-- [function] List homes
function multihome.list(player)
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local homes = minetest.deserialize(player:get_attribute("multihome"))
  if homes then
    local list = "None"
    for name, h in pairs(homes) do
      if list == "None" then
        list = name.." "..minetest.pos_to_string(h)
      else
        list = list..", "..name.." "..minetest.pos_to_string(h)
      end
    end
    return true, "Your Homes ("..count_homes(homes).."/"..max.."): "..list
  end
end

-- [function] Go to home
function multihome.go(player, name)
  if type(player) == "string" then
    player = minetest.get_player_by_name(player)
  end

  local pos = multihome.get(player, name)
  if pos then
    player:setpos(pos)
    return true, "Teleported to home \""..name.."\""
  else
    local homes = minetest.deserialize(player:get_attribute("multihome"))
    if not homes then
      return false, "Set a home using /multihome set"
    else
      return false, "Invalid home \""..name.."\""
    end
  end
end

---
--- Registrations
---

-- [event] On join player
minetest.register_on_joinplayer(function(player)
  -- Check attributes
  check_attr(player)
end)

-- [privilege] Multihome
minetest.register_privilege("multihome", {
  description = "Can use /multihome",
  give_to_singleplayer = false,
})

-- [chatcommand] /multihome
minetest.register_chatcommand("multihome", {
  description = "Teleport you to a home point",
  params = "<action> <home name> | <set, del, go>, <home name>",
  privs = {multihome=true},
  func = function(name, params)
    local params = params:split(" ")

    if #params == 2 and params[1] == "set" then
      return multihome.set(name, params[2])
    elseif #params == 2 and params[1] == "del" then
      return multihome.remove(name, params[2])
    elseif #params == 2 and params[1] == "go" then
      return multihome.go(name, params[2])
    elseif params[1] == "list" then
      return multihome.list(name)
    else
      return false, "Invalid parameters (see /help multihome)"
    end
  end,
})
