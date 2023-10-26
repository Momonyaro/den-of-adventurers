extends Panel

var card_prefab = preload('res://Prefabs/UI/solitaire/card.tscn');
var preview_prefab = preload('res://Prefabs/UI/windows/preview_rect.tscn');
var _spade_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/cards_spade.png");
var _heart_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/cards_heart.png");
var _club_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/cards_club.png");
var _diamond_icon: CompressedTexture2D = ResourceLoader.load("res://Textures/Icons/cards_diamond.png");

@export var _drawn_hand: Array[Control] = [];
@export var _tableau_area: Control = null;
@export var _y_offset_hidden = 8;
@export var _y_offset_visible = 24;
@export var _col_offset = 82 + 5;

var _board = BoardState.new();
var _drop_zones: Array = []; # structure [rect: Rect2, card_stack: Array]
var _holding: Array = []; # structure [card_stack: Array, from: Array]

func _ready():
	get_child(1).get_child(4).visible = true;
	_board.board_update.connect(_on_board_update);
	_board.start_game();
	for card in _drawn_hand:
		card.visible = false;

func _process(_delta):
	if Input.is_action_just_released("click") && _holding.size() > 0:
		if !_try_drop_in_zone():
			_holding[1].append_array(_holding[0]);
		_holding = [];
		_on_board_update();

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

func _populate_card(card: String, node: Control, card_ref: String):
	node.visible = true;
	var _visible = Cards.get_facing(card) == Cards.FACING.FRONT;
	node.get_child(0).text = Cards.get_identifier(card) if _visible else "";
	node.get_child(1).text = Cards.get_identifier(card) if _visible else "";
	node.get_child(2).texture = _get_icon(Cards.get_leader(card)) if _visible else null;
	node.get_child(3).texture = _get_icon(Cards.get_leader(card)) if _visible else null;
	node.get_child(4).visible = !_visible;
	if _visible:
		node.tooltip_text = Cards.card_name(card);
		if not node.get('_card_ref') == null:
			node._card_ref = card_ref;
			node._on_click = _on_card_input_callback;
	else:
		if not node.get('_card_ref') == null:
			node._card_ref = card_ref;
			node._on_click = _on_flip_input_callback;

func _on_board_update():
	_drop_zones = [];
	get_child(1).show_behind_parent = _board._deck.size() == 0;
	_draw_hand();
	_draw_tableau();

func _try_drop_in_zone() -> bool:
	var cards = _holding[0];
	var mouse_pos = get_global_mouse_position();

	for zone in _drop_zones:
		var rect = zone[0];
		var col = zone[1];
		var is_inside = rect.has_point(mouse_pos);
		if is_inside:
			col.append_array(cards);
			return true;
	
	return false;

func _draw_hand():
	for i in _drawn_hand.size():
		if _board._stock.size() <= i:
			_drawn_hand[i].visible = false;
		else:
			_drawn_hand[i].visible = true;
			_populate_card(_board._stock[i], _drawn_hand[i], str('stock:', i));

func _draw_tableau():
	var basis = _tableau_area;
	var origo = _tableau_area.global_position;
	for child in basis.get_children():
		child.queue_free();
	
	for i in _board._tableau.size():
		var col = _board._tableau[i];
		var x_pos = origo.x + (_col_offset * i);
		var _drop_instance = Rect2();
		_drop_instance.position = Vector2(x_pos - 2, origo.y - 2);
		var h = self.get_global_rect().size.y - basis.position.y;
		_drop_instance.size = Vector2(86, h + 2);
		_drop_zones.push_back([_drop_instance, col]);
		
		var _last_instance: Node = null;
		for j in col.size():
			var card = col[j];
			if _last_instance == null:
				_last_instance = card_prefab.instantiate();
				basis.add_child(_last_instance);
				_last_instance.global_position = Vector2(x_pos, origo.y);
				_populate_card(card, _last_instance, str('tableau:', i, ":", j));
			else:
				var last_card = col[j - 1];
				var _instance = card_prefab.instantiate();
				_last_instance.add_child(_instance);
				var _last_pos = _last_instance.global_position;
				var _y_offset = _y_offset_hidden if Cards.get_facing(last_card) == Cards.FACING.BACK else _y_offset_visible;
				_instance.global_position = Vector2(x_pos, _last_pos.y + _y_offset);
				_populate_card(card, _instance, str('tableau:', i, ":", j));
				_last_instance = _instance;

func _on_deck_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		_board.draw_to_stock(3);

func _on_card_input_callback(_card_ref: String):
	var split = Array(_card_ref.split(":"));

	var _only_top = false;
	var _grabs_following = false;
	var collection = [];
	match (split.pop_front()):
		'stock':
			_only_top = true;
			collection = _board._stock;
		'tableau':
			var col = int(split.pop_front());
			_grabs_following = true;
			collection = _board._tableau[col];
	
	var index = int(split.pop_front());
	if _only_top && index != collection.size() - 1:
		return;
	elif _only_top:
		_holding = [[collection[index]], collection];
		collection.remove_at(index);
	elif _grabs_following:
		var slice = collection.slice(0, index);
		var temp = collection.slice(index);
		collection.clear();
		collection.append_array(slice);
		_holding = [temp, collection];
	
	_on_board_update();

func _on_flip_input_callback(_card_ref: String):
	var split = Array(_card_ref.split(":"));
	var _ref = split.pop_front();
	var col = int(split.pop_front());
	var collection = _board._tableau[col];
	
	var index = int(split.pop_front());
	if index == (collection.size() - 1):
		collection[index] = Cards.flip_card(collection[index]);
		_on_board_update();

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
