extends Node2D

var testArr: Array[Requirement] = [
	Requirement.new(), 
	NoDemiHumans.new(),
	PartyScoreAbove.new(5)
];

var testParty: Party = Party.new();

func _ready():
	randomize();
	var name_pool = NamePool.new();
	var adv_pool = AdventurerPool.new(name_pool);
	
	print(name_pool.used_names.size());
	
	for id in adv_pool._adv_pool:
		var adv = adv_pool._adv_pool[id];
		print(str(adv.adv_name(), " -- ", id))
	
	testParty._members.push_back(adv_pool._adv_pool['MC0tQWVyaXRodXNfU8OzbA==']);
	testParty._members.push_back(adv_pool._adv_pool['MS0tTW9ucm9zZV9GYWVydGFn']);
	testParty._members.push_back(adv_pool._adv_pool['Mi0tQXRvdV9HcmFlbGk=']);
	
	for i in testArr:
		var result = i.validate(testParty);
		if result: print(str(i.get_requirement(), " ?? Success!"));
		else: print(str(i.get_requirement(), " ?? Fail!"));
	pass;
