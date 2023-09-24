extends Node
class_name GameManager

var _selected_agent : Agent = null;

signal select_agent(new_agent: Agent);

func _ready():
    select_agent.connect(_on_select_agent);
    pass;

func _input(_ev):
    if Input.is_key_pressed(KEY_ESCAPE):
        select_agent.emit(null);

func _on_select_agent(agent: Agent):
    _selected_agent = agent;