extends Panel

var card_prefab = preload('res://Prefabs/UI/solitaire/card.tscn');
var _spade_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/diskette.png");
var _heart_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/pc.png");
var _club_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/folder.png");
var _diamond_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/exit.png");

@export var _drawn_hand: Array[Control] = [];
@export var _tableau_area: Control = null;
@export var _y_offset_hidden = 8;
@export var _y_offset_visible = 24;
@export var _col_offset = 82 + 5;

var _board = BoardState.new();
var _redo = 0;

func _ready():
	get_child(1).get_child(4).visible = true;
	_board.board_update.connect(_on_board_update);
	_board.start_game();
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
	var _visible = Cards.get_facing(card) == Cards.FACING.FRONT;
	node.get_child(0).text = Cards.get_identifier(card) if _visible else "";
	node.get_child(1).text = Cards.get_identifier(card) if _visible else "";
	node.get_child(2).texture = _get_icon(Cards.get_leader(card)) if _visible else null;
	node.get_child(3).texture = _get_icon(Cards.get_leader(card)) if _visible else null;
	node.get_child(4).visible = !_visible;

func _on_board_update():
	get_child(1).show_behind_parent = _board._deck.size() == 0;
	_draw_hand();
	_draw_tableau();

func _draw_hand():
	for i in _drawn_hand.size():
		if _board._stock.size() <= i:
			_drawn_hand[i].visible = false;
		else:
			_drawn_hand[i].visible = true;
			_populate_card(_board._stock[i], _drawn_hand[i]);

func _draw_tableau():
	var basis = _tableau_area;
	var origo = _tableau_area.global_position;
	
	for i in _board._tableau.size():
		var col = _board._tableau[i];
		
		var _last_instance: Node = null;
		for j in col.size():
			var card = col[j];
			var x_pos = origo.x + (_col_offset * i);
			if _last_instance == null:
				_last_instance = card_prefab.instantiate();
				_tableau_area.add_child(_last_instance);
				_last_instance.global_position = Vector2(x_pos, origo.y);
				_populate_card(card, _last_instance);
			else:
				var last_card = col[j - 1];
				var _instance = card_prefab.instantiate();
				_last_instance.add_child(_instance);
				var _last_pos = _last_instance.global_position;
				var _y_offset = _y_offset_hidden if Cards.get_facing(last_card) == Cards.FACING.BACK else _y_offset_visible;
				_instance.global_position = Vector2(x_pos, _last_pos.y + _y_offset);
				_populate_card(card, _instance);
				_last_instance = _instance;

func _on_deck_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		_board.draw_to_stock(3);


class BoardState:
	var _base = []; # The actual tracker for card order during game.
	var _deck = []; # the deck that we can draw from
	var _stock = []; # the player's hand of cards
	var _tableau = [[], [], [], [], [], [], []]; # the cards on the field (represented by an array of 7 arrays of cards)
	var _foundation = [[], [], [], []]; # The end location of the cards, if the 4 arrays reach size() 13, the game is over.

	signal board_update();

	func start_game():
		_base = Cards.shuffle_deck(Cards.get_deck());
		_deck = _base.duplicate();
		_stock = [];
		fill_tableau();
		_foundation = [[], [], [], []];
		board_update.emit();

	func draw_to_stock(max_hand_count: int):
		_stock = [];
		if _deck.size() == 0:
			_refill_deck();
			return;
		for i in max_hand_count:
			if _deck.size() == 0:
				break;
			_stock.push_back(_draw_card());
		board_update.emit()

	func fill_tableau():
		_tableau = [[], [], [], [], [], [], []];
		
		for i in _tableau.size():
			for j in i + 1:
				_tableau[i].push_back(_draw_card());
				if j != i:
					_tableau[i][j] = Cards.flip_card(_tableau[i][j]);

	func _refill_deck():
		var _existing = _stock.duplicate();
		for _column in _tableau:
			_existing.append_array(_column);
		for _pile in _foundation:
			_existing.append_array(_pile);
		
		_deck = Cards.get_partial_deck(_base, _existing);
		board_update.emit()

	func _move_card(card: String, to: Array):
		to.push_back(card);
	
	func _draw_card() -> String:
		var draw = Cards.draw_card(_deck);
		_deck = draw[1];
		return draw[0];
