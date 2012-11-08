-- Widgets Library -------
require("vicious")
require("couth.couth")

local menu = require('menu')

-- Sound Control
require('couth.alsa')
couth.CONFIG.ALSA_CONTROLS = {
     'Master',
     'PCM',
}
couth.CONFIG.NOTIFIER_FONT = "DroidSansMono 7"

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create Wibox ------------------------------------------------------------------------------
mywibox = {}
my_bottom_wibox ={}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button( k_m , 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button( k_m, 3, function(t) menu.create.tags(nil, t) end),
                    awful.button({ }, 8, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
                
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1,
						function (c)
							if not c:isvisible() then awful.tag.viewonly(c:tags()[1]) end
							if client.focus == c then
								c.minimized = not c.minimized
							else
								client.focus = c
								c:raise()
							end
						end
					),
					awful.button({ }, 2, function (c) c:kill() end),
					awful.button({ }, 3,
						function (c)
							if instance then
								instance:hide()
								instance = nil
							else
								instance = menu.create.clients(nil, c)
							end
						end
					),
					awful.button({ }, 4,
						function ()
							awful.client.focus.byidx(1)
								if client.focus then client.focus:raise() end
						end
					),
					awful.button({ }, 5,
						function ()
							awful.client.focus.byidx(-1)
							if client.focus then client.focus:raise() end
						end
					)
				)
for s = 1, screen.count() do
-----------------------------------------------------------------------------------------------
os.setlocale("fr_FR.UTF-8")

calicon = widget({ type = "imagebox" })
calicon.image = image(beautiful.widget_cal)

-- Create a textclock widget
datewidget = widget({ type = "textbox" })
vicious.register(datewidget, vicious.widgets.date, "<span color=\""..beautiful.fg_normal.."\" size=\"small\">%a %d %b %Y %R</span>", 60)

-- Calendar widget to attach to the textclock
require('calendar2')
calendar2.addCalendarToWidget(datewidget)

------------------------------------------------------------------

-- Promptbox ------------------------------------------------------------------------------
mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
-------------------------------------------------------------------------------------------

-- Layout Box ----------------------------------------------------------------------------------
mylayoutbox[s] = awful.widget.layoutbox(s)
mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
------------------------------------------------------------------------------------------------

-- Taglist ------------------------------------------------------------------------------
mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)
-----------------------------------------------------------------------------------------

-- Tasklist ----------------------------------------------------------------------------------
mytasklist[s] = awful.widget.tasklist(function(c)
				  return awful.widget.tasklist.label.currenttags(c, s)
			  end, mytasklist.buttons)
----------------------------------------------------------------------------------------------

-- Separator left  ------------------------
separatorl = widget({ type = "textbox" })
separatorl.text = ' [ '
-------------------------------------------

-- Separator right ------------------------
separatorr = widget({ type = "textbox" })
separatorr.text = ' ] '
-------------------------------------------

-- Separator ------------------------------
separator = widget({ type = "textbox" })
separator.text = ' | '
-------------------------------------------

-- Spacer ---------------------------------------------------------------
spacer         		= widget({ type = "textbox", name = "myspacer" })
spacer.text    		= " "
-------------------------------------------------------------------------

-- Systray -----------------------------
mysystray = widget({ type = "systray" })
----------------------------------------

-- ==SYSTEM==
uptime = widget({ type = "textbox" })
uptime_t = awful.tooltip({ objects = { uptime },})
vicious.register(uptime, vicious.widgets.uptime,
	function (widget, args)
		uptime_t:set_text("Load : [".. args[4] .."/".. args[5] .."/".. args[6] .."]\n")
		return "<span color=\""..beautiful.fg_normal.."\" size=\"small\">Uptime : " .. args[1] .. "d " .. args[2] .. "h " .. args[3] .. "m </span>"
	end,60)


-- CPU widget
require ("popups")

cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)

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

cpuwidget.widget:buttons(awful.util.table.join(awful.button({}, 1, function () awful.util.spawn ( terminal .. " -e htop --sort-key PERCENT_CPU") end ) ) )
popups.htop(cpuwidget.widget,{ title_color = beautiful.notify_font_color_1, user_color= beautiful.notify_font_color_2, root_color=beautiful.notify_font_color_3, terminal = "urxvtc"})


-- Ram widget
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)

------------------------------------------------------------------------

-- Memory usage (progress bar) -----------------------------------------
-- Initialize widget
memwidget = awful.widget.progressbar()
memwidget_t = awful.tooltip({ objects = { memwidget.widget },})

