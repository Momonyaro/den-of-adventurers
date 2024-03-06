extends Node

@onready var hot_drive: Persistence = self.get_child(0);

signal save_game(save_buffer: Dictionary);
signal load_game(loaded_data: SaveData);

func _ready():
	_load_game();
	pass

func _save_game():
	var data_buffer = hot_drive.data;
	save_game.emit(data_buffer);
	await get_tree().create_timer(0.2).timeout;
	data_buffer['saved_at'] = Time.get_datetime_string_from_unix_time(floori(Time.get_unix_time_from_system()));
	hot_drive.save();

func _load_game():
	_upgrade_save(hot_drive.data);
	load_game.emit(hot_drive.data);

func _upgrade_save(save_data: Dictionary):
	if save_data.size() == 0:
		var new_data = SaveData.new();
		for key in new_data.to_dict():
			hot_drive.data[key] = new_data[key];
		
	var version = hot_drive.data['version'];    

	while (true):
		version = hot_drive.data['version'];
		print(version);

		match version:
			'v3': break;
			'v2': _to_v3(hot_drive.data);
			'v1': _to_v2(hot_drive.data);
			_: _to_v1(hot_drive.data);


# --- UPGRADE FUNCTIONS ------------------------------------------

func _to_v1(raw_save: Dictionary):
	if !raw_save.has('guild_data'):
		var new_data = GuildData.new();
		raw_save['guild_data'] = new_data.to_dict();

	raw_save['version'] = 'v1';

func _to_v2(raw_save: Dictionary):
	if !raw_save.has('created_at'):
		raw_save['created_at'] = Time.get_datetime_string_from_unix_time(floori(Time.get_unix_time_from_system()));

	raw_save['version'] = 'v2';

func _to_v3(raw_save: Dictionary):
	if !raw_save.has('activities'):
		raw_save['activities'] = [];
	if !raw_save.has('parties'):
		raw_save['parties'] = [];

	raw_save['version'] = 'v3';

func _format_time(value: int):
	return str(0, value) if value < 10 else str(value);



# --- CLASSES ------------------------------------------------

class SaveData_v3 extends SaveData_v2:
	var activities: Array = [];
	var parties: Array = [];

class SaveData_v2 extends SaveData_v1:
	var created_at: String = "";

class SaveData_v1 extends SaveData:
	var guild_data: Dictionary = {};

class SaveData:
	var saved_at: String = "";
	var version: String = "v00";
	var timers: Array = [];
	var adventurers: Array = [];
	var agents: Array = [];
	var active_requests: Array = [];
	var completed_requests: Array = [];

	func to_dict() -> Dictionary:
		return {
			'version': version,
			'timers': timers,
			'adventurers': adventurers,
			'agents': agents,
			'active_requests': active_requests,
			'completed_requests': completed_requests
		};
