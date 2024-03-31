extends Node

var name_pool : NamePool;
var adv_pool : AdventurerPool;
var initialized = false;

@onready var data_store = get_node("/root/Root/DataStore").hot_drive;

func _ready():
	randomize();
	var guild_data = data_store.data['guild_data'];

	name_pool = NamePool.new();
	adv_pool = AdventurerPool.new(name_pool, guild_data['guild_level'], guild_data['guildhall_tier']);
	
	initialized = true;
	pass;
