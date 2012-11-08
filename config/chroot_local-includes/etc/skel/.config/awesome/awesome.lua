-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Scratchpad
require("teardrop")
-- shifty - dynamic tagging library
require("shifty")
--------------------------

-- useful for debugging, marks the beginning of rc.lua exec
print("Entered awesome.lua: " .. os.time())

-- Variables --
home       = os.getenv("HOME")
config_dir = awful.util.getdir("config")
scount = screen.count()

-- Configuration --
print("Entering config.lua: " .. os.time())
dofile(config_dir .."/config/config.lua")
-------------

-- Theme --
print("Entering theme.lua: " .. os.time())
dofile(config_dir .."/config/theme.lua")
-------------

-- Naughty configuration --
naughty.config.default_preset.font = "DroidSansMono 7"

-- Applications prefere --
print("Entering prefferedapps.lua: " .. os.time())
dofile(config_dir .."/config/prefferedapps.lua")
-------------

-- Modkeys --
print("Entering modkeys.lua: " .. os.time())
dofile(config_dir .."/config/modkeys.lua")
-------------

-- Tags --
print("Entering tags.lua: " .. os.time())
dofile(config_dir .."/config/tags.lua")
-------------

-- Menu --
print("Entering menu.lua: " .. os.time())
dofile(config_dir .."/config/menu.lua")
----------

print("Entering widgets.lua: " .. os.time())
-- Widgets definition and panels creation --
dofile(config_dir .."/config/widgets.lua")
----------

-- Mouse bindings --
print("Entering mouse.lua: " .. os.time())
dofile(config_dir .."/config/mouse.lua")
----------

-- Key bindings --
print("Entering keys.lua: " .. os.time())
dofile(config_dir .."/config/keys.lua")
----------

-- client signals --
print("Entering signals.lua: " .. os.time())
dofile(config_dir .."/config/signals.lua")
----------

-- client autorun --
print("Entering autorun.lua: " .. os.time())
dofile(config_dir .."/config/autorun.lua")
----------

-- useful for debugging, marks the beginning of rc.lua exec
print("Finish awesome.lua: " .. os.time())
