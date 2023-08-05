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

var _health : Vector2i = Vector2i(10, 10);
var _fatigue : float = 0; # When it reaches 1, the character needs 
# to rest and enters it's tired state if idle.

var _level : int = 1;
var _xp : Vector2i = Vector2i.ZERO;

#Timers
var TIMER_recruit : String;
var TIMER_resting : String;


func _init(given_name: String, family_name: String, age: int, 
health: int, level: int, race: Race, nationality: Nationality, adventurer_index: int):
	_given_name = given_name;
	_family_name = family_name;
	_age = age;
	_health = Vector2i(health, health);
	_level = level;
	_race = race;
	
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

func tick_fatigue(build_amount: float, falloff_amount: float) -> void:
	if _status == Status.AWAY: _fatigue = clampf(_fatigue + build_amount, 0, 1);
	elif _status == Status.EXHAUSTED: _fatigue = clampf(_fatigue - falloff_amount, 0, 1);
	
	update_status();

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
		Status.EXHAUSTED:
			if _fatigue == 0:
				_status = Status.IDLE;
			return;
		Status.IDLE:
			if _fatigue == 1:
				_status = Status.EXHAUSTED;
			return;

func name() -> String:
	return str(_given_name, " ", _family_name);

func race() -> String:
	match _race:
		Race.DEMI_HUMAN: return "Demi-Human";
		_: return "Human";

func _on_timer_done(id: String):
	match id:
		TIMER_recruit:
			set_status(Status.DISMISSED);
			print(str(D_T, " -> ", name(), " has been dismissed."));
			TIMER_recruit = "";
