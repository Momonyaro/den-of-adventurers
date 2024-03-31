extends Requirement
class_name PartySupScoreBelow;

var _threshold: int = 0;

func validate(party: Party, members: Array) -> bool:
	var party_score = Party.get_sup_score(members);
	return party_score <= _threshold;

func get_requirement() -> String:
	return str("Party DEF score below ", _threshold + 1,);

func _init(x: int):
	_threshold = x;
