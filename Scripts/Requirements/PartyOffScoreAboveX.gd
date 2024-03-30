extends Requirement
class_name PartyAtkScoreAbove;

var _threshold: int = 0;

func validate(party: Party, members: Array) -> bool:
	var party_score = party.get_atk_score(members);
	return party_score > _threshold;

func get_requirement() -> String:
	return str("Have a Party Score above ", _threshold);

func _init(x: int):
	_threshold = x;
