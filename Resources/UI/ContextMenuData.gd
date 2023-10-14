class_name ContextMenuData;

static func get_menu_data():
	return {
	'WIZ_ICON': {
		'Save Game': {
			'type': 'action',
			'icon': 'res://Textures/Icons/wizard.png',
			'msg': 'GAME_SAVE',
			'exclude_for': ['web']
		},
		'Load Game': {
			'type': 'action',
			'icon': 'res://Textures/Icons/timer.png',
			'msg': 'GAME_LOAD',
			'exclude_for': ['web']
		},
		'Quit Game': {
			'type': 'divider',
			'label_visible': false,
			'exclude_for': ['web']
		},
		'Quit...': {
			'type': 'folder',
			'items': {
				'Exit to Main Menu': {
					'type': 'big_action',
					'msg': 'GOTO_MAIN',
					'prompt_title': 'Quit to Main Menu',
					'prompt_warning': 'Are you sure? (Unsaved data will be lost.)',
					'ok_option': 'Yes, I\'m sure',
					'no_option': 'No'
				},
				'Exit to Desktop': {
					'type': 'big_action',
					'msg': 'GAME_QUIT',
					'exclude_for': ['web'],
					'prompt_title': 'Quit to Desktop',
					'prompt_warning': 'Are you sure? (Unsaved data will be lost.)',
					'ok_option': 'Yes, I\'m sure',
					'no_option': 'No',
				}
			}
		}
	},
	'View': {
		'Adventurers': {
			'type': 'action',
			'msg': 'WINDOW_ADVENTURERS_START'
		},
		'Hunting Parties': {
			'type': 'action',
			'msg': 'WINDOW_PARTIES_START'
		},
		'Requests': {
			'type': 'action',
			'msg': 'WINDOW_REQUESTS_START'
		}
	},
	'Programs': {
		'Distractions': {
			'type': 'folder',
			'items': {
				'Breakout': {
					'type': 'action',
					'msg': 'WINDOW_BREAKOUT_START'
				},
				'Solitaire': {
					'type': 'action',
					'msg': 'WINDOW_SOLITAIRE_START'
				}
			}
		}
	}

};
