extends Requirement
class_name NoDemiHumans;

func validate(party: Party) -> bool:
	for i in party._members:
		if i._race == Adventurer.AdventurerRace.DEMI_HUMAN:
			return false;
	return true;

func get_requirement() -> String:
	return "No Demi-Humans in Party";