-- Progressbar properties
memwidget:set_width(8)
memwidget:set_height(15)
memwidget:set_vertical(true)
memwidget:set_background_color("#4A4A4A")
memwidget:set_border_color(nil)
memwidget:set_color("#96ADCF")
memwidget:set_gradient_colors({ "#96ADCF", "#7559A1", "#CB4230" })
-- Register widget
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget.widget, vicious.widgets.mem, 
	function (widget, args)
		memwidget_t:set_text("Utilisé : " .. args[2] .. "/" .. args[3] .. "\nLibre : " .. args[4] .. "\n\nSwap : " .. args[5] .."/" .. args[7])
		return args[1]
	end, 59)



-- Filesystem widgets
fsicon = widget({ type = "imagebox"})
fsicon.image = image(beautiful.widget_fs)
-- fs

fs = {
  --b = awful.widget.progressbar(),
  r = awful.widget.progressbar(),
  --h = awful.widget.progressbar(),
  --s = awful.widget.progressbar()
}
-- Progressbar properties
for _, w in pairs(fs) do
  w:set_vertical(true):set_ticks(true)
  w:set_height(14):set_width(8):set_ticks_size(2)
  w:set_border_color(nil)
  w:set_background_color("#4A4A4A")
  w:set_gradient_colors({ "#96ADCF", "#7559A1", "#CB4230"}) 
  -- Register buttons
  w.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec("rox-filer", false) end)
  ))
end -- Enable caching
vicious.cache(vicious.widgets.fs)
-- Register widgets
--vicious.register(fs.b, vicious.widgets.fs, "${/boot used_p}", 599)
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",     599)
--vicious.register(fs.h, vicious.widgets.fs, "${/home used_p}", 599)

--popups.disk(fs.b.widget,{ title_color = beautiful.notify_font_color_1})
popups.disk(fs.r.widget,{ title_color = beautiful.notify_font_color_1})
--popups.disk(fs.h.widget,{ title_color = beautiful.notify_font_color_1})

--fs.b.widget:buttons(awful.util.table.join(awful.button({}, 1, function () awful.util.spawn ("rox-filer /boot") end ) ) )
fs.r.widget:buttons(awful.util.table.join(
    awful.button({}, 1, function () awful.util.spawn ("rox-filer") end ),
    awful.button({}, 3, function () awful.util.spawn ("urxvtc -e ncdu") end )
))
--fs.h.widget:buttons(awful.util.table.join(awful.button({}, 1, function () awful.util.spawn ("rox-filer") end ) ) )

-- Battery state -----------------------
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
-- Initialize widget 
batwidget = widget({ type = "textbox" })
bat_t = awful.tooltip({ objects = { batwidget },})

-- Register widget
vicious.register(batwidget, vicious.widgets.bat,
function (widget, args)
	if args[2] == 0 then return ""
	else
		bat_t:set_text("Niveau: " .. args[2] .. "% restant !\nEtat: " .. args[1] .. "\nTemps restant: " .. args[3] .."")
		if args[2] < 15 then
			naughty.notify({ 
				title = "Avertissement Batterie", 
				text = "Batterie faible ! "..args[2].."% restant!\nBranchez vous sur le secteur.", 
				timeout = 10, 
				position = "top_right", 
				fg = beautiful.fg_urgent, 
				bg = beautiful.bg_urgent 
			})
			return "<span color=\""..beautiful.bg_urgent.."\" size=\"small\">".. args[2] .. "%</span>"
		else
			return "<span color=\""..beautiful.fg_normal.."\" size=\"small\">".. args[2] .. "%</span>"
		end
	end
end, 61, Battery
)
--batwidget:buttons(awful.util.table.join(awful.button({}, 1, function () awful.util.spawn ("xfce4-power-manager-settings") end ) ) )

-----------------------------------------
volicon = widget({ type = "imagebox"})
volicon.image = image(beautiful.widget_vol)

volwidget = widget({ type = "textbox" })
vicious.register(volwidget, vicious.widgets.volume,
function (widget, args)
	if args[1] == 0 or args[2] == "♩" then
		return "<span color=\""..beautiful.bg_urgent.."\" size=\"small\">mute</span>"
	else
		return "<span color=\""..beautiful.fg_normal.."\" size=\"small\">" .. args[1] .. "</span>"
	end
end, 2, "Master" )

