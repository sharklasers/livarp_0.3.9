--local beautiful = require("beautiful")
local naughty = require("naughty")
local os = require("os")
local awful = require("awful")
local string = require("string")

---Specific popups
module("popups")

local function colorize(string, pattern, color)
 local mystring=""
 mystring=string.gsub(string,pattern,'<span color="'..color..'">%1</span>')
 return mystring
end

local processstats = nil
local proc_offset = 25

local function show_process_info(inc_proc_offset, title_color,user_color, root_color)
  local save_proc_offset = proc_offset
	proc_offset = save_proc_offset + inc_proc_offset
	processstats = awful.util.pread('/bin/ps --sort -c,-s -eo fname,user,%cpu,%mem,pid,gid,ppid,tname,label | /usr/bin/head -n '..proc_offset)
	processstats = colorize(processstats, "COMMAND", title_color)
	processstats = colorize(processstats, "USER", title_color)
	processstats = colorize(processstats, "%%CPU", title_color)
	processstats = colorize(processstats, "%%MEM", title_color)
	processstats = colorize(processstats, " PID", title_color)
	processstats = colorize(processstats, "GID", title_color)
	processstats = colorize(processstats, "PPID", title_color)
	processstats = colorize(processstats, "TTY", title_color)
	processstats = colorize(processstats, "LABEL", title_color)
	processstats = colorize(processstats, "root", root_color)
	processstats = colorize(processstats, os.getenv("USER"), user_color)
	--processstats = processstats .. "\n<span color='white'>Temperatures :</span>\n"
	return processstats
end
---Top popup
--It binds a colorized output of the top command to a widget, and the possibility to launch htop with a click on the widget.
--@param mywidget the widget
--@param args a table of arguments { title_color = "#rrggbbaa", user_color = "#rrggbbaa", root_color="#rrggbbaa", terminal = a terminal name})
function htop(mywidget, args)
mywidget_t=awful.tooltip({ 
	objects = { mywidget },
	timer_function = function ()
		return show_process_info(0, args["title_color"], args["user_color"],args["root_color"])
	end,
	update_func = function ()	
		return show_process_info(0, args["title_color"], args["user_color"],args["root_color"])	
	end,
	timeout = 10,
})
end


--=== NETPOPUP ===
local function get_netinfo( my_title_color, my_established_color, my_listen_color)
  str=awful.util.pread('/bin/netstat -pa -u -t | grep -v TIME_WAIT')
  str=colorize(str,"Proto", my_title_color)
  str=colorize(str,'Recv%XQ', my_title_color)
  str=colorize(str,"Send%XQ", my_title_color)
  str=colorize(str,"Adresse locale", my_title_color)
  str=colorize(str,"Adresse distante", my_title_color)
  str=colorize(str,"Etat", my_title_color)
  str=colorize(str,"PID\/Program name", my_title_color)
  str=colorize(str,"Security Context", my_title_color)
  str=colorize(str,"ESTABLISHED", my_established_color)
  str=colorize(str,"LISTEN", my_listen_color)
  return str
end

---Netstat popup
--It binds a colorized output of the netstat command to a widget.
--@param mywidget the widget
--@param args a table { title_color = "#rrggbbaa", established_color= "#rrggbbaa", listen_color="#rrggbbaa"}
function netstat(mywidget, args)
mywidget_t=awful.tooltip({ 
	objects = { mywidget },
	timer_function = function ()
		return get_netinfo( args["title_color"], args["established_color"], args["listen_color"])
	end,
	update_func = function ()	
		return get_netinfo( args["title_color"], args["established_color"], args["listen_color"])	
	end,
	timeout = 10,
})
end


--=== Disk usage===
local function get_diskinfo( my_title_color)
  str=awful.util.pread('/bin/df -h')
  str=colorize(str,"Sys. de fichiers", my_title_color)
  str=colorize(str,"Taille", my_title_color)
  str=colorize(str,"Uti.", my_title_color)
  str=colorize(str,"Disp.", my_title_color)
  str=colorize(str,"Monté sur", my_title_color)
  return str
end

function disk(mywidget, args)
mywidget_t=awful.tooltip({ 
	objects = { mywidget },
	timer_function = function ()	
		return get_diskinfo( args["title_color"], args["used_color"], args["free_color"]) 
	end,
	update_func = function ()	
		return get_diskinfo( args["title_color"], args["used_color"], args["free_color"]) 	
	end,
	timeout= 10,
})
end


--=== Help===
local function get_help( my_title_color)
  str=awful.util.pread('/bin/cat /usr/share/awesome/help')
  str=colorize(str,"Raccourcis", my_title_color)
  str=colorize(str,"Commandes", my_title_color)
  str=colorize(str,"Applications", my_title_color)
  str=colorize(str,"Shifty", my_title_color)
  str=colorize(str,"Moc", my_title_color)
  str=colorize(str,"Système", my_title_color)    
  str=colorize(str,"Clients", my_title_color)
  str=colorize(str,"Widgets", my_title_color)
  str=colorize(str,"Général", "orange")
  str=colorize(str,"Calendrier", "orange")
  str=colorize(str,"Volume", "orange")  
  str=colorize(str,"Cpu", "orange")
  str=colorize(str,"Apt Update", "orange")
  str=colorize(str,"Musique", "orange")  
  str=colorize(str,"Disques", "orange")  
  return str
end

function help(mywidget, args)
mywidget_t=awful.tooltip({ 
	objects = { mywidget },
	timer_function = function ()	
		return get_help( args["title_color"], args["used_color"], args["free_color"]) 
	end,
	update_func = function ()	
		return get_help( args["title_color"], args["used_color"], args["free_color"]) 	
	end,
	timeout= 10,
})
end
