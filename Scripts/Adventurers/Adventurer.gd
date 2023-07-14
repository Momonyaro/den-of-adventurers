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

func set_state(new_state: Status) -> void:
	_status = new_state;

func update_state() -> void:
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
