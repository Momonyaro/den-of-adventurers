extends Requirement
class_name PartyMembersEquals;

var _threshold: int = 0;

func validate(party: Party, members: Array) -> bool:
	var member_count = party._members.size();
	return member_count == _threshold;

func get_requirement() -> String:
	return str("Party has exactly ", _threshold, " member(s).");

func _init(x: int):
	_threshold = x;
