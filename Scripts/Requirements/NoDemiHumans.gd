extends Requirement
class_name NoDemiHumans;

func validate(party: Party, members: Array) -> bool:
	for adv in members:
		if adv == null: continue;
		if adv._race == Adventurer.Race.DEMI_HUMAN:
			return false;
	return true;

func get_requirement() -> String:
	return "No Demi-Humans in Party";