volwidget:buttons(awful.util.table.join(
	awful.button({ }, 1, function () exec(couth.notifier:notify( couth.alsa:setVolume('Master','toggle'))) end),
	awful.button({ }, 4, function () exec(couth.notifier:notify( couth.alsa:setVolume('Master','3dB+'))) end),
	awful.button({ }, 5, function () exec(couth.notifier:notify( couth.alsa:setVolume('Master','3dB-'))) end),
	awful.button({ "Control" }, 1, function () exec(couth.notifier:notify( couth.alsa:setVolume('PCM','toggle'))) end),
	awful.button({ "Control" }, 4, function () exec(couth.notifier:notify( couth.alsa:setVolume('PCM','3dB+'))) end),
	awful.button({ "Control" }, 5, function () exec(couth.notifier:notify( couth.alsa:setVolume('PCM','3dB-'))) end),    
	awful.button({ }, 3, function () exec(teardrop("urxvtc -T alsamixer -e alsamixer","center","center",800,390)) end)    
))
volwidget:add_signal('mouse::enter', function () couth.notifier:notify( couth.alsa:getVolume() ) end)

-- ==========

infoicon = widget({ type = "imagebox" })
infoicon.image = image(beautiful.widget_info)

popups.help(infoicon,{ title_color = beautiful.notify_font_color_1})

-- ==NETWORK==
-- net widget --------------------------
net = widget({ type = "textbox" })

vicious.register(net, vicious.widgets.net, 
				function (widget, args)
					local out = "Net :"
					for line in io.lines("/proc/net/dev") do
						local name = string.match(line, "^[%s]?[%s]?[%s]?[%s]?([%w]+):")
						local received = tonumber(string.match(line, ":[%s]*([%d]+)"))
						if name ~= nil then
							if name ~= "lo" then
								if received ~= 0 then
									out = out .. " <span color=\""..beautiful.bg_normal.."\" size=\"small\">" .. name .."</span> <span color=\"red\" size=\"x-small\">up </span><span color=\"red\" size=\"small\">" .. args["{" .. name .." up_kb}"] .. "KB</span> / <span color=\"green\" size=\"small\">" .. args["{" .. name .." down_kb}"] .. "KB</span><span color=\"green\" size=\"x-small\"> dn</span>" 
								end
							end
						end
					end
					return out
                end, 1)

popups.netstat(net,{ title_color = beautiful.notify_font_color_1, established_color= beautiful.notify_font_color_2, listen_color=beautiful.notify_font_color_3})			
----------------------------------------

-- Mail widget -------------------------
-- put your gmail credentials in ~/.netrc file
-- syntax :
-- #machine mail.google.com login <e-mail address> password <password>

mygmail = widget({ type = "textbox" })
gmail_t = awful.tooltip({ objects = { mygmail },})

vicious.register(mygmail, vicious.widgets.gmail,
                function (widget, args)
                    gmail_t:set_text(args["{subject}"])
                    return "<span color=\""..beautiful.fg_normal.."\" size=\"small\">Mail : " .. args["{count}"] .. "</span>"
                 end, 120) 
                 --the '120' here means check every 2 minutes.
mygmail:buttons(awful.util.table.join(awful.button({}, 1, function () awful.util.spawn ( webcli .. " https://mail.google.com") end ) ) )
----------------------------------------


-- Apt Widget --------------------------
aptwidget = widget({type = "textbox"})
aptwidget_t = awful.tooltip({ objects = { aptwidget},})

vicious.register(aptwidget, vicious.widgets.pkg,
                function(widget,args)
                    local io = { popen = io.popen }
                    local s = io.popen("apt-show-versions -u -b")
                    local str = ''

                    for line in s:lines() do
                        str = str .. line .. "\n"
                    end
                    aptwidget_t:set_text(str)
                    s:close()
                    return "<span color=\""..beautiful.fg_normal.."\" size=\"small\">Upd : " .. args[1] .. "</span>"
                end, 1800, "Debian")

                --'1800' means check every 30 minutes
aptwidget:buttons(awful.util.table.join(awful.button({}, 3, function () teardrop("urxvtc -e update.sh", "bottom","center",800,100,true) end ) ) )
-----------------------------------------

-- Enable mocp
function moc_control (action)
	local moc_info,moc_state
 
	if action == "next" then
		io.popen("mocp --next")
	elseif action == "previous" then
		io.popen("mocp --previous")
	elseif action == "stop" then
		io.popen("mocp --stop")
	elseif action == "play_pause" then
		moc_info = io.popen("mocp -i"):read("*all")
	        moc_state = string.gsub(string.match(moc_info, "State: %a*"),"State: ","")
 
		if moc_state == "PLAY" then
			io.popen("mocp --pause")
		elseif moc_state == "PAUSE" then
			io.popen("mocp --unpause")
		elseif moc_state == "STOP" then
			io.popen("mocp --play")
		end
	end
