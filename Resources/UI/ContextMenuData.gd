class_name ContextMenuData;

static func get_menu_data():
    return {
    'WIZ_ICON': {
		'Save Game': {
			'type': 'action',
			'--icon': 'res://Textures/Icons/wizard.png',
			'msg': 'GAME_SAVE'
		},
		'Load Game': {
			'type': 'action',
			'--icon': 'res://Textures/Icons/timer.png',
			'msg': 'GAME_LOAD'
		},
		'Exit to Main Menu': {
			'type': 'big_action',
			'msg': 'GOTO_MAIN'
		},
		'Exit to Desktop': {
			'type': 'big_action',
			'msg': 'GAME_QUIT'
		}
	},
	'Programs': {
		'Breakout': {
			'type': 'action',
			'msg': 'DISTRACTION_BREAKOUT_START'
		},
		'Solitaire': {
			'type': 'action',
			'msg': 'DISTRACTION_SOLITAIRE_START'
		},
	}

};