extends Node
class_name Party

enum PartyStatus {IDLE, GOING_TO_MISSION, ON_MISSION, RETURNING_FROM_MISSION, RETURNED}

var _title : String = "";
var _members : Array[Adventurer] = []
var _status : PartyStatus = PartyStatus.IDLE;

func get_party_score() -> int:
	var score : int = 0;
	for i in _members:
		if i == null: continue;
		score += i._level;
		
	return score;
