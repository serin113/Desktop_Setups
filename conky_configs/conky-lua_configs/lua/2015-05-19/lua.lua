--[[

"Conky Rings", modified by serin113 (2015)

Initially based on the Lua code in:
	https://wiki.archlinux.org/index.php/Conky#Graysky

...which is, in turn, heavily based on:
	http://londonali1010.deviantart.com/art/quot-Rings-quot-Meters-for-Conky-141961783

And also with a whole lotta code (and feature inspiration) from:
	https://github.com/lutherush/conky/blob/master/conky/pie-ring-text/text.lua

URLs are still working as of 14 May 2015. You never know, web pages and stuff. 

Enjoy this sloppy amalgamation of several pieces of code... hopefully.

Anyways, to actually use this, add the following lines before TEXT
in your .conkyrc (or whatever you've named it):
	lua_load /path/to/lua.lua
	lua_draw_hook_pre updatestats /path/to/config.lua

Any bug reported, minor or major, is appreciated.
Just make sure it isn't because of a sloppy config file, hmm?

Suggestions for improvement also welcome... after all,
this is mostly a learning experience on my part, both for the sake of
programming (Lua is awesome, BTW) and of desktop design (which I've been doing
for more than a year now, starting with Rainmeter in Windows).
(but... please don't bite me)

Documentation is still in lazy mode, I'll fix that some other time. :P

TO-DO:
- don't bother drawing if color is transparent
- draw image files
	- custom width & height
	- allow rotation
- variable-based...
	- images
	- colors
	- opacity
- conditional visibility
- straight indicator bars
	- w/ indicator lines
- add static shapes
	- lines (in progress)
	- rectangles*
	- triangles
	|
	- color
		- gradients
			- linear
			- radial
	- opacity
	- rotation

Gosh darn, Cairo vector manipulation is mind-blowing.

CHANGELOG:
- Not much .-.

Last updated 19 May 2015.

]]

-- include the vector manipulation library
require 'cairo'
 
-- converts hex codes (0xFFFFFF,0.5) to rgba format (1.0,1.0,1.0,0.5)
function hex_to_rgba(color,alpha)
	return ((color / 0x10000) % 0x100) / 255., ((color / 0x100) % 0x100) / 255., (color % 0x100) / 255., alpha
end

function str_to_table(string)
	tab={}
	for i = 1, #string do
		tab[i] = string:sub(i,i)
	end
	return tab
end

function get_length(value,axis,theta)
	
	local length = 0
	
	if axis=="x" then
		length = value*math.cos(theta)
	elseif axis=="y" then
		length = value*math.sin(theta)
	end
	
	return length
	
end
 
-- draws an indicator ring from table "pt"
function draw_ring(cr,t,pt)
	
	-- save the Conky window's width and height in "w" & "h" respectively
	local w,h=conky_window.width,conky_window.height
 
	-- save all the ring variables from a ring in table "pt" in local variables
	local xc,yc,ring_r,ring_w,sa,ea=pt.x,pt.y,pt.radius,pt.thickness,pt.start_angle,pt.end_angle
	local bgc, bga, fgc, fga=pt.bg_color, pt.bg_alpha, pt.fg_color, pt.fg_alpha
	local bg_cap, fg_cap=pt.bg_ring_cap, pt.fg_ring_cap
 
	-- convert "sa" to radians, shift it pi/2 ccw, then save it in "angle_0"
	local angle_0=math.rad(sa)-math.pi/2
	 
	-- convert "ea" to radians, shift it pi/2 ccw, then save it in "angle_f"
	local angle_f=math.rad(ea)-math.pi/2
	
	--[[ multiply "t" (a decimal bet. 0-1) with the angle difference
	i.e. the part that determines the value of the ring indicator ]]
	local t_arc=t*(angle_f-angle_0)
	
	-- if "center" is true...
	if pt.center==true then	
		-- set the coords as the center point, offset x & y
		xc=w/2+pt.x
		yc=h/2+pt.y
	end
 
	-- [BACKGROUND RING]
	
	--[[set the arc path from "angle_0" to "angle_f",
	drawn a "ring_r" distance away from the radius (xc,yc),
	at the drawing surface "cr"... basically ]]
	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
	
	--[[ set the color of the line to be drawn on that arc path
	"bgc" is the background color, "bga" is the background alpha ]]
	cairo_set_source_rgba(cr,hex_to_rgba(bgc,bga))
	
	-- set the width of that line as the thickness "ring_w"
	cairo_set_line_width(cr,ring_w)
	
	--[[ set the appropriate integer equivalents for the possible line caps for the background ring
	0 = CAIRO_LINE_CAP_BUTT (default) : start/stop the line exactly at the start/end point
	1 = CAIRO_LINE_CAP_ROUND : use a round ending, with the end point as the center of the circle
	2 = CAIRO_LINE_CAP_SQUARE : use a squared ending, with the end point as the center of the square ]]
	if bg_cap=="square" then bg_cap=2
	elseif bg_cap=="round" then bg_cap=1
	else bg_cap=0 end
	
	-- set the background ring's cap
	cairo_set_line_cap(cr,bg_cap)
	
	-- actually start drawing that line at the surface "cr"
	cairo_stroke(cr)
	
	-- [END BACKGROUND RING]
 
	-- [INDICATOR RING]
	
	--[[ set the arc path from "angle_0" to "angle_0" shifted "t_arc" clockwise
	since "t_arc" changes constantly depending on whatever variable you set it
	to monitor, the arc path will also adjust, and so does the drawn line ]]
	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
	
	--[[ set the color of the line to be drawn on that arc path
	"fgc" is the foreground color, "fga" is the foreground alpha ]]
	cairo_set_source_rgba(cr,hex_to_rgba(fgc,fga))
	
	-- set the appropriate integer equivalents for the possible line caps for the foreground ring
	if fg_cap=="square" then fg_cap=2
	elseif fg_cap=="round" then fg_cap=1
	else fg_cap=0 end
	
	-- set the background ring's cap
	cairo_set_line_cap(cr,fg_cap)
	
	-- actually start drawing that line at the surface "cr"
	cairo_stroke(cr)
	
	-- [END INDICATOR RING]
	
end -- draw_ring(cr,t,pt)

-- draws some text "txt" from table "pt"
function draw_text(cr,txt,pt)
	
	-- save the Conky window's width and height in "w" & "h" respectively
	local w,h=conky_window.width,conky_window.height
 
	-- save the text's coords
	local xc,yc=pt.x,pt.y
	
	-- save the text's appearance vars
	local f,bold,ita,obl,f_s,color,op,theta=pt.font,pt.bold,pt.italic,pt.oblique,pt.font_size,pt.color,pt.alpha,pt.theta
	
	-- convert boolean "bold" to a number (0s and 1s)
	bold = bold and 1 or 0
	
	--[[ convert the slant vars "ita" & "obl" to numbers
	0=normal, 1=italic, 2=oblique
	oblique takes precedence over italic if both are true ]]
	local slant=0
	if ita then slant = 1 end
    if obl then slant = 2 end
	
	-- if "center" is true...
	if pt.center==true then		
		-- set the coords as the center point, offset x & y
		xc=w/2+pt.x
		yc=h/2+pt.y
	end
	
	-- convert theta from degrees to radians
	theta=math.rad(theta)
	
	-- use "extents" as a way to get the metrics of a string of text
	local extents=cairo_text_extents_t:create()
	tolua.takeownership(extents) -- as indicated by "man conky"
	
	-- use "f_extents" as a way to get the metrics of the current font
	local f_extents=cairo_font_extents_t:create()
	tolua.takeownership(f_extents) -- as indicated by "man conky"
	
	-- set the text color "color" with "op" transparency
	cairo_set_source_rgba(cr,hex_to_rgba(color,op))
	-- set the font face of the text
	cairo_select_font_face (cr, f, slant, bold)
	-- set the font size of the text
	cairo_set_font_size (cr, f_s)
	
	-- try to set the antialias to NOT use subpixel rendering... it doesn't work for some reason though
	cfo = cairo_font_options_create() -- but it technically SHOULD
	cairo_font_options_set_antialias(cfo, CAIRO_ANTIALIAS_NONE)
	
	-- get the actual extents of the text
	cairo_text_extents(cr, "TgqpjA", extents)
	
	local t_height=extents.height
	
	-- get the actual extents of the text
	cairo_text_extents(cr, txt, extents)
	
	--[[ save the text metrics (extents) in local variables
	more info about the text extent values here:
		http://cairographics.org/manual/cairo-cairo-scaled-font-t.html#cairo-text-extents-t
	]]
	local t_x_bearing=extents.x_bearing
	local t_y_bearing=extents.y_bearing
	local t_width=extents.width
	
	-- get the actual extents of the current font
	cairo_font_extents(cr, f_extents)
	
	--[[ save the font metrics (extents) in local variables
	more info about the font extent values here:
		http://cairographics.org/manual/cairo-cairo-scaled-font-t.html#cairo-font-extents-t
	]]
	local f_descent=f_extents.descent
	local f_ascent=f_extents.ascent
	local f_height=f_extents.height
	
	-- initialize the text drawing coords
	local moveto_x,moveto_y=0,0
	
	--[[ and this is where trigonometrics comes in
	like, seriously, I took way too long just to get this thingamajiggly working ]]
	
	--[[ get the text dimensions relative to the x & y axis
	these are for the text alignment and rotation ]]
	local theta_x_length = (t_height*math.cos(theta-(math.pi/2)))+(t_width*math.cos(theta))
	local theta_y_length = (t_height*math.sin(theta-(math.pi/2)))+(t_width*math.sin(theta))
	local theta_x_bearing = (t_x_bearing*math.cos(theta))
	local theta_y_bearing = (t_y_bearing*math.sin(theta-(math.pi/2)))
	
	--[[ get the font dimensions relative to the y axis ]]
	local f_theta_height = (f_height*math.sin(theta-(math.pi/2)))
	local f_theta_ascent = (f_ascent*math.sin(theta-(math.pi/2)))
	local f_theta_descent = (f_descent*math.sin(theta-(math.pi/2)))
	
	-- horizontally align the text to the left (left when theta is 0, at least)
	if pt.h_align=="left" then moveto_x = xc - theta_x_bearing
	-- horizontally align the text to the right (right when theta is 0, at least)
	elseif pt.h_align=="right" then moveto_x = xc - theta_x_bearing - theta_x_length
	-- horizontally align the text to the center
	elseif pt.h_align=="center" then moveto_x = xc - ((theta_x_length+theta_x_bearing)/2) end
	
	-- vertically align the text to the top (top when theta is 0, at least)
	if pt.v_align=="top" then moveto_y = yc - theta_y_bearing
	-- vertically align the text to the bottom (when theta is 0, blah blah)
	elseif pt.v_align=="bottom" then moveto_y = yc - theta_y_bearing - theta_y_length
	-- vertically align the text to the middle
	elseif pt.v_align=="middle" then moveto_y = yc - ((theta_y_length+theta_y_bearing)/2) end
		
	-- move the active point to the drawing coords
	cairo_move_to (cr, moveto_x, moveto_y)
	
	-- DO A BARREL ROLL!
	cairo_rotate (cr, theta)
	
	-- draw the text on surface "cr" at the active point
	cairo_show_text (cr, txt)
	
end -- draw_text(cr,txt,pt)

-- draws a line, rotated "r" degrees, from table "pt"
function draw_line(cr,theta,pt)
	
	-- save the Conky window's width and height in "w" & "h" respectively
	local w,h=conky_window.width,conky_window.height
 
	-- save all the line's variables from a defined line in table "pt" in local variables
	local ls,le,width,color,alpha,cap=pt.line_start,pt.line_end,pt.line_width,pt.line_color,pt.line_alpha,pt.line_cap
	
	-- save the line's coords
	local xc,yc=pt.x,pt.y
	
	-- convert "r" to radians and save it back in "r"
	theta=math.rad(theta)
	
	-- if "center" is true...
	if pt.center==true then	
		-- set the coords as the center point, offset x & y
		xc=w/2+pt.x
		yc=h/2+pt.y
	end
	
	-- get the line dimensions, with rotation
	local line_start_x = xc + (ls*math.cos(theta))
	local line_start_y = yc + (ls*math.sin(theta))
	local line_end_x = xc + (le*math.cos(theta))
	local line_end_y = yc + (le*math.sin(theta))
	-- ugh, not trigonometry again
	
	--[[ set the color of the line to be drawn
	"color" is the line's color, "alpha" is the line's opacity ]]
	cairo_set_source_rgba(cr,hex_to_rgba(color,alpha))
	
	-- set the width of the line as "width"
	cairo_set_line_width(cr,width)
	
	--[[ set the appropriate integer equivalents for the possible line caps
	0 = CAIRO_LINE_CAP_BUTT (default) : start/stop the line exactly at the start/end point
	1 = CAIRO_LINE_CAP_ROUND : use a round ending, with the end point as the center of the circle
	2 = CAIRO_LINE_CAP_SQUARE : use a squared ending, with the end point as the center of the square ]]
	if cap=="square" then cap=2
	elseif cap=="round" then cap=1
	else cap=0 end
	
	-- set the line's cap
	cairo_set_line_cap(cr,cap)
	
	-- go to the line start coords
	cairo_move_to(cr, line_start_x, line_start_y);
	
	-- make a line path to to line end coords
	cairo_line_to(cr, line_end_x, line_end_y);
	
	-- actually start drawing that line at the surface "cr"
	cairo_stroke(cr)
	
end -- draw_line(cr,theta,pt)
 
--[[ updates the variables, then draws the rings
this function is repeated every time Conky updates ]]
function conky_updatestats(config_path)
	
	--[[ this basically reloads the config file every 2 updates... 'nuff said
	useful for setting up all the stuff to display, but you might want
	to comment these out if your config file won't be modified anymore...
	for the sake of getting a teensy bit more out of the system's resources
	not necessary tho ]]
	if tonumber(conky_parse('${updates}'))%2 == 1 then
		load_config = assert(loadfile(config_path))
		load_config()
	end
	
	-- [VARIABLE DEFAULTS FUNCTIONS]
	
	local function init_rings(pt)
		-- set the default values for the ring variables if they aren't set yet
		if pt.name==nil then pt.name='' end
		if pt.arg==nil then pt.arg='' end
		if pt.max==nil then pt.max=100 end
		if pt.value==nil then pt.value=100 end
		if pt.bg_color==nil then pt.bg_color=0x888888 end
		if pt.bg_alpha==nil then pt.bg_alpha=0 end
		if pt.fg_color==nil then pt.fg_color=0x000000 end
		if pt.fg_alpha==nil then pt.fg_alpha=1 end
		if pt.center==nil then pt.center=false end
		if pt.x==nil then pt.x=100 end
		if pt.y==nil then pt.y=100 end
		if pt.radius==nil then pt.radius=50 end
		if pt.thickness==nil then pt.thickness=10 end
		if pt.start_angle==nil then pt.start_angle=0 end
		if pt.end_angle==nil then pt.end_angle=360 end
		if pt.bg_line_cap==nil then pt.bg_line_cap=0 end
		if pt.fg_line_cap==nil then pt.fg_line_cap=0 end
	end
	
	local function init_text(pt)
		-- set the default values for the text variables if they aren't set yet
		if pt.name==nil then pt.name='' end
		if pt.arg==nil then pt.arg='' end
		if pt.parse_as_is==nil then pt.parse_as_is=false end
		if pt.font==nil then pt.font='Monospace' end
		if pt.bold==nil then pt.bold=false end
		if pt.italic==nil then pt.italic=false end
		if pt.oblique==nil then pt.oblique=false end
		if pt.font_size==nil then pt.font_size=20 end
		if pt.color==nil then pt.color=0x000000 end
		if pt.alpha==nil then pt.alpha=1 end
		if pt.center==nil then pt.center=false end
		if pt.x==nil then pt.x=100 end
		if pt.y==nil then pt.y=100 end
		if pt.theta==nil then pt.theta=0 end
		if pt.h_align==nil then pt.h_align='left' end
		if pt.v_align==nil then v_align='middle' end
	end
	
	local function init_lines(pt)
		-- also initialize the ring variables, 'cause some will be used
		init_rings(pt)
		-- set the default values for the line variables if they aren't set yet
		if pt.line_start==nil then pt.line_start=0 end
		if pt.line_end==nil then pt.line_end=100 end
		if pt.line_width==nil then pt.line_width=10 end
		if pt.line_color==nil then pt.line_color=0x000000 end
		if pt.line_alpha==nil then pt.line_alpha=1 end
		if pt.line_cap==nil then pt.line_cap=0 end
	end
	
	-- [END VARIABLE DEFAULTS FUNCTIONS]
	
	-- [DISPLAY SETUP FUNCTIONS]
	
	-- get the ring's (constantly updating) variables, then draw the ring 
	local function setup_rings(cr,pt)
		
		-- initialize the local variables before using them (a basic step)
		local str=''
		local value=0
		
		init_rings(pt)
		
		-- if the ring isn't set to be at a fixed value...
		if pt.name~="" then
			-- get variable and its argument/s to be parsed in Conky, then put it in "str"
			str=string.format('${%s %s}',pt.name,pt.arg)
			--[[ parse "str" into Conky, then put the result in "str"
			basically, let Conky read it as if it were in .conkyrc,
			then grab Conky's output and save it back into "str" ]]
			str=conky_parse(str)
			--[[ convert "str" into a number, then put the result in "value"
			so other functions could use this for arithmetic ]]
			value=tonumber(str)
			-- if "str" isn't even a number to start with, set "value" as 0
			if value == nil then value = 0 end
		-- if the ring is set to be at a fixed value...
		else
			-- save the value set as fixed in the settings, or just set it as the maximum by default
			value=pt.value
		end

		--[[ get decimal quotient (bet. 0-1, assuming max is right)
		of that "value" and its max, then put it in "pct" ]]
		pct=value/pt.max

		-- start drawing the ring with the updated variables
		draw_ring(cr,pct,pt)
		
	end -- setup_rings(cr,pt)
	
	-- get the text's (constantly updating) variables, then draw the text
	local function setup_text(cr,pt)
		
		-- initialize the local variables before using them (a basic step)
		local str=''
		
		init_text(pt)

		-- if the name is not to be taken as a whole...
		if not pt.parse_as_is then
			-- get variable and its argument/s to be parsed in Conky, then put it in "str"
			str=string.format('${%s %s}',pt.name,pt.arg)		
		else	
			-- otherwise, get the whole thing
			str=pt.name
		end
		
		--[[ parse "str" into Conky, then put the result in "str"
		basically, let Conky read it as if it were in .conkyrc,
		then grab Conky's output and save it back into "str" ]]
		str=conky_parse(str)

		-- start drawing the text with the updated variables
		draw_text(cr,str,pt)
		
	end -- setup_text(cr,pt)
	
	-- get the line's variables, then draw the line
	local function setup_ring_lines(cr,pt)
		
		-- initialize the theta variable
		local theta=0
		
		-- set the default values for the lines if they aren't set yet
		init_lines(pt)
		
		-- if use_lines is true...
		if pt.use_lines then
			-- initialize the indicator value
			local value=0
			
			-- if line_theta is not set or empty...
			if (pt.line_theta==nil) or (pt.line_theta=='') then
				-- if the ring isn't set to be at a fixed value...
				if pt.name~="" then
					-- get variable and its argument/s to be parsed in Conky, then put it in "str"
					str=string.format('${%s %s}',pt.name,pt.arg)
					--[[ parse "str" into Conky, then put the result in "str"]]
					str=conky_parse(str)
					--[[ convert "str" into a number, then put the result in "value"
					so other functions could use this for arithmetic ]]
					value=tonumber(str)
					-- if "str" isn't even a number to start with, set "value" as 0
					if value == nil then value = 0 end
				-- if the ring is set to be at a fixed value...
				else
					-- save the value set as fixed in the settings, or just set it as the maximum by default
					value=pt.value
				end

				-- get the decimal indicator value (between 0 and 1)
				local pct=value/pt.max
				-- get the start & end angles
				local sa,ea=pt.start_angle,pt.end_angle
				--[[ multiply "pct" (a decimal bet. 0-1) with the angle difference
				i.e. the part that determines the rotation of the line along a point ]]
				theta=pct*(ea-sa)-90
			-- if line_theta has a set value...
			else
				-- simply set "theta" as line_theta
				theta=pt.line_theta
			end
			
			-- start drawing the line
			draw_line(cr,theta,pt)
		end
		
	end -- setup_ring_lines(cr,pt)
	
	-- [END DISPLAY SETUP FUNCTIONS]
 
	-- if the Conky window hasn't been created yet, don't run the stuff below this line just yet
	if conky_window==nil then return end
	
	-- (Conky will then proceed to the following code after its window is finally created)
	
	-- set the drawing surface as "cs"
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual,conky_window.width,conky_window.height)
	
	--[[ if Conky has updated more than 5 times...
	(basically to delay the drawing by 5 updates)
	(because it would cause some errors if you don't)
	(just trust this, Conky will cry) ]]
	if tonumber(conky_parse('${updates}')) > 3 then	
		--[[ create a "cs" surface" in Conky as "cr_rings"
		i.e. all rings are rendered in this one surface ]]
		local cr_rings=cairo_create(cs)
		local cr_ring_lines=cairo_create(cs)
		
		-- if the "rings_settings" table actually exists...
		if type(rings_settings) == "table" then
			-- ... iterate over every "ring" set in the rings_settings...
			for i in pairs(rings_settings) do
					-- ... and do the stuff to actually show it in Conky
					setup_rings(cr_rings,rings_settings[i])
					-- ... including the indicator lines, if any
					setup_ring_lines(cr_ring_lines,rings_settings[i])
			end -- stop when i reaches nil (i.e. all the rings have been iterated through)
		end -- if
		
		-- if the "text_settings" table actually exists...
		if type(text_settings) == "table" then
			-- ... iterate over every "ring" set in the rings_settings...
			for i in pairs(text_settings) do
					--[[ ... create a "cs" surface in Conky as "cr_txt"
					i.e. each text is rendered on its own surface,
					to allow diff. individual rotation angles ]]
					local cr_txt=cairo_create(cs)	
					-- ... and do the stuff to actually show it in Conky
					setup_text(cr_txt,text_settings[i])
			end -- stop when i reaches nil (i.e. all the defined text blocks have been iterated through)
		end -- if
	end
	
end -- conky_updatestats()

-- fin