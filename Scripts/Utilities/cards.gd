class_name Cards

enum LEADERS {
	SPADES = 1,
	HEARTS = 2,
	CLUBS = 3,
	DIAMONDS = 4
}

enum COLOR {
	RED,
	BLACK
}

enum FACING {
	FRONT,
	BACK
}

const _deck = [
	'sf1', 'sf2', 'sf3', 'sf4', 'sf5', 'sf6', 'sf7', 'sf8', 'sf9', 'sf10', 'sf11', 'sf12', 'sf13', # SPADE
	'hf1', 'hf2', 'hf3', 'hf4', 'hf5', 'hf6', 'hf7', 'hf8', 'hf9', 'hf10', 'hf11', 'hf12', 'hf13', # HEART
	'cf1', 'cf2', 'cf3', 'cf4', 'cf5', 'cf6', 'cf7', 'cf8', 'cf9', 'cf10', 'cf11', 'cf12', 'cf13', # CLUB
	'df1', 'df2', 'df3', 'df4', 'df5', 'df6', 'df7', 'df8', 'df9', 'df10', 'df11', 'df12', 'df13', # DIAMOND
];

static func get_deck() -> Array:
	return _deck.duplicate();

static func get_partial_deck(deck: Array, exclude: Array) -> Array:
	if exclude.size() == 0: 
		return deck.duplicate();
	
	var stripped_exclude = exclude.map(func (e): return _ignore_facing(e));
	var copy = [];
	for card in deck:
		var no_facing = _ignore_facing(card);
		if stripped_exclude.has(no_facing) == false:
			copy.push_back(card);
		
	return copy;

static func draw_card(deck: Array) -> Array:
	var card = deck.pop_front();
	return [card, deck];

static func shuffle_deck(deck: Array) -> Array:
	deck.shuffle();
	return deck;

static func card_name(id: String) -> String:
	var leader = id[0];
	var _id = get_identifier_as_num(id);
	var card_name = "";
	
	match(leader):
		's': leader = "Spades";
		'h': leader = "Hearts";
		'c': leader = "Clubs";
		'd': leader = "Diamonds";
	
	match (_id):
		1: card_name = 'Ace';
		11: card_name = 'Jack';
		12: card_name = 'Queen';
		13: card_name = 'King';
		_: card_name = str(_id);
	
	return str(card_name, " of ", leader);

static func get_leader(id: String) -> int:
	var leader = id[0];
	match(leader):
		's': return LEADERS.SPADES;
		'h': return LEADERS.HEARTS;
		'c': return LEADERS.CLUBS;
		'd': return LEADERS.DIAMONDS;
	return -1;

static func get_facing(id: String) -> int:
	var facing = id[1];
	match(facing):
		'f': return FACING.FRONT
		_:   return FACING.BACK

static func get_color(id: String) -> int:
	var leader = get_leader(id);
	match(leader):
		LEADERS.SPADES or LEADERS.CLUBS: return COLOR.BLACK;
		_: return COLOR.RED;

static func is_same_color(a: String, b: String) -> bool:
	var a_col = get_color(a);
	var b_col = get_color(b);
	return a_col == b_col;

static func is_same_card(a: String, b: String) -> bool:
	return _ignore_facing(a) == _ignore_facing(b);

static func flip_card(id: String) -> String:
	var facing = get_facing(id);
	var stripped = _ignore_facing(id);
	var rev_facing = 'f' if facing == FACING.BACK else 'b';
	return stripped.insert(1, rev_facing);

static func _ignore_facing(id: String) -> String:
	return str(id[0], get_identifier_as_num(id))

static func get_identifier(id: String) -> String:
	var _id = get_identifier_as_num(id);
	match (_id):
		1: return 'A';
		11: return 'J';
		12: return 'Q';
		13: return 'K';
		_: return str(_id);

static func get_identifier_as_num(id: String) -> int:
	var _id = id.substr(2);
	return int(_id);
