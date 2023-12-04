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

# Party score calculation:
# - It takes into account: level, stats(?) and items.
# - It would probably just be easier to do something like score = (level * l_mod) + (stats_score + s_mod) + (item_score * i_mod)
# - The _mod values in this case is just to be able to tweak the importance of some of these factors. (e.g. Item score modifier will likely be lower than level modifier)
# - The part we need to figure out is how the different stats factor in (or if they even do, I don't really see a way of using it...)
# - Probably just add the class as a variable instead for the level factor (level * class_mod * l_mod) => final value.
# - This method could be nice since it could make support classes decrease total party score but then instead lessen the provisions needed or something.