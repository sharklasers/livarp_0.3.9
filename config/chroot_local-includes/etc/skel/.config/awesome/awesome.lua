-----------------------
--   Awesome.lua     --
-----------------------

-- livarp_0.3.9 awesome config file --
-- source: aphelive https://github.com/Aphelion/Aphelive.git --
-- Aphelion & arpinux 2012 --

-- Standard Library ----------------------------------------------------
require("awful.autofocus")
require("awful.rules")
-- Teardrop --------------
require("teardrop")
-- Notifications ---------
require("naughty")
--require("inotify")
-- Widgets Library -------
require("vicious")
------------------------------------------------------------------------

-- Functions -----------------------------------------------------------
-- Sound Control
cardid  = 0
channel = "Master"
function volume (mode, widget)
    if mode == "update" then
        local fd = io.popen("amixer -c " .. cardid .. " -- sget " .. channel)
        local status = fd:read("*all")
            fd:close()
        
        local volume = string.match(status, "(%d?%d?%d)%%")
        volume = string.format("% 3d", volume)

		status = string.match(status, "%[(o[^%]]*)%]")

		if string.find(status, "on", 1, true) then
			volume = "<span color='#76A3B4'>" .. volume .. "</span>%"
		else
			volume = "/"
		end
		widget.text = volume
	elseif mode == "up" then
		io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%+"):read("*all")
		volume("update", widget)
	elseif mode == "down" then
		io.popen("amixer -q -c " .. cardid .. " sset " .. channel .. " 5%-"):read("*all")
		volume("update", widget)
	else
		io.popen("amixer -c " .. cardid .. " sset " .. channel .. " toggle"):read("*all")
		volume("update", widget)
	end
end
------------------------------------------------------------------------

-- Theme Library -------------------------------------------------------
require("beautiful")
require("vicious")
------------------------------------------------------------------------

-- Variables -----------------------------------------------------------
home         = os.getenv("HOME")
config_dir   = awful.util.getdir("config")
themes_dir   = config_dir .. "/themes/"
local scount = screen.count()
------------------------------------------------------------------------

-- Theme ---------------------------------------------------------------
theme      = "livarp"
theme_path = themes_dir .. "/" .. theme .. "/theme.lua"
beautiful.init(theme_path)
------------------------------------------------------------------------

-- Main conf -----------------------------------------------------------
terminal   = "urxvtc"
manager    = "rox-filer"
browser    = "luakit"
editor     = "vim"
editor_cmd = terminal .. " -e " .. editor
------------------------------------------------------------------------

-- Modkey --------------------------------------------------------------
modkey = "Mod1"
k_m    = {modkey}
k_ms   = {modkey, "Shift"}
k_mc   = {modkey, "Control"}
k_mcs  = {modkey, "Control", "Shift"}

modkey2 = "Mod4"
k_w     = "modkey2"
k_ws    = {modkey2, "Shift"}
k_wc    = {modkey2, "Control"}
k_wcs   = {modkey2, "Control", "Shift"}
------------------------------------------------------------------------

-- Window management layouts -------------------------------------------
layouts = {
  awful.layout.suit.tile,        -- 1
  awful.layout.suit.tile.bottom, -- 2
  awful.layout.suit.fair,        -- 3
  awful.layout.suit.max,         -- 4
  awful.layout.suit.magnifier,   -- 5
  awful.layout.suit.floating     -- 6
}
------------------------------------------------------------------------

-- Tags ----------------------------------------------------------------
tags = {
  names  = { "w", "e", "s", "o", "m", "e" },
  layout = { layouts[1], layouts[2], layouts[2], layouts[2], layouts[4], layouts[4]
}}

for s = 1, scount do
  tags[s] = awful.tag(tags.names, s, tags.layout)
  for i, t in ipairs(tags[s]) do
      awful.tag.setproperty(t, "mwfact", i==5 and 0.13  or  0.5)
      --awful.tag.setproperty(t, "hide",  (i==6 or  i==7) and true)
  end
