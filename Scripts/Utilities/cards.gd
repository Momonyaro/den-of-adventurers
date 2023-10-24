class_name Cards

enum LEADERS {
	SPADES = 1,
	HEARTS = 2,
	CLUBS = 3,
	DIAMONDS = 4
}

const _deck = [
	'sA', 's2', 's3', 's4', 's5', 's6', 's7', 's8', 's9', 's10', 'sJ', 'sQ', 'sK', # SPADE
	'hA', 'h2', 'h3', 'h4', 'h5', 'h6', 'h7', 'h8', 'h9', 'h10', 'hJ', 'hQ', 'hK', # HEART
	'cA', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8', 'c9', 'c10', 'cJ', 'cQ', 'cK', # CLUB
	'dA', 'd2', 'd3', 'd4', 'd5', 'd6', 'd7', 'd8', 'd9', 'd10', 'dJ', 'dQ', 'dK', # DIAMOND
];

static func get_deck() -> Array:
	return _deck.duplicate();

static func get_partial_deck(deck: Array, exclude: Array) -> Array:
	var copy = deck.duplicate();
	return copy.filter(func (c): !exclude.has(c));

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

static func get_identifier(id: String) -> String:
	return id.substr(1);
