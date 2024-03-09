class_name NamePool;

var blachol_txt : JSON = ResourceLoader.load("res://Resources/Names/blachol.tres");
var vignarran_txt : JSON = ResourceLoader.load("res://Resources/Names/vignarran_empire.tres");

var blachol_family : Array[String] = [];
var blachol_m_given : Array[String] = [];
var blachol_f_given : Array[String] = [];

var vignarran_family : Array[String] = [];
var vignarran_m_given : Array[String] = [];
var vignarran_f_given : Array[String] = [];

var used_names : Array[String] = [];

func _init():
	parse_name_file(blachol_txt, blachol_family, blachol_m_given, blachol_f_given);
	parse_name_file(vignarran_txt, vignarran_family, vignarran_m_given, vignarran_f_given);
	pass;

func get_new_name(nationality: Adventurer.Nationality, gender: String) -> Array[String]:
	var family_pool = [];
	var given_pool = [];
	var family_name = "";
	var given_name = "";
	var i: int = 100;
	while i > 0:
		match nationality:
			Adventurer.Nationality.Blacholer: family_pool = blachol_family; given_pool = blachol_m_given if gender == 'MALE' else blachol_f_given;
			Adventurer.Nationality.Vignarran: family_pool = vignarran_family; given_pool = vignarran_m_given if gender == 'MALE' else vignarran_f_given;
	
		family_name = family_pool[randi() % family_pool.size()];
		given_name = given_pool[randi() % given_pool.size()];
		if not used_names.has(str(family_name, "_", given_name).to_lower()):
			used_names.push_back(str(family_name, "_", given_name).to_lower());
			return [given_name, family_name];
		i -= 1;
	print(str("Failed to create unique name, reused: [", given_name, " ", family_name, "]"));
	return [given_name, family_name];

func reserve_name(given: String, family: String):
	var key = str(family, "_", given).to_lower();
	if used_names.has(key):
		print("Name [", given, " ", family, "] already in use! Failed to reserve!");
	else:
		used_names.push_back(key);

func delete_reserved_name(key: String):
	if used_names.has(key):
		used_names.erase(key);
		print("[NAME_P!] -> UNREGISTERED NAME FROM POOL -> ", key);

func parse_name_file(json_data: JSON, family_pool: Array[String], given_m_pool: Array[String], given_f_pool: Array[String]):
	var data = json_data.data;
	family_pool.append_array(data['family']);
	given_f_pool.append_array(data['given_f']);
	given_m_pool.append_array(data['given_m']);
	pass;
