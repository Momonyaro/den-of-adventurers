extends Node2D

var testArr: Array[Requirement] = [
	Requirement.new(), 
	NoDemiHumans.new(),
	PartyScoreAbove.new(5)
];

var testParty: Party = Party.new();

func _ready():
	testParty._members.push_back(Adventurer.new("Aerithus Sól", 19, 2, Adventurer.AdventurerRace.DEMI_HUMAN));
	testParty._members.push_back(Adventurer.new("Monrose Faertag", 19, 2, Adventurer.AdventurerRace.DEMI_HUMAN));
	testParty._members.push_back(Adventurer.new("Atou Graeli", 21, 3, Adventurer.AdventurerRace.HUMAN));
	
	for i in testArr:
		var result = i.validate(testParty);
		if result: print(str(i.get_requirement(), " ?? Success!"));
		else: print(str(i.get_requirement(), " ?? Fail!"));
	pass;
