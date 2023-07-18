extends Node

var name_pool : NamePool;
var adv_pool : AdventurerPool;
var initialized = false;

func _ready():
	randomize();
	name_pool = NamePool.new();
	adv_pool = AdventurerPool.new(name_pool);
	initialized = true;
