class_name WindowData;

static func get_window_data(key: String):
	if window_data.has(key):
		return [key, window_data[key]];
	else:
		return [null, null];

const window_data = {
	'SYS_INFO': {
		'title': 'About this PC...',
		'content_ref': 'res://Prefabs/UI/windows/sys_info.tscn',
		'has_close_btn': false
	},
	'VIDEO_SETTINGS': {
		'title': 'Video Settings',
		'content_ref': 'res://Prefabs/UI/windows/video_settings.tscn',
	},
	'SOLITAIRE': {
		'title': 'Solitaire',
		'content_ref': 'res://Prefabs/UI/windows/solitaire.tscn'
	},
	'MINESWEEPER': {
		'title': 'Minesweeper',
		'content_ref': 'res://Prefabs/UI/windows/minesweeper.tscn'
	},
	'ADV_PREVIEW': {
		'title': 'Adventurer',
		'content_ref': 'res://Prefabs/UI/windows/adv_preview.tscn'
	},
	'ADV_LIST': {
		'title': 'Adventurers',
		'content_ref': 'res://Prefabs/UI/windows/adventurers.tscn'
	}
}