end
------------------------------------------------------------------------

-- Graph submenu -------------------------------------------------------
capture = {
    { "now", "scrot '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/tmp/ &amp; gpicview ~/tmp/$f'" },
    { "in 5s", "scrot -d5 '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/tmp/ &amp; gpicview ~/tmp/$f'" },
    { "in 10s", "scrot -d10 '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/tmp/ &amp; gpicview ~/tmp/$f'" },
    { "in a zone", "scrot -s '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ~/tmp/ &amp; gpicview ~/tmp/$f'" },
}
------------------------------------------------------------------------

-- Preferences submenu -------------------------------------------------
awesomemenu = {
    { "edit awesome_start", editor_cmd .." bin/start/awesome_start.sh" },
    { "edit awesome.lua", editor_cmd .." .config/awesome/awesome.lua" },
    { "man page", terminal .." -e man awesome" },
    { "edit .xinitrc", editor_cmd .." .xinitrc" },
    { "reload", awesome.restart },
    { "quit", awesome.quit },
}
conky = {
    { "edit .conkyrc", editor_cmd .." .conky/.conkyrc_awesome" },
    { "man page", terminal .." -e man conky" },
    { "wiki page", browser .." http://arpinux.org/x/doku.php/start:conky" },
}
composite = {
    { "no effect", "xcompmgr_livarp -s" },
    { "light effect", "xcompmgr_livarp -l" },
    { "medium effect", "xcompmgr_livarp -m" },
    { "full effect", "xcompmgr_livarp -f" },
}
------------------------------------------------------------------------

-- Menu ----------------------------------------------------------------
prefs = {
    { "awesome", awesomemenu },
    { "conky", conky },
    { "display", "grandr" },
    { "interface", "lxappearance" },
    { "background", "nitrogen " },
    { "web startpage", editor_cmd.." .startpage/index.html" },
    { "composite", composite},
}
accessoires = {
    { "terminal", "urxvtc" },
    { "find files", "catfish" },
    { "rename", "pyrenamer" },
    { "archive manager", "file-roller" },
    { "text editor", "geany" },
    { "file manager", "rox-filer" },
    { "root file manager", "gksudo rox-filer" },
}
multimedia = {
   { "media player", "gnome-mplayer" },
   { "music player (cli)", terminal.." -e mocp" },
   { "cd/dvd burner", "brasero" },
   { "volume control", terminal .." -e alsamixer" },
}
internet = {
   { "luakit browser", "luakit" },
   { "firefox browser", "firefox" },
   { "weechat irc client", terminal.." -e weechat-ncurses" },
   { "mcabber jabber client", terminal.." -e mcabber" },
   { "claws-mail", "claws-mail" },
   { "filezilla ftp client", "filezilla" },
   { "transmission torrent client", "transmission" },
}
bureautique = {
   { "abiword", "abiword" },
   { "gnumeric", "gnumeric" },
   { "calculator", "xcalc" },
   { "PDF viewer", "evince" },
}
graphismmenu = {
    { "the gimp", "gimp" },
    { "images viewer", "gpicview" },
    { "color chooser", "gcolor2" },
    { "screenshot", capture },
}
applications = {
    { "internet", internet },
    { "multimedia", multimedia },
    { "graphics", graphismmenu },
    { "office", bureautique },
    { "accessories", accessoires },
}
systemmenu = {
    { "package manager", "gksudo synaptic" },
    { "partition editor", "gksudo gparted" },
    { "défault applications", terminal.." -e sudo update-alternatives --all" },
    { "disk usage", "baobab" },
    { "bootup manager", "gksudo bum" },
    { "root terminal", terminal.." -e su" },
    { "livarp-xs-maker", "/usr/local/bin/livarp-xs.sh" },
}
helpmenu = {
    { "livarp help center", browser.." /usr/share/livarp/help_center/index.html" },
    { "livarp wiki", browser.." http://arpinux.org/x/doku.php/start:livarp:livarp_039" },
}
------------------------------------------------------------------------

