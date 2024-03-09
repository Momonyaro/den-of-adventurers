extends Panel

@onready var game_tab: Button = self.get_node("Panel/HBoxContainer/GAME_TAB");
@onready var video_tab: Button = self.get_node("Panel/HBoxContainer/VIDEO_TAB");
@onready var sound_tab: Button = self.get_node("Panel/HBoxContainer/SOUND_TAB");

@onready var game_panel: Control = self.get_node("MarginContainer/GAME_CONTAINER");
@onready var video_panel: Control = self.get_node("MarginContainer/VIDEO_CONTAINER");

func _ready():
    _on_change_tab('GAME');
    game_tab.toggled.connect(func (_value: bool): _on_change_tab('GAME'));
    video_tab.toggled.connect(func (_value: bool): _on_change_tab('VIDEO'));
    sound_tab.toggled.connect(func (_value: bool): _on_change_tab('SOUND'));

func _on_change_tab(id: String):
    match id:
        'GAME':
            game_tab.set_pressed_no_signal(true);
            video_tab.set_pressed_no_signal(false);
            sound_tab.set_pressed_no_signal(false);
            
            game_panel.visible = true;
            video_panel.visible = false;
        'VIDEO':
            game_tab.set_pressed_no_signal(false);
            video_tab.set_pressed_no_signal(true);
            sound_tab.set_pressed_no_signal(false);

            game_panel.visible = false;
            video_panel.visible = true;
        'SOUND':
            game_tab.set_pressed_no_signal(false);
            video_tab.set_pressed_no_signal(false);
            sound_tab.set_pressed_no_signal(true);

            game_panel.visible = false;
            video_panel.visible = false;