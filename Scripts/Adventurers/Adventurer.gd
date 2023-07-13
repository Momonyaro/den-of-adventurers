extends Node
class_name Adventurer

enum AdventurerStatus { IDLE, ON_MISSION, DEAD };
enum AdventurerRace { HUMAN, DEMI_HUMAN };

var _name : String = "";
var _age : int = 0;
var _race : AdventurerRace = AdventurerRace.HUMAN; 
var _status : AdventurerStatus = AdventurerStatus.IDLE;

var _level : int = 0;
var _xp : Vector2i = Vector2i.ZERO;

func _init(name: String, age: int, level : int, race: AdventurerRace):
	_name = name;
	_age = age;
	_level = level;
	_race = race;
	pass;
