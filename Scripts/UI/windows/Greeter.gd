extends Panel

@onready var content_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Label2;

func _ready():
    var username = _get_user_from_machine();
    content_label.text = str('Logging in "', username, '"...');

func _get_user_from_machine() -> String:
    var username = "Player"
    if OS.has_environment("USERNAME"):
        username = OS.get_environment("USERNAME");
    elif OS.has_environment("USER"):
        username = OS.get_environment("USER");
    
    return username;