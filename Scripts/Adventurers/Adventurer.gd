extends Node
class_name Adventurer

enum Status { IDLE, ON_MISSION, TIRED, DEAD };
enum Race { HUMAN, DEMI_HUMAN };
enum Nationality { Blacholer, Montian, Vignarran };

var _name : String = "";
var _age : int = 0;
var _race : Race = Race.HUMAN; 
var _nationality : Nationality = Nationality.Blacholer;
var _status : Status = Status.IDLE;

var _health : Vector2i = Vector2i(10, 10);
var _fatigue : float = 0;

var _level : int = 0;
var _xp : Vector2i = Vector2i.ZERO;

func _init(name: String, age: int, health: int, level : int, race: Race):
	_name = name;
	_age = age;
	_health = Vector2i(health, health);
	_level = level;
	_race = race;
	pass;
