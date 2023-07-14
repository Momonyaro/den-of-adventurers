extends Node
class_name Adventurer

enum Status { IDLE, ON_MISSION, TIRED, DEAD };
enum Race { HUMAN, DEMI_HUMAN };
enum Nationality { Blacholer, Montian, Vignarran };

# What's left to add is:
#  References to graphics (Body, Head, Hair and equipment)
#  

var _name : String = "";
var _age : int = 0;
var _race : Race = Race.HUMAN; 
var _nationality : Nationality = Nationality.Blacholer;
var _status : Status = Status.IDLE;

var _health : Vector2i = Vector2i(10, 10);
var _fatigue : float = 0; # When it reaches 1, the character needs to rest and enters it's sleeping state if idle.

var _level : int = 0;
var _xp : Vector2i = Vector2i.ZERO;

func _init(name: String, age: int, health: int, level : int, race: Race):
	_name = name;
	_age = age;
	_health = Vector2i(health, health);
	_level = level;
	_race = race;
	pass;

func take_damage(amount: int) -> void:
	_health.x = clampi(_health.x - amount, 0, _health.y);
	if _health.x == 0:
		set_status(Status.DEAD);

func heal_damage(amount: int) -> void:
	if _status == Status.DEAD: return;
	_health.x = clampi(_health.x - amount, 0, _health.y);

func tick_fatigue(build_amount: float, falloff_amount: float) -> void:
	if _status == Status.ON_MISSION: _fatigue = clampf(_fatigue + build_amount, 0, 1);
	elif _status == Status.TIRED: _fatigue = clampf(_fatigue - falloff_amount, 0, 1);
	
	update_status();

func set_status(new_status: Status) -> void:
	_status = new_status;
	update_status();

func update_status() -> void:
	match _status:
		Status.DEAD: # Controlled externally via set_state()
			return;
		Status.ON_MISSION: # Controlled externally via set_state()
			return;
		Status.TIRED:
			if _fatigue == 0:
				_status = Status.IDLE;
			return;
		Status.IDLE:
			if _fatigue == 1:
				_status = Status.TIRED;
			return;
