class_name Adventurer
const D_T = "    [ADV]";

enum Status { RECRUIT, IDLE, AWAY, RESTING, EXHAUSTED, EATING, DEAD, DISMISSED };
enum Race { HUMAN, DEMI_HUMAN };
enum Nationality { Blacholer, Montian, Vignarran };

# What's left to add is:
#  References to graphics (Body, Head, Hair and equipment)
#  

var _given_name : String = "";
var _family_name : String = "";
var _unique_id : String = "";
var _defined : bool = false;
var _age : int = 0;
var _race : Race = Race.HUMAN; 
var _nationality : Nationality = Nationality.Blacholer;
var _status : Status = Status.RECRUIT;
var _class : String = "";

var _health : Vector2i = Vector2i(10, 10);
var _fatigue : float = 0; # When it reaches 1, the character needs 
const FATIGUE_REST_TIME : float = 10 * 60;
# to rest and enters it's tired state if idle.

var _level : int = 1;
var _xp : Vector2i = Vector2i.ZERO;

#Wardrobe
var LOOK_race : String;
var LOOK_hat : String;
var LOOK_weapon : String;
var LOOK_hair : String;

#Timers
var TIMER_recruit : String;
var TIMER_resting : String;


func _init(given_name: String, family_name: String, age: int, 
health: int, level: int, race: Race, nationality: Nationality, adventurer_index: int = -1):
	_given_name = given_name;
	_family_name = family_name;
	_age = age;
	_health = Vector2i(health, health);
	_level = level;
	_race = race;
	_nationality = nationality;
	
	var toId = str(adventurer_index, "--", given_name, "_", family_name);
	_unique_id = Marshalls.utf8_to_base64(toId);
	pass;

func take_damage(amount: int) -> void:
	if _status == Status.DEAD: return;
	_health.x = clampi(_health.x - amount, 0, _health.y);
	if _health.x == 0:
		set_status(Status.DEAD);

func heal_damage(amount: int) -> void:
	if _status == Status.DEAD: return;
	_health.x = clampi(_health.x - amount, 0, _health.y);

func tick_fatigue(delta: float) -> void:
	var delta_amount = delta * (1.0 / FATIGUE_REST_TIME);
	if _status == Status.AWAY: _fatigue = clampf(_fatigue + delta_amount, 0, 1);
	elif _status == Status.EXHAUSTED: _fatigue = clampf(_fatigue - (delta_amount * 0.75), 0, 1);
	elif _status == Status.RESTING: _fatigue = clampf(_fatigue - delta_amount, 0, 1);
	
	update_status();

func add_xp(xp: int):
	_xp.x += xp;
	while _xp.x >= _xp.y:
		_xp.x = _xp.x - _xp.y;
		_level += 1;

func set_status(new_status: Status) -> void:
	_status = new_status;
	update_status();

func update_status() -> void:
	match _status:
		Status.DEAD: # Controlled externally via set_state()
			return;
		Status.AWAY: # Controlled externally via set_state()
			return;
		Status.RECRUIT: # Controlled externally via set_state()
			return;
		Status.RESTING:
			if _fatigue == 0:
				_status = Status.IDLE;
		Status.EXHAUSTED:
			if _fatigue == 0:
				_status = Status.IDLE;
			return;
		Status.IDLE:
			if _fatigue == 1:
				_status = Status.EXHAUSTED;
			return;

func adv_name() -> String:
	return str(_given_name, " ", _family_name);

func adv_race() -> String:
	match _race:
		Race.DEMI_HUMAN: return "Demi-Human";
		_: return "Human";

func adv_status() -> String:
	return Status.keys()[_status];

func adv_level() -> String:
	if _level == 30:
		return "MAX";
	else:
		return str(_level);

func xp_percentage() -> float:
	if _xp.y == 0:
		return 0;
	else: 
		return _xp.x / float(_xp.y);

func adv_dismiss():
	set_status(Status.DISMISSED);
	print(str(D_T, " -> ", adv_name(), " has been dismissed."));

func _on_timer_done(id: String):
	match id:
		TIMER_recruit:
			adv_dismiss();
			TIMER_recruit = "";

func to_dict() -> Dictionary:
	return {
		'_given_name': _given_name,
		'_family_name': _family_name,
		'_unique_id': _unique_id,
		'_defined': _defined,
		'_age': _age,
		'_race': _race,
		'_nationality': _nationality,
		'_status': _status,
		'_health': _health,
		'_fatigue': _fatigue,
		'_class': _class,
		'_level': _level, 
		'_xp': _xp,
		'LOOK_race': LOOK_race,
		'LOOK_hat': LOOK_hat,
		'LOOK_weapon': LOOK_weapon,
		'LOOK_hair': LOOK_hair,
		'TIMER_recruit': TIMER_recruit,
		'TIMER_resting': TIMER_resting
	};

static func from_dict(dict: Dictionary) -> Adventurer:
	var health = SettingsManager.string_to_vector2i(str(dict['_health']));
	var race = dict['_race'] as Race;
	var nationality = dict['_nationality'] as Nationality;

	var adv = Adventurer.new(dict['_given_name'], dict['_family_name'], dict['_age'], 0, dict['_level'], race, nationality);
	adv._unique_id = dict['_unique_id'];
	adv._status = dict['_status'];
	adv._health = health;
	adv._fatigue = dict['_fatigue'];
	adv._defined = dict['_defined'];
	adv._class = dict['_class'];
	adv.LOOK_race = dict['LOOK_race'];
	adv.LOOK_hat = dict['LOOK_hat'];
	adv.LOOK_weapon = dict['LOOK_weapon'];
	adv.LOOK_hair = dict['LOOK_hair'];
	adv.TIMER_recruit = dict['TIMER_recruit'];
	adv.TIMER_resting = dict['TIMER_resting'];

	return adv;
