--[[

Copied from config.lua, and edited to show stuff in the status bar.

]]



rings_settings = {} -- end rings_settings

text_settings = {
	{ -- date & time
		name='${time %a, %d %b, %H:%M}',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=true,
		italic=false,
		oblique=false,
		font_size=13,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=0, y=0,
		theta=0,
		h_align='center',
		v_align='middle'
	}, -- end date & time
	{ -- top
		name='top',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=true,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-650, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end top
	{ -- top process
		name='top',
		arg='name 1',
		parse_as_is=false,
		font='Myriad Pro',
		bold=false,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-629, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end top process
	
	{ -- cpu
		name='cpu',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=true,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-543, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end cpu
	{ -- top cpu
		name='cpu',
		arg='',
		parse_as_is=false,
		font='Myriad Pro',
		bold=false,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-521, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end top cpu
	
	{ -- mem
		name='mem',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=true,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-495, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end mem
	{ -- top mem
		name='memperc',
		arg='',
		parse_as_is=false,
		font='Myriad Pro',
		bold=false,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-466, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end top mem
	
	{ -- swap
		name='swap',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=true,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-440, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end swap
	{ -- top swap
		name='swapperc',
		arg='',
		parse_as_is=false,
		font='Myriad Pro',
		bold=false,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-410, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end top swap
	
	{ -- hd
		name='hd',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=true,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-385, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end hd
	{ -- used hd
		name='fs_used_perc',
		arg='/',
		parse_as_is=false,
		font='Myriad Pro',
		bold=false,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-367, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end used hd
	
	{ -- net
		name='net',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=true,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-385+45, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end net
	{ -- speed
		name='${downspeed wlp3s0}   /${upspeed wlp3s0}',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=false,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-367+50, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end speed
	
	{ -- desktop
		name='desktop',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=true,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-385+140, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end desktop
	{ -- desk name
		name='desktop_name',
		arg='',
		parse_as_is=false,
		font='Myriad Pro',
		bold=false,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=-367+168, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end desk name
	
	{ -- desktop
		name='now_playing',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=true,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=100, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end desktop
	{ -- desk name
		name='${if_match "${exec deadbeef --nowplaying "%t"}"!="nothing"}${exec ~/scripts/song_deadbeef title-artist 60}${else}[nothing]${endif}',
		arg='',
		parse_as_is=true,
		font='Myriad Pro',
		bold=false,
		italic=false,
		oblique=false,
		font_size=11,
		color=0xFFFFFF,
		alpha=1,
		center=true,
		x=169, y=0,
		theta=0,
		h_align='left',
		v_align='middle'
	}, -- end desk name
	
} -- end text_settings