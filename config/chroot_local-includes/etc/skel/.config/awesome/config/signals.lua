-- Signals --------------------------------------------------------------------------
-- Signal function to execute when a new client appears.
-- {{{ Signals
--

-- {{{ Manage signal handler
client.add_signal("manage", function (c, startup)
    -- Add titlebar to floaters, but remove those from rule callback
    --if awful.client.floating.get(c)
    --or awful.layout.get(c.screen) == awful.layout.suit.floating then
    --   if   c.titlebar then awful.titlebar.remove(c)
    --    else awful.titlebar.add(c, {modkey = modkey, height=beautiful.titlebar_height}) end
    --end
    -- Enable sloppy focus
	   c:add_signal("mouse::enter", function(c)
					   if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
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
-- }}}
 
-- Hook function to execute when focusing a client.
client.add_signal("focus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_focus
    end
end)

-- Hook function to execute when unfocusing a client.
client.add_signal("unfocus", function(c)
    if not awful.client.ismarked(c) then
        c.border_color = beautiful.border_normal
    end
end)

-- {{{ Arrange signal handler
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
 
-- }}}