-- Main Menu -----------------------------------------------------------
mymainmenu = awful.menu({ items = { { "run", "dmenu_run -i -p 'exec :' -nb '" .. 
										beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. 
										"' -sb '" .. beautiful.bg_focus .. 
										"' -sf '" .. beautiful.fg_focus .. "'" },
									{ "--------" },
									{ "terminal", terminal },
									{ "web browser", "luakit" },
									{ "file manager", manager },
                                    { "text editor", "geany" },
                                    { "media player", "gnome-mplayer" },
                                    { "--------" },
                                    { "applications", applications },
									{ "preferences", prefs },
                                    { "system", systemmenu },
                                    { "help", helpmenu },
                                    { "--------" },
                                    { "lock screen", "slock" },
                                    { "exit", "shutdown.sh" }
                                  }
                        })
------------------------------------------------------------------------

-- Launcher Menu -------------------------------------------------------
mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon), menu = mymainmenu })
------------------------------------------------------------------------

-- Create Wibox --------------------------------------------------------
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button( k_m , 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button( k_m , 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
					 awful.button({ }, 2, function (c)
											  client.focus = c
											  c:kill()
										  end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
------------------------------------------------------------------------

---------------
-- Widgets --
---------------

-- Promptbox -----------------------------------------------------------
mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
------------------------------------------------------------------------

-- Layout Box ----------------------------------------------------------
mylayoutbox[s] = awful.widget.layoutbox(s)
mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
------------------------------------------------------------------------

-- Taglist -------------------------------------------------------------
mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
------------------------------------------------------------------------

-- Tasklist ------------------------------------------------------------
mytasklist[s] = awful.widget.tasklist(function(c)
				  return awful.widget.tasklist.label.currenttags(c, s)
			  end, mytasklist.buttons)
------------------------------------------------------------------------

-- Separator left  -----------------------------------------------------
separatorl = widget({ type = "textbox" })
separatorl.text = ' [ '
------------------------------------------------------------------------

-- Separator right -----------------------------------------------------
separatorr = widget({ type = "textbox" })
separatorr.text = ' ] '
------------------------------------------------------------------------

-- Spacer --------------------------------------------------------------
spacer         		= widget({ type = "textbox", name = "myspacer" })
spacer.text    		= " "
------------------------------------------------------------------------

-- Clock ---------------------------------------------------------------
calicon = widget({ type = "imagebox" })
calicon.image = image(beautiful.widget_cal)
datewidget = widget({ type = "textbox" })
vicious.register(datewidget, vicious.widgets.date, '%d %B %R', 60)
-- Register buttons
datewidget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () awful.util.spawn(home.."/bin/awesome_calendar.sh", false) end)
))
------------------------------------------------------------------------

-- Systray -------------------------------------------------------------
mysystray = widget({ type = "systray" })
------------------------------------------------------------------------

-- Volume --------------------------------------------------------------
volicon = widget({ type = "imagebox"})
volicon.image = image(beautiful.widget_vol)
tb_volume = widget({ type = "textbox", name = "tb_volume", align = "right" })
tb_volume:buttons(awful.util.table.join(
awful.button({ }, 4, function () volume("up", tb_volume) end),
awful.button({ }, 5, function () volume("down", tb_volume) end),
awful.button({ }, 3, function () awful.util.spawn("urxvtc -T alsamixer -e alsamixer", false) end),
awful.button({ }, 1, function () volume("mute", tb_volume) end)
))
volume("update", tb_volume)
------------------------------------------------------------------------

-- Battery -------------------------------------------------------------
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat, "$1$2%",61,"BAT0")
------------------------------------------------------------------------

-- Memory usage --------------------------------------------------------
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
-- Initialize widget
memwidget0 = widget({ type = "textbox" })
-- Register widget
vicious.register(memwidget0, vicious.widgets.mem, "$1% ($2MB/$3MB)", 30)
------------------------------------------------------------------------

