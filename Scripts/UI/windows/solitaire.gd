extends Panel

var card_prefab = preload('res://Prefabs/UI/solitaire/card.tscn');
@export var _drawn_hand: Array[Control] = [];
@onready var _spade_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/diskette.png");
@onready var _heart_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/pc.png");
@onready var _club_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/folder.png");
@onready var _diamond_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/exit.png");
var _deck = [];
var _stack = [];
const _flip_speed = 0.2;
var _instance: Node = null;
var _redo = 0;

func _ready():
	get_child(1).get_child(4).visible = true;
	_deck = Cards.get_deck();
	_deck = Cards.shuffle_deck(_deck);
	_stack = _deck.duplicate();
	for card in _drawn_hand:
		card.visible = false;

func _get_icon(leader: int) -> CompressedTexture2D:
	match(leader):
		Cards.LEADERS.SPADES:
			return _spade_icon;
		Cards.LEADERS.HEARTS:
			return _heart_icon;
		Cards.LEADERS.CLUBS:
			return _club_icon;
		_:
			return _diamond_icon;

func _populate_card(card: String, node: Control):
	node.visible = true;
	node.get_child(0).text = Cards.get_identifier(card);
	node.get_child(1).text = Cards.get_identifier(card);
	node.get_child(2).texture = _get_icon(Cards.get_leader(card));
	node.get_child(3).texture = _get_icon(Cards.get_leader(card));

func _on_deck_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		var can_draw = _stack.size();
		if can_draw == 0:
			_stack = _deck.duplicate(); # will be replaced with get_partial_deck once we have cards on the board
			for card in _drawn_hand:
				card.visible = false;
			get_child(1).show_behind_parent = false;
		else:
			for i in _drawn_hand.size():
				if can_draw == 0:
					_drawn_hand[i].visible = false;
					continue;
				var drawn = Cards.draw_card(_stack);
				var card = drawn[0];
				_stack = drawn[1];
				can_draw = _stack.size();
				_populate_card(card, _drawn_hand[i]);
			get_child(1).show_behind_parent = can_draw == 0;
