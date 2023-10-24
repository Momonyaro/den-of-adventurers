class_name ContextMenuData;

static func get_menu_data():
	return {
	'WIZ_ICON': {
		'System Information': {
			'type': 'action',
			'icon': 'res://Textures/Icons/pc.png',
			'msg': 'WINDOW:OPEN:SYS_INFO'
		},
		'save_divider': {
			'type': 'divider',
			'label_visible': false,
			'exclude_for': ['web']
		},
		'Save Game': {
			'type': 'action',
			'icon': 'res://Textures/Icons/save.png',
			'msg': 'GAME_SAVE',
			'exclude_for': ['web']
		},
		'Load Game': {
			'type': 'action',
			'icon': 'res://Textures/Icons/load.png',
			'msg': 'GAME_LOAD',
			'exclude_for': ['web']
		},
		'settings_divider': {
			'type': 'divider',
			'label_visible': false,
			'exclude_for': ['web']
		},
		'Settings...': {
			'type': 'folder',
			'icon': 'res://Textures/Icons/options.png',
			'items': {
				'Video Settings': {
					'type': 'action',
					'icon': 'res://Textures/Icons/pc.png',
					'msg': 'WINDOW:OPEN:VIDEO_SETTINGS'
				},
				'Audio Settings': {
					'type': 'action',
					'icon': 'res://Textures/Icons/speaker.png',
					'msg': 'WINDOW:OPEN:AUDIO_SETTINGS'
				}
			}
		},
		'quit_divider': {
			'type': 'divider',
			'label_visible': false
		},
		'Quit...': {
			'type': 'folder',
			'icon': 'res://Textures/Icons/exit.png',
			'items': {
				'Exit to Main Menu': {
					'type': 'big_action',
					'msg': 'GOTO_MAIN',
					'prompt_title': 'Quit to Main Menu',
					'prompt_warning': 'Are you sure? (Unsaved data will be lost.)',
					'prompt_icon': 'res://Textures/Icons/exit.png',
					'ok_option': 'Yes, I\'m sure',
					'no_option': 'No'
				},
				'Exit to Desktop': {
					'type': 'big_action',
					'msg': 'GAME_QUIT',
					'exclude_for': ['web'],
					'prompt_title': 'Quit to Desktop',
					'prompt_warning': 'Are you sure? (Unsaved data will be lost.)',
					'prompt_icon': 'res://Textures/Icons/pc_sad.png',
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
			'icon': 'res://Textures/Icons/folder.png',
			'items': {
				'Breakout': {
					'type': 'action',
					'msg': 'WINDOW_BREAKOUT_START'
				},
				'Solitaire': {
					'type': 'action',
					'icon': 'res://Textures/Icons/solitaire.png',
					'msg': 'WINDOW:OPEN:SOLITAIRE'
				}
			}
		}
	}

};
