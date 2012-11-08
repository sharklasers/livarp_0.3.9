----------------------------
-- "livarp" Awesome theme --
------ Basé sur fiesta -----
----------------------------

-- Principal -----------------------------------------------------------
theme = {}
--theme.wallpaper_cmd = { "nitrogen --restore" }
theme.wallpaper_cmd = { "feh --bg-scale ".. os.getenv("HOME") .."/.config/awesome/current_wallpaper" }

--only for my xephyr test
--theme.wallpaper_cmd = { "feh --bg-scale /home/aphelion/tmp/testxephyr/current_wallpaper" }
------------------------------------------------------------------------

-- Name ----------------------------------------------------------------
theme.path = os.getenv("HOME").."/.config/awesome/themes/livarp"

--only for my xephyr test
--theme.path = "/home/aphelion/tmp/testxephyr/themes/livarp"
------------------------------------------------------------------------

-- Police --------------------------------------------------------------
theme.font      = "Droid Sans 9"
------------------------------------------------------------------------

-- Couleurs ------------------------------------------------------------
theme.fg_normal = "#76A3B4" -- blue
theme.fg_focus  = "#222222" -- dark grey
theme.fg_urgent = "#1A1A1A" -- black grey
theme.bg_normal = "#222222"
theme.bg_focus  = "#76A3B4"
theme.bg_urgent = "#FFA000" -- orange
------------------------------------------------------------------------

-- {{{ Font colors for naughty popups
-- colors
green="#7fb219"
cyan="#7f4de6"
red="#e04613"                             
lblue="#6c9eab"                        
dblue="#00ccff"
black="#000000"
lgrey="#d2d2d2"
dgrey="#333333"
white="#ffffff"

alpha="dd"

theme.notify_font= "DroidSansMono 7"
theme.notify_font_color_1 = white
theme.notify_font_color_2 = lgrey
theme.notify_font_color_3 = red
theme.notify_font_color_4 = white
theme.notify_fg = theme.fg_focus
theme.notify_bg = theme.bg_focus
theme.notify_border = theme.border_focus
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
theme.tooltip_font= "DroidSansMono 7"
-- }}}

-- Bordures ------------------------------------------------------------
theme.border_width  = "1"
theme.border_normal = "#222222" -- dark grey
theme.border_focus  = "#76A3B4" -- blue
------------------------------------------------------------------------

-- Opacity -------------------------------------------------------------
theme.opacity_focus = 0.85
theme.opacity_normal = 0.75
------------------------------------------------------------------------

-- Widgets -------------------------------------------------------------
theme.fg_widget = "#222222" -- dark grey
theme.bg_widget = "#FFA000" -- orange
theme.wibox_height = "15"
------------------------------------------------------------------------

-- Menu ----------------------------------------------------------------
theme.menu_height = "15"
theme.menu_width  = "165"
theme.menu_border_width = "0"
theme.menu_border_color = "#000000"
------------------------------------------------------------------------

-- Taglist -------------------------------------------------------------
theme.taglist_squares_sel   = theme.path.."/taglist/squarefz.png"
theme.taglist_squares_unsel = theme.path.."/taglist/squarez.png"
------------------------------------------------------------------------

-- Icons ---------------------------------------------------------------
theme.awesome_icon           = theme.path.."/awesome-icon.png"
theme.menu_submenu_icon      = theme.path.."/submenu.png"
theme.tasklist_floating_icon = theme.path.."/tasklist/floating.png"
------------------------------------------------------------------------

-- Layouts icons -------------------------------------------------------
theme.layout_tile       = theme.path.."/layouts/tile.png"
theme.layout_tileleft   = theme.path.."/layouts/tileleft.png"
theme.layout_tilebottom = theme.path.."/layouts/tilebottom.png"
theme.layout_tiletop    = theme.path.."/layouts/tiletop.png"
theme.layout_fairv      = theme.path.."/layouts/fairv.png"
theme.layout_fairh      = theme.path.."/layouts/fairh.png"
theme.layout_spiral     = theme.path.."/layouts/spiral.png"
theme.layout_dwindle    = theme.path.."/layouts/dwindle.png"
theme.layout_max        = theme.path.."/layouts/max.png"
theme.layout_fullscreen = theme.path.."/layouts/fullscreen.png"
theme.layout_magnifier  = theme.path.."/layouts/magnifier.png"
theme.layout_floating   = theme.path.."/layouts/floating.png"
------------------------------------------------------------------------

-- Widgets icons -------------------------------------------------------
theme.widget_cpu    = theme.path.."/icons/cpu.png"
theme.widget_netup  = theme.path.."/icons/up.png"
theme.widget_fs     = theme.path.."/icons/disk.png"
theme.widget_vol    = theme.path.."/icons/vol.png"
theme.widget_date   = theme.path.."/icons/time.png"
theme.widget_music  = theme.path.."/icons/music.png"
theme.widget_mem    = theme.path.."/icons/mem.png"
theme.widget_net    = theme.path.."/icons/down.png"
theme.widget_bat    = theme.path.."/icons/bat.png"
theme.widget_cal    = theme.path.."/icons/cal.png"
theme.widget_info   = theme.path.."/icons/info.png"
------------------------------------------------------------------------

return theme
--eof-------------------------------------------------------------------