end

tb_moc = widget({ type = "textbox", align = "right" })

function hook_moc()
      fpid = io.popen("pgrep -o mocp")
      pid = fpid:read("*n")
	  fpid:close()
	  
      if pid then
	   moc_info = io.popen("mocp -i"):read("*all")
       moc_state = string.gsub(string.match(moc_info, "State: %a*"),"State: ","")
       if moc_state == "PLAY" or moc_state == "PAUSE" then
           moc_artist = string.gsub(string.match(moc_info, "Artist: %C*"), "Artist: ","")
           moc_title = string.gsub(string.match(moc_info, "SongTitle: %C*"), "SongTitle: ","")
           moc_curtime = string.gsub(string.match(moc_info, "CurrentTime: %d*:%d*"), "CurrentTime: ","")
           moc_totaltime = string.gsub(string.match(moc_info, "TotalTime: %d*:%d*"), "TotalTime: ","")
           if moc_artist == "" then 
               moc_artist = "artiste inconnu" 
           end
           if moc_title == "" then 
               moc_title = "titre inconnu" 
           end
	   -- moc_title = string.format("%.5c", moc_title)
           moc_string = moc_artist .. " - " .. moc_title .. "(" .. moc_curtime .. "/" .. moc_totaltime .. ")"
           if moc_state == "PAUSE" then 
               moc_string = "PAUSE - " .. moc_string .. ""
           end
       else
           moc_string = "-- Lecture stoppée --"
       end
	  else
      	   moc_string = ""
      end
      return moc_string
end
 
-- refresh Moc widget
moc_timer = timer({timeout = 1})
moc_timer:add_signal("timeout", function() tb_moc.text = ' ' .. hook_moc() .. ' ' end)
moc_timer:start()

--moc widget buttons
tb_moc:buttons(awful.util.table.join(
	awful.button({ }, 1, function () moc_control("play_pause") end),
	awful.button({ }, 2, function () exec(teardrop("urxvtc -T moc -e mocp","center","center",800,600)) end),
	awful.button({ }, 3, function () moc_control("stop") end),
	awful.button({ }, 4, function () moc_control("next") end),
	awful.button({ }, 5, function () moc_control("previous") end)	
))


--==============================================================--

--                       PANEL CREATION                         --

--==============================================================--
-- Panel Config ----------------------------------------------
mywibox[s] = awful.wibox({
       position = "top",
       screen = s,
       height = beautiful.wibox_height,
       border_color = beautiful.border_panel,
       border_width = beautiful.border_width
 })
 my_bottom_wibox[s] = awful.wibox({
       position = "bottom",
       screen = s,
       height = beautiful.wibox_height,
       border_color = beautiful.border_panel,
       border_width = beautiful.border_width
 })
--------------------------------------------------------------

-- Add Widgets to the Panel ----------------------------------
   mywibox[s].widgets = {
        {
            mylauncher,mytaglist[s],mylayoutbox[s],mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        spacer,
        s == 1 and mysystray or nil,
        spacer,
		datewidget,spacer,calicon,
		spacer,separator,
		infoicon,
		separator,spacer,
		volwidget,spacer,volicon,
		spacer,separator,spacer,
		batwidget,spacer,baticon,
		spacer,separator,spacer,
		--fs.h.widget,spacer,fs.r.widget,spacer,fs.b.widget,spacer,fsicon,
		fs.r.widget,spacer,fsicon,
		spacer,separator,spacer,
        memwidget.widget,spacer,memicon,
        spacer,separator,spacer,
        cpuwidget.widget,spacer,cpuicon,
        spacer,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
    
    -- Add Widgets to the Panel ----------------------------------
    my_bottom_wibox[s].widgets = {
        {
        net,
        spacer,separator,spacer,
        aptwidget,
        spacer,separator,spacer,
        --mygmail,
        --spacer,separator,spacer,        
        tb_moc,
        layout = awful.widget.layout.horizontal.leftright
        },
        uptime,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
--------------------------------------------------------------

my_bottom_wibox[1].visible = false


-- SHIFTY: initialize shifty
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
shifty.taglist = mytaglist
shifty.init()
