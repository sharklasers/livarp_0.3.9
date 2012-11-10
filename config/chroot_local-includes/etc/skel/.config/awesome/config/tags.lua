-- Window management layouts ---------
layouts = 
{
  awful.layout.suit.tile,        -- 1
  awful.layout.suit.tile.bottom, -- 2
  awful.layout.suit.fair,        -- 3
  awful.layout.suit.max,         -- 4
  awful.layout.suit.magnifier,   -- 5
  awful.layout.suit.floating     -- 6
}
--------------------------------------

-- Define if we want to use titlebar on all applications.
use_titlebar = false

-- Tags -----------------------------------------------------------------
-- Shifty configured tags.
shifty.config.tags = {
    ["w"]   = { position = 1,  init = true, layout = layouts[1]},
    ["e "]  = { position = 2,  init = true, layout = layouts[2]},
    ["s"]   = { position = 3,  init = true, layout = layouts[3]},
    ["o"]   = { position = 4,  init = true, layout = layouts[4]},
    ["m"]   = { position = 5,  init = true, layout = layouts[5]},
    ["e"]   = { position = 6,  init = true, layout = layouts[6]},
}


-- client rules --
dofile(config_dir .."/config/rules.lua")
----------

-- SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
    layout = awful.layout.suit.tile,
    ncol = 1,
    mwfact = 0.60,
    guess_name = true,
    guess_position = true,
}
--focus on client hovering
shifty.config.sloppy = true
--titlebar only on floating client
shifty.config.float_bars = false
--shifty.config.honorsizehints = false
