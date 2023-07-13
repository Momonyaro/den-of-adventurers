extends Requirement
class_name PartyScoreAbove;

var _threshold: int = 0;

func validate(party: Party) -> bool:
	var party_score = party.get_party_score();
	return party_score > _threshold;

func get_requirement() -> String:
	return str("Have a Party Score above ", _threshold);

func _init(x: int):
	_threshold = x;
