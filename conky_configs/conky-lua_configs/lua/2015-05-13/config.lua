--[[

Documentation is still sloppy, bear with me.
If you want to really understand the behavior of 
certain variables, go and check out the main Lua file.

My main goal is to make a unified config for most
stuff that's added to Conky Lua setups: rings, text, lines, etc.

I take some examples, some code from others who have also done parts of
these before, and then insert it (sloppily) into the main Lua file, and
then modify it to add more options, so almost everything can be configured
here (ideally, but, not yet).

You can also separate the tables into different files, in case you have
some sort of "maximal" (contrast "minimal") setup with LOTS of stuff being
drawn all at once. You'll have to modify the main Lua file a wee bit, of course.

Anyways, have fun playing with this. :P

- serin113 (2015)

]]


--[[ universal coordinate variables
useful for setting the coords of several things
by just editing one variable 
that is, if you want to ]]
clock_ring_x=-100
clock_ring_y=200
clock_text_x=clock_ring_x
clock_text_y=clock_ring_y
desk_text_x=clock_ring_x
desk_text_y=clock_ring_y
ring_fg_color=0x1793D1
line_color=ring_fg_color
bg_rings_color=0x303030
ring_bg_color=ring_fg_color
text_color=ring_fg_color

 
--[[ create a new table containing the settings for the ring indicators to be shown
the rings will be created in descending order from top to bottom;
that is, the first ring is drawn first, then the second over that,
then the third over the second, etc. 
i.e. background rings go first, foreground rings next
despite it being named "rings_settings", it isn't limited to just rings...
you can also do line gauges (e.g. "speedometer"-style indicators);
just set the rings to be completely transparent ]]
rings_settings = {
	{ -- fixed clock bg ring
		--[[ "name" is the type of status to display (refer to Conky variables)
		if you want a non-updating ring, type this instead:
			name='',
		you can add a custom value that will only apply to static rings:
			value=100,
		]]
		name='',
		
		-- "arg" is the argument to the status type (refer to the arguments column in Conky variables)
		arg='',
		
		--[[ "max" is the maximum value of the ring
		100 (as in 100%) for percentage variables, 60 for minutes in an hour, etc.
		i.e. hour indicators will use 12, because there are 12 hours in a clock's face ]]
		max=60,
		
		--[[ "value" sets a custom fixed value for the ring
		this only takes effect if "name='<static>'"
		tip: if you want the fixed ring to be a whole circle, set it like this:
			value = max,
		]]
		value=60,
		
		-- "bg_color" is the hex color of the base ring
		bg_color=0xFFFFFF,
		
		--[[ "bg_alpha" is the alpha value of the base ring
		on a scale of 0 to 1; 0=transparent, 1=opaque ]]
		bg_alpha=0,
		
		-- "fg_color" is the hex color of the indicator part of the ring
		fg_color=bg_rings_color,
		
		--[[ "fg_alpha" is the alpha value of the indicator part of the ring
		on a scale of 0 to 1; 0=transparent, 1=opaque ]]
		fg_alpha=0.7,
		
		-- position the ring at the center of the window? boolean (i.e. true/false)
		center=true,
		
		--[[ "x" and "y" are the x & y coords of the centre of the ring,
		relative to the top left corner of the Conky window,
		unless "center" is true, in which case x & y will
		instead act as an offset from the window's center ]]
		x=clock_ring_x, y=clock_ring_y, -- universal variables are used here instead
		
		-- "radius" is the radius of the ring in pixels
		radius=42.5,
		
		--[[ "thickness" is the thickness of the ring in pixels, centred around the radius
		tip: if you want the ring to be a whole filled circle, set the thickness
		to be exactly 2 times the radius
		]]
		thickness=85,
		
		--[[ "start_angle" is the starting angle of the ring in degrees,
		clockwise from top, and can be either positive or negative ]]
		start_angle=0,
		
		--[[ "end_angle" is the ending angle of the ring in degrees,
		clockwise from top, can be either positive or negative,
		but must be larger (i.e. more clockwise) than start_angle ]]
		end_angle=360,
		
		--[[ should a line that follows the indicator be added? boolean (true/false)
		if this is false, then all the other "line_" options will have no effect at all
		and no line will be drawn ]]
		use_lines=false, -- since this is false, all other "line_..." options set below are merely fillers
		
		--[[ set the start distance of the line from the x & y coords
		will be ignored if "use_lines" is true ]]
		line_start=44.5,
		
		--[[ set the end distance of the line from the x & y coords
		will be ignored if "use_lines" is true ]]
		line_end=57.5,
		
		--[[ set the line cap of the straight line
		'butt': start/stop the line exactly at the start/end point
		'round': use a round ending, with the end point as the center of the circle
		'square': use a squared ending, with the end point as the center of the square
		(actually, any value other than 'round' or 'square' will default to 'butt')
		more about those here:
			http://www.cairographics.org/manual/cairo-cairo-t.html#cairo-line-cap-t
		]]
		line_cap='butt',
		
		--[[ set the line cap of the background ring (an arc line)
		same options as "line_cap", but this isn't affected by "use_lines" ]]
		bg_ring_cap='butt',
		
		--[[ set the line cap of the foreground ring (an arc line)
		same options as "line_cap", but this isn't affected by "use_lines" ]]
		fg_ring_cap='butt',
		
		--[[ set the width of the line
		will be ignored if "use_lines" is true ]]
		line_width=5,
		
		--[[ set the hex color of the line
		will be ignored if "use_lines" is true ]]
		line_color=0xFFFFFF,
		
		--[[ set the opacity of the line
		on a scale of 0 to 1; 0=transparent, 1=opaque
		will be ignored if "use_lines" is true ]]
		line_alpha=1,
		
		--[[ set a fixed tilt angle of the line
		if a number is entered here, the line will not follow the indicator
		i.e. it will simply be a static line
		if you want it to follow the indicator (e.g. clock hands), type the following:
			line_theta=''
		or, even simply, completely omit the whole line ]]
		line_theta=''	
	}, -- end fixed clock bg ring
	
	{ -- lower fixed bg ring	
		name='',
		arg='',
		max=100,
		value=100,
		bg_color=0xFFFFFF,
		bg_alpha=0,
		fg_color=bg_rings_color,
		fg_alpha=0.7,
		center=true,
		x=clock_ring_x, y=clock_ring_y,
		radius=106,
		thickness=42.7,
		start_angle=150,
		end_angle=210,
		use_lines=false,
		line_start=44.5,
		line_end=57.5,
		line_cap='butt',
		bg_ring_cap='butt',
		fg_ring_cap='butt',
		line_width=5,
		line_color=0xFFFFFF,
		line_alpha=1,
		line_theta=''	
	}, -- end lower fixed bg ring
	
	{ -- right fixed bg ring	
		name='',
		arg='',
		max=100,
		value=100,
		bg_color=0xFFFFFF,
		bg_alpha=0,
		fg_color=bg_rings_color,
		fg_alpha=0.7,
		center=true,
		x=clock_ring_x, y=clock_ring_y,
		radius=106,
		thickness=42.7,
		start_angle=60,
		end_angle=120,
		use_lines=false,
		line_start=44.5,
		line_end=57.5,
		line_cap='butt',
		bg_ring_cap='butt',
		fg_ring_cap='butt',
		line_width=5,
		line_color=0xFFFFFF,
		line_alpha=1,
		line_theta=''	
	}, -- end right fixed bg ring
	
	{ -- left fixed bg ring	
		name='',
		arg='',
		max=100,
		value=100,
		bg_color=0xFFFFFF,
		bg_alpha=0,
		fg_color=bg_rings_color,
		fg_alpha=0.7,
		center=true,
		x=clock_ring_x, y=clock_ring_y,
		radius=106,
		thickness=42.7,
		start_angle=60,
		end_angle=120,
		use_lines=false,
		line_start=44.5,
		line_end=57.5,
		line_cap='butt',
		bg_ring_cap='butt',
		fg_ring_cap='butt',
		line_width=5,
		line_color=0xFFFFFF,
		line_alpha=1,
		line_theta=''	
	}, -- end left fixed bg ring
	
	{ -- hour ring
		name='time',
		arg='%I',
		max=12,
		bg_color=ring_bg_color,
		bg_alpha=0.05,
		fg_color=ring_fg_color,
		fg_alpha=0.3,
		center=true,
		x=clock_ring_x, y=clock_ring_y,
		radius=47,
		thickness=20,
		start_angle=-0,
		end_angle=360,
		use_lines=true,
		line_start=38.5,
		line_end=54.5,
		line_cap='round',
		bg_ring_cap='butt',
		fg_ring_cap='butt',
		line_width=3,
		line_color=line_color,
		line_alpha=1,
		line_theta=''
	}, -- end hour ring
	
	{ -- minute ring
		name='time',
		arg='%M',
		max=60,
		bg_color=ring_bg_color,
		bg_alpha=0.05,
		fg_color=ring_fg_color,
		fg_alpha=0.5,
		center=true,
		x=clock_ring_x, y=clock_ring_y,
		radius=66,
		thickness=13,
		start_angle=0,
		end_angle=360,
		use_lines=true,
		line_start=61.5,
		line_end=70.5,
		line_cap='round',
		bg_ring_cap='butt',
		fg_ring_cap='butt',
		line_width=3,
		line_color=line_color,
		line_alpha=1,
		line_theta=''
	}, -- end minute ring
	
	{ -- seconds ring
		name='time',
		arg='%S',
		max=60,
		bg_color=ring_bg_color,
		bg_alpha=0.05,
		fg_color=ring_fg_color,
		fg_alpha=0.7,
		center=true,
		x=clock_ring_x, y=clock_ring_y,
		radius=78,
		thickness=6,
		start_angle=0,
		end_angle=360,
		use_lines=true,
		line_start=77,
		line_end=79,
		line_cap='round',
		bg_ring_cap='butt',
		fg_ring_cap='butt',
		line_width=3,
		line_color=line_color,
		line_alpha=1,
		line_theta=''
	}, -- end seconds ring
} -- end rings_settings


--[[ create a new table containing the settings for the text to be shown
the text will also be created in descending order from top to bottom;
that is, the first text is drawn first, then the second over that,
then the third over the second, etc. 
i.e. background text first, foreground text next, in case you want them stacked ]]
text_settings = {
	{ -- current hour text
		--[[ "name" is the status to display (refer to Conky variables)
		if "parse_name_whole=true", this will instead be read as a whole,
		to be parsed in Conky
		i.e. you can use this if it's enabled:
			name=conky_parse("${time %I:%M} in ${desktop_name}").."lorem ipsum",
		or even simply:
			name="insert static text here",
		]]
		name='time',
		
		-- "arg" is the argument to the status type (refer to the arguments column in Conky variables)
		arg='%H',
		
		--[[ should "name" alone be used to display variable text without arg? boolean (true/false)
		this will make "arg" disregarded
		this is most useful to display more than one variable at once,
		or to show static text instead of variable text ]]
		parse_as_is=false,
		
		--[[ "font" is the font of the text (duh)
		just make sure that the font actually exists in your computer, hmm? ]]
		font='Myriad Pro',
		
		-- should the text be bold? boolean (i.e. true/false)
		bold=true,
		
		-- should the text be italic? boolean (i.e. true/false)
		italic=false,
		
		--[[ should the text be oblique? boolean (i.e. true/false)
		if both "italic" and "oblique" are true, oblique will take precedence ]]
		oblique=false,
		
		-- "font_size" is the font size of the text
		font_size=30,
		
		-- "color" is the hex color of the text
		color=text_color,
		
		--[[ "alpha" is the alpha value of the text
		on a scale of 0 to 1; 0=transparent, 1=opaque ]]
		alpha=1,
		
		-- position the text at the center of the window? boolean (i.e. true/false)
		center=true,
		
		--[[ "x" and "y" are the x & y coords of the centre of the text,
		relative to the top left corner of the Conky window,
		unless "center" is true, in which case x & y will
		instead act as an offset from the window's center ]]
		x=clock_text_x, y=clock_text_y-3,
		
		--[[ "theta" is the rotation angle in degrees, clockwise, around the text origin
		the text origin is always at the bottom left side of the block of text,
		due to the way Cairo renders text ]]
		theta=0,
		
		--[[ "h_align" sets the horizontal alignment of the text from the x coord
		'left' = align left
		'right' = align right
		(anything other than left or right) = align center]]
		h_align='center', -- eh, I'll just name it 'center' for the sake of readability
		
		--[[ "v_align" sets the vertical alignment of the text from the y coord
		'top' = align top
		'bottom' = align bottom
		(anything other than top or bottom) = align middle ]]
		v_align='middle' -- whatever, I'll name this 'middle' JSYK that it's aligned in the middle
	}, -- end current hour text
	
	{ -- current minute text
		name='time',
		arg='%M',
		parse_as_is=false,
		font='Myriad Pro',
		bold=false,
		italic=false,
		oblique=false,
		font_size=30,
		color=text_color,
		alpha=1,
		center=true,
		x=clock_text_x, y=clock_text_y+19+3,
		theta=0,
		h_align='center',
		v_align='middle'
	}, -- end current minute text
	
	{ -- current date text
		name='time',
		arg='%d %b',
		parse_as_is=false,
		font='Myriad Pro',
		bold=false,
		italic=false,
		oblique=false,
		font_size=20,
		color=text_color,
		alpha=1,
		center=true,
		x=clock_text_x + 105, y=clock_text_y,
		theta=90,
		h_align='center',
		v_align='middle'
	}, -- end current date text
	
	{ -- current workspace text
		name='desktop_name',
		arg='',
		parse_as_is=false,
		font='Myriad Pro',
		bold=true,
		italic=false,
		oblique=false,
		font_size=17,
		color=text_color,
		alpha=1,
		center=true,
		x=desk_text_x, y=desk_text_y + 105,
		theta=0,
		h_align='center',
		v_align='middle'
	}, -- end current workspace text
	
	{ -- music text
		name='${exec ~/scripts/song_deadbeef title 60}',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=false,
		italic=false,
		oblique=false,
		font_size=15,
		color=text_color,
		alpha=1,
		center=true,
		x=clock_text_x - 70, y=clock_text_y - 70,
		theta=-45,
		h_align='center',
		v_align='middle'
	}, -- music text
} -- end text_settings