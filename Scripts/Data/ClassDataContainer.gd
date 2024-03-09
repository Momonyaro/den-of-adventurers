class_name ClassDataContainer;

const classList: JSON = preload("res://Resources/Classes/ClassList.tres");

static func get_class_from_id(class_key: String) -> Dictionary: 
	return classList.data[class_key];

static func get_allowed_classes(nationality: Adventurer.Nationality, race: Adventurer.Race) -> Array:
	var class_data = classList.data;
	var nationality_str = Adventurer.Nationality.keys()[nationality];

	var to_return = [];
	for key in class_data.keys():
		var item = class_data[key] as Dictionary;
		var exludedNationalities = item['excludeForNationality'] as Array;
		
		if exludedNationalities.has(nationality_str):
			continue;

		if race == Adventurer.Race.HUMAN && item['isMagic']:
			continue;
		
		to_return.push_back(item);

	return to_return;

static func get_rand_class_w(nationality: Adventurer.Nationality, race: Adventurer.Race) -> Dictionary:
	var classes = ClassDataContainer.get_allowed_classes(nationality, race);

	var choices_dict = {};
	for item in classes:
		choices_dict[item['id']] = item['rarity'];
	
	var class_id = WeightedChoice.pick(choices_dict);
	return ClassDataContainer.get_class_from_id(class_id);
