class_name ContextMenuData;

static func get_menu_data():
	return {
	'WIZ_ICON': {
		'Save Game': {
			'type': 'action',
			'icon': 'res://Textures/Icons/wizard.png',
			'msg': 'GAME_SAVE'
		},
		'Load Game': {
			'type': 'action',
			'icon': 'res://Textures/Icons/timer.png',
			'msg': 'GAME_LOAD'
		},
		'Quit...': {
			'type': 'folder',
			'items': {
				'Exit to Main Menu': {
					'type': 'big_action',
					'msg': 'GOTO_MAIN',
					'prompt_title': 'Quit to Main Menu',
					'prompt_warning': 'Are you sure? (Unsaved data will be lost.)',
					'ok_option': 'Yes',
					'no_option': 'No'
				},
				'Exit to Desktop': {
					'type': 'big_action',
					'msg': 'GAME_QUIT',
					'prompt_title': 'Quit to Desktop',
					'prompt_warning': 'Are you sure? (Unsaved data will be lost.)',
					'ok_option': 'Yes',
					'no_option': 'No',
				}
			}
		}
	},
	'Programs': {
		'Distractions': {
			'type': 'folder',
			'items': {
				'Breakout': {
					'type': 'action',
					'msg': 'DISTRACTION_BREAKOUT_START'
				},
				'Solitaire': {
					'type': 'action',
					'msg': 'DISTRACTION_SOLITAIRE_START'
				}
			}
		}
	}

};