-- Memory usage (progress bar) -----------------------------------------
-- Initialize widget
memwidget = awful.widget.progressbar()
-- Progressbar properties
memwidget:set_width(8)
memwidget:set_height(15)
memwidget:set_vertical(true)
memwidget:set_background_color("#4A4A4A")
memwidget:set_border_color(nil)
memwidget:set_color("#96ADCF")
memwidget:set_gradient_colors({ "#96ADCF", "#7559A1", "#CB4230" })
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, "$1", 30)
------------------------------------------------------------------------

-- CPU usage -----------------------------------------------------------
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
-- Initialize widget
cpuwidget0 = widget({ type = "textbox" })
-- Register widget
vicious.register(cpuwidget0, vicious.widgets.cpu, "$1%")
------------------------------------------------------------------------

--cpu usage (progress bar) ---------------------------------------------
-- Initialize widget
cpuwidget = awful.widget.graph()
-- Graph properties
cpuwidget:set_width(50)
cpuwidget:set_background_color("#4A4A4A")
cpuwidget:set_color("#CB4230")
cpuwidget:set_gradient_colors({ "#CB4230", "#7559A1", "#96C8CF" })
-- Register widget
vicious.register(cpuwidget, vicious.widgets.cpu, "$1")
------------------------------------------------------------------------

-----------
-- Panel --
-----------

-- Panel Config --------------------------------------------------------
mywibox[s] = awful.wibox({
       position = "top",
       screen = s,
       height = beautiful.wibox_height,
       border_color = beautiful.border_panel,
       border_width = beautiful.border_width
 })
------------------------------------------------------------------------

