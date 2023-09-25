extends PanelContainer

@export var name_label : Label;
@export var def_star : TextureRect;
@export var race_label : Label;
@export var state_label : Label;
@export var xp_bar : ProgressBar;
@export var fatigue_section : VBoxContainer;
@export var fatigue_bar : ProgressBar;
@export var recruit_btn : Button;

var _selected_agent : Agent = null;

func _ready():
	var game_manager : GameManager = get_node("/root/Root/Game");
	game_manager.select_agent.connect(_on_select_agent);
	visible = false;
	pass;

func _process(_delta):
	_draw_panel(_selected_agent);

func _draw_panel(agent: Agent):
	if agent == null: return;

	name_label.text = agent.adventurer.adv_name();
	def_star.visible = agent.adventurer._defined;
	race_label.text = str("Level ", agent.adventurer._level, " ", agent.adventurer.adv_race());
	state_label.text = agent.adventurer.adv_status();
	xp_bar.value = agent.adventurer.xp_percentage();
	fatigue_bar.value = agent.adventurer._fatigue;

	match agent.adventurer._status:
		Adventurer.Status.RECRUIT:
			recruit_btn.visible = true;
			xp_bar.visible = false;
			fatigue_section.visible = false;
		_:
			recruit_btn.visible = false;
			xp_bar.visible = true;
			fatigue_section.visible = true;


	pass;

func _on_select_agent(agent: Agent):
	_selected_agent = agent;
	visible = (agent != null);
	pass;


func _on_button_pressed():
	_selected_agent._recruit();
	pass;
