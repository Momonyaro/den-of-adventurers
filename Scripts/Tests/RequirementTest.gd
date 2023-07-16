extends Node2D

var testArr: Array[Requirement] = [
	Requirement.new(), 
	NoDemiHumans.new(),
	PartyScoreAbove.new(5)
];

var testParty: Party = Party.new();

func _ready():
	randomize();
	var pool = NamePool.new();
	
	for i in 4: 
		var name = pool.get_new_name(Adventurer.Nationality.Blacholer);
		var rand_race = Adventurer.Race.HUMAN;
		if randi() % 2 == 1:
			rand_race = Adventurer.Race.DEMI_HUMAN;
		testParty._members.push_back(Adventurer.new(name[0], name[1], 20, 5, 2, rand_race));
		print(str("Name: ", name, " Race: ", Adventurer.Race.keys()[rand_race]));
	
	for i in testArr:
		var result = i.validate(testParty);
		if result: print(str(i.get_requirement(), " ?? Success!"));
		else: print(str(i.get_requirement(), " ?? Fail!"));
	pass;