-- Add Widgets to the Panel --------------------------------------------
    mywibox[s].widgets = {
        {
            mylauncher,mytaglist[s],mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],spacer,
        s == 1 and mysystray,spacer or nil,
		datewidget,calicon,spacer,
        tb_volume,volicon,spacer,
        batwidget,baticon,spacer,
		--memwidget0,
        memwidget.widget,memicon,spacer,
		cpuwidget.widget,
        --cpuwidget0,
        cpuicon,spacer,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
------------------------------------------------------------------------

-- Mouse bindings ------------------------------------------------------
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
------------------------------------------------------------------------

-- Key bindings --------------------------------------------------------
globalkeys = awful.util.table.join(
    awful.key( k_m, "Left",			awful.tag.viewprev       ),
    awful.key( k_m, "Right",		awful.tag.viewnext       ),
    awful.key( k_m, "Escape",		awful.tag.history.restore),
    
    awful.key( k_m, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key( k_m, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
------------------------------------------------------------------------

-- Layout manipulation -------------------------------------------------
    awful.key( k_mc	, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key( k_mc	, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key( k_mcs, "j", function () awful.screen.focus_relative( 1) end),
    awful.key( k_mcs, "k", function () awful.screen.focus_relative(-1) end),
    awful.key( k_m	, "u", awful.client.urgent.jumpto),
    awful.key( k_m	, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),
------------------------------------------------------------------------

-- Standard program ----------------------------------------------------
awful.key( k_m	, "Return", function () awful.util.spawn(terminal) end),
awful.key( k_ms	, "f", function () awful.util.spawn(manager) end),
awful.key( k_m	, "w", function () awful.util.spawn("luakit") end),
awful.key( k_ms	, "w", function () awful.util.spawn("firefox") end),
awful.key( k_m	, "m", function () teardrop("urxvtc -T moc -e mocp","center","center",800,600) end),
awful.key( k_m	, "f", function () teardrop("urxvtc -T filer -e ranger","center","center",800,600) end),

awful.key( k_mc	, "r", awesome.restart),
awful.key( k_mc	, "q", awesome.quit),
------------------------------------------------------------------------

-- Menu ----------------------------------------------------------------
awful.key( k_m, "p", function () mymainmenu:show({keygrabber=true}) end),
awful.key( {}, "Menu", function () mymainmenu:show({keygrabber=true}) end),
------------------------------------------------------------------------

--- Client manipulation ------------------------------------------------
awful.key( k_m	, "l",     function () awful.tag.incmwfact( 0.05)    end),
awful.key( k_m	, "h",     function () awful.tag.incmwfact(-0.05)    end),
awful.key( k_ms	, "h",     function () awful.tag.incnmaster( 1)      end),
awful.key( k_ms	, "l",     function () awful.tag.incnmaster(-1)      end),
awful.key( k_mc	, "h",     function () awful.tag.incncol( 1)         end),
awful.key( k_mc	, "l",     function () awful.tag.incncol(-1)         end),
awful.key( k_m	, "space", function () awful.layout.inc(layouts,  1) end),
awful.key( k_ms	, "space", function () awful.layout.inc(layouts, -1) end),
------------------------------------------------------------------------

-- Volume keys ---------------------------------------------------------
awful.key({ }, "XF86AudioRaiseVolume", function () volume("up", tb_volume) end),
awful.key({ }, "XF86AudioLowerVolume", function () volume("down", tb_volume) end),
awful.key({ }, "XF86AudioMute", function () volume("mute", tb_volume) end),
------------------------------------------------------------------------

-- Print screen --------------------------------------------------------
awful.key({ }, "Print", function () awful.util.spawn("scrot '%Y-%m-%d--%s_$wx$h_scrot.png' -e 'mv $f ".. home .."/tmp/ &amp; gpicview ".. home .."/tmp/$f'") end),
------------------------------------------------------------------------

-- Lock screen ---------------------------------------------------------
awful.key({ }, "XF86ScreenSaver", function () awful.util.spawn("slock")end),
------------------------------------------------------------------------

-- Sleep (suspend to ram) ----------------------------------------------
awful.key({ }, "XF86Sleep", function () awful.util.spawn("dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend")end),
------------------------------------------------------------------------

-- Suspend (suspend to disk) -------------------------------------------
awful.key({ }, "XF86Suspend", function () awful.util.spawn("dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Hibernate")end),
------------------------------------------------------------------------

-- Battery
--XF86Battery

-- Display
--XF86Display
awful.key({ }, "XF86Display", function () awful.util.spawn("grandr")end),

-- brightness
--XF86MonBrightnessDown
--XF86MonBrightnessUp

-- wlan
--XF86WLAN

-- touchpad
--XF86Launch1

-- poweroff ------------------------------------------------------------
--XF86PowerOff
awful.key({ }, "XF86PowerOff", function () awful.util.spawn("dbus-send --system --print-reply --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend")end),
------------------------------------------------------------------------

-- Prompt --------------------------------------------------------------
    awful.key(k_m , "r",     function () mypromptbox[mouse.screen]:run() end),
	
	awful.key(k_m ,  "F2",    function ()
		awful.util.spawn("dmenu_run -i -p 'Executer :' -nb '" .. 
			beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. 
			"' -sb '" .. beautiful.bg_focus .. 
			"' -sf '" .. beautiful.fg_focus .. "'") 
	end),
	
    awful.key( k_m , "x",
              function ()
                  awful.prompt.run({ prompt = "Executer Code Lua : " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key( k_mc	, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key( k_m	, "q",      function (c) c:kill()                         end),
    awful.key( k_mc	, "space",  awful.client.floating.toggle                     ),
    awful.key( k_mc	, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key( k_m	, "o",      awful.client.movetoscreen                        ),
    awful.key( k_ms	, "r",      function (c) c:redraw()                       end),
    awful.key( k_mc	, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key( k_mc	, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key( k_mc , "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags ----------------------------------------
-- Keyboard digits
local keynumber = 0
for s = 1, scount do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end
------------------------------------------------------------------------

-- Tag controls --------------------------------------------------------
for i = 1, keynumber do
    globalkeys = awful.util.table.join( globalkeys,
        awful.key({ modkey }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then awful.tag.viewonly(tags[screen][i]) end
        end),
        awful.key({ modkey, "Control" }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then awful.tag.viewtoggle(tags[screen][i]) end
        end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.toggletag(tags[client.focus.screen][i])
            end
        end))
end
------------------------------------------------------------------------

-- opération a la souris sur les clients -------------------------------
clientbuttons = awful.util.table.join(
    awful.button(k_m, 1, function (c) client.focus = c; c:raise() end),
    awful.button(k_m, 1, awful.mouse.client.move),
    awful.button(k_m, 3, awful.mouse.client.resize))
------------------------------------------------------------------------

-- Set keys ------------------------------------------------------------
root.keys(globalkeys)
------------------------------------------------------------------------

-- Rules ---------------------------------------------------------------
awful.rules.rules = {
    { rule = { }, properties = {
      focus = true,      size_hints_honor = false,
      keys = clientkeys, buttons = clientbuttons,
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal }
    },
    { rule = { class = "Firefox",  role = "browser" },
      properties = { tag = tags[1][1], switchtotag = true }},
    { rule = { class = "Geany" },  properties = { tag = tags[1][2], switchtotag = true } },
    { rule = { class = "Xmessage", instance = "xmessage" }, properties = { floating = true }},
    { rule = { class = "urxvtc" },        properties = { opacity=0.5 }, },
    { rule = { class = "Rox-filer" },    properties = { floating = true }, callback = awful.placement.centered },
    { rule = { class = "gnome-mplayer" },properties = { floating = true }, callback = awful.placement.centered },
    { rule = { class = "mplayer" },      properties = { floating = true }, callback = awful.placement.centered },
    { rule = { class = "Osmo" },      properties = { floating = true }, callback = awful.placement.centered },
    { rule = { class = "Nitrogen" },     properties = { floating = true }, callback = awful.placement.centered },
    { rule = { name = "bashmount" },    properties = { floating = true }, callback = awful.placement.centered },
    { rule = { class = "Firefox" }, except = { role = "browser" }, properties = {floating = true}, callback = awful.placement.centered },  
}
------------------------------------------------------------------------

-- Signals -------------------------------------------------------------
-- Signal function to execute when a new client appears.
-- {{{ Signals
--
-- Manage signal handler -----------------------------------------------
client.add_signal("manage", function (c, startup)
    -- Add titlebar to floaters, but remove those from rule callback
    --if awful.client.floating.get(c)
    --or awful.layout.get(c.screen) == awful.layout.suit.floating then
    --   if   c.titlebar then awful.titlebar.remove(c)
    --    else awful.titlebar.add(c, {modkey = modkey}) end
    --end

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function (c)
        if  awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Client placement
    if not startup then
        awful.client.setslave(c)

        if  not c.size_hints.program_position
        and not c.size_hints.user_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
------------------------------------------------------------------------

-- Focus signal handlers -----------------------------------------------
client.add_signal("focus",   function (c) c.border_color = beautiful.border_focus  end)
client.add_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
------------------------------------------------------------------------

-- Arrange signal handler ----------------------------------------------
for s = 1, scount do screen[s]:add_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do -- Floaters are always on top
        if   awful.client.floating.get(c) or layout == "floating"
        then if not c.fullscreen then c.above       =  true  end
        else                          c.above       =  false end
    end
  end)
end
------------------------------------------------------------------------

-- AUTORUN APPS --------------------------------------------------------
function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then 
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end

run_once("urxvtd","-q -o -f")
--run_once("conky","-c .conky/.conkyrc_awesome")
--run_once("xcompmgr_livarp","-m")

-- CUSTOM: xsetroot every 10 seconds -----------------------------------
--mytimer = timer({ timeout = 10 })
--mytimer:add_signal("timeout", function() awful.util.spawn_with_shell("xsetroot -cursor_name left_ptr") end)
--mytimer:start()
--awful.util.spawn_with_shell("xsetroot -cursor_name left_ptr")
------------------------------------------------------------------------
--eof-------------------------------------------------------------------
