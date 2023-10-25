class_name Cards

enum LEADERS {
	SPADES = 1,
	HEARTS = 2,
	CLUBS = 3,
	DIAMONDS = 4
}

enum FACING {
	FRONT,
	BACK
}

const _deck = [
	'sfA', 'sf2', 'sf3', 'sf4', 'sf5', 'sf6', 'sf7', 'sf8', 'sf9', 'sf10', 'sfJ', 'sfQ', 'sfK', # SPADE
	'hfA', 'hf2', 'hf3', 'hf4', 'hf5', 'hf6', 'hf7', 'hf8', 'hf9', 'hf10', 'hfJ', 'hfQ', 'hfK', # HEART
	'cfA', 'cf2', 'cf3', 'cf4', 'cf5', 'cf6', 'cf7', 'cf8', 'cf9', 'cf10', 'cfJ', 'cfQ', 'cfK', # CLUB
	'dfA', 'df2', 'df3', 'df4', 'df5', 'df6', 'df7', 'df8', 'df9', 'df10', 'dfJ', 'dfQ', 'dfK', # DIAMOND
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
	var card_name = id.substr(1);
	
	match(leader):
		's': leader = "Spades";
		'h': leader = "Hearts";
		'c': leader = "Clubs";
		'd': leader = "Diamonds";
	
	match (card_name):
		'A': card_name = 'Ace';
		'J': card_name = 'Jack';
		'Q': card_name = 'Queen';
		'K': card_name = 'King';
		_: card_name = card_name;
	
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

static func flip_card(id: String) -> String:
	var facing = get_facing(id);
	var stripped = _ignore_facing(id);
	var rev_facing = 'f' if facing == FACING.BACK else 'b';
	return stripped.insert(1, rev_facing);

static func _ignore_facing(id: String) -> String:
	return str(id[0], id.substr(2))

static func get_identifier(id: String) -> String:
	return id.substr(2);
