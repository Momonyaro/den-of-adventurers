extends Panel

@onready var vicinity_num: Label = $vicinity;
@onready var mine_spr: TextureRect = $mine;
@onready var flag_spr: TextureRect = $flag;
@onready var back_spr: NinePatchRect = $untouched;

var flipped: bool = false;
var piece_pos: Vector2i = Vector2i();
var click_callback: Callable = func (_piece, _vec: Vector2i): pass;

func _ready():
	vicinity_num.text = "";
	mine_spr.visible = false;
	flag_spr.visible = false;
	back_spr.visible = true;
	
func _on_gui_input(event:InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and back_spr.visible:
		click_callback.call(self, piece_pos);
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and back_spr.visible:
		flag_spr.visible = !flag_spr.visible;
	pass;
	
func flip(is_bomb: bool, proximity_num: int):
	flipped = true;
	if is_bomb:
		mine_spr.visible = true;
		self.self_modulate = Color.from_string("#bac6da", Color.RED);
	else:
		vicinity_num.text = str(proximity_num) if proximity_num > 0 else "";
	back_spr.visible = false;
	flag_spr.visible = false;