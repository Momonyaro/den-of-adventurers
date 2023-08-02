class_name NamePool;

const blachol_txt_path : String = "res://Resources/Names/blachol.txt";
const vignarran_txt_path : String = "res://Resources/Names/vignarran_empire.txt";

var blachol_family : Array[String] = [];
var blachol_given : Array[String] = [];
var vignarran_family : Array[String] = [];
var vignarran_given : Array[String] = [];

var used_names : Array[String] = [];

func _init():
	parse_name_file(blachol_txt_path, blachol_family, blachol_given);
	parse_name_file(vignarran_txt_path, vignarran_family, vignarran_given);
	pass;

func get_new_name(nationality: Adventurer.Nationality) -> Array[String]:
	var family_pool = blachol_family;
	var given_pool = blachol_given;
	var family_name = "";
	var given_name = "";
	var i: int = 100;
	while i > 0:
		match nationality:
			Adventurer.Nationality.Blacholer: family_pool = blachol_family; given_pool = blachol_given;
			Adventurer.Nationality.Vignarran: family_pool = vignarran_family; given_pool = vignarran_given;
	
		family_name = family_pool[randi() % family_pool.size()];
		given_name = given_pool[randi() % given_pool.size()];
		if not used_names.has(str(family_name, "_", given_name)):
			used_names.push_back(str(family_name, "_", given_name));
			return [given_name, family_name];
		i -= 1;
	print(str("Failed to create unique name, reused: [", given_name, " ", family_name, "]"));
	return [given_name, family_name];

func reserve_name(given: String, family: String):
	var key = str(family, "_", given);
	if used_names.has(key):
		print("Name [", given, " ", family, "] already in use! Failed to reserve!");
	else:
		used_names.push_back(key);

func parse_name_file(path: String, family_pool: Array[String], given_pool: Array[String]):
	const f_n_marker : String = "--FAMILY";
	const g_n_f_marker : String = "--GIVEN_F";
	const g_n_m_marker : String = "--GIVEN_M";
	
	var file = FileAccess.open(path, FileAccess.READ);
	var dataTarget = "--FAMILY";
	var lineIndex = 0;
	while true:
		var line = file.get_line();
		if line == null or line.length() == 0:
			break;
		
		match line:
			f_n_marker: dataTarget = f_n_marker; continue;
			g_n_f_marker: dataTarget = g_n_f_marker; continue;
			g_n_m_marker: dataTarget = g_n_m_marker; continue;
		
		lineIndex += 1;
		
		match dataTarget:
			f_n_marker: family_pool.push_back(line);
			g_n_f_marker: given_pool.push_back(line);
			g_n_m_marker: given_pool.push_back(line);
	
	pass;
