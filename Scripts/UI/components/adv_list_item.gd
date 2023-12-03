extends NinePatchRect

var _game_manager : GameManager = null;
@onready var content = $content;
@onready var human_icon = ResourceLoader.load("res://Textures/Icons/human.png");
@onready var demihuman_icon = ResourceLoader.load("res://Textures/Icons/demi-human.png");

func _ready():
	_game_manager = get_node("/root/Root/Game");

func populate(adventurer: Adventurer):
	content.visible = adventurer != null;
	if !content.visible:
		return;
	
	_draw_info(adventurer);
	pass;
		
func _draw_info(adventurer: Adventurer):
	var is_human = adventurer._race == Adventurer.Race.HUMAN;	
	
	get_node("%content/name").text = adventurer.adv_name();
	get_node("%content/race").texture = human_icon if is_human else demihuman_icon;
	get_node("%content/race").tooltip_text = "Human" if is_human else "Demi-Human";
	get_node("%content/level_race").text = str("Level ", adventurer._level, " ", adventurer._class);
	get_node("%content/current/text").text = str("Currently: ", adventurer.adv_status());
	get_node("%content/select_btn").pressed.connect(func(): _game_manager.select_agent.emit(adventurer._unique_id));