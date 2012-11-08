----------------------------------------------------------------------
-- Themes define colours, icons, and wallpapers
-- Variables ---

-- Theme -------------------------------------------------------------
theme      = "current_theme"
theme_path = config_dir .. "/" .. theme .. "/theme.lua"
beautiful.init(theme_path)
----------------------------------------------------------------------


--Menu for choose between all your theme
mythememenu = {}
function theme_load(theme)
  local cfg_path = awful.util.getdir("config")
  -- Create a symlink from the given theme to /home/user/.config/awesome/current_theme
  awful.util.spawn("ln -sfn " .. cfg_path .. "/themes/" .. theme .. " " .. cfg_path .. "/current_theme")
  awesome.restart()
end
function theme_menu()
-- List your theme files and feed the menu table
  local cmd = "ls -1 " .. awful.util.getdir("config") .. "/themes/"
  local f = io.popen(cmd)
  for l in f:lines() do
    local item = { l, function () theme_load(l) end }
    table.insert(mythememenu, item)
  end
  f:close()
end
-- Generate your table at startup or restart
theme_menu()


-- Wallpapers
mywallmenu = {}
function wallpaper_load(wall)
  local cfg_path = awful.util.getdir("config")
  -- Create a symlink from the given theme to /home/user/.config/awesome/current_wallpaper
  awful.util.spawn("ln -sfn " .. wallpapers .. "/" .. wall .. " " .. home .. "/.config/awesome/current_wallpaper")
  awful.util.spawn("feh --bg-scale " .. wallpapers .. "/" .. wall)
end
function wallpaper_menu()
-- List your theme files and feed the menu table
  local cmd = "ls -1 " .. wallpapers
  local f = io.popen(cmd)
  for l in f:lines() do
    local item = { l, function () wallpaper_load(l) end }
    table.insert(mywallmenu, item)
  end
  f:close()
end
-- Generate your table at startup or restart
wallpaper_menu()
