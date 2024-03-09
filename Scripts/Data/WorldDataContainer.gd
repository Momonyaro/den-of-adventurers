class_name WorldDataContainer;

const population: JSON = preload("res://Resources/WorldData/population.tres");
const gender_ratio: JSON = preload("res://Resources/WorldData/gender_ratio.tres");
const race_ratio: JSON = preload("res://Resources/WorldData/race_ratio.tres");

static func get_rand_nationality_w() -> Adventurer.Nationality:
    var pop_data = population.data;
    var world_pop = pop_data.values().reduce(func(accum, number): return accum + number, 0);

    var weights = {};
    for key in pop_data:
        weights[key] = pop_data[key] / float(world_pop);
    
    var rand_pick = WeightedChoice.pick(weights);
    match rand_pick:
        #'Montia': return Adventurer.Nationality.Montian;   // Not yet implemented
        'Vignarran Emprire': return Adventurer.Nationality.Vignarran;
        _: return Adventurer.Nationality.Blacholer;

static func get_rand_gender_w(nationality: Adventurer.Nationality) -> String:
    var gen_ratio_data = gender_ratio.data;

    var male_ratio: float = 1;
    match nationality:
        Adventurer.Nationality.Montian: male_ratio = gen_ratio_data['Montia'];
        Adventurer.Nationality.Vignarran: male_ratio = gen_ratio_data['Vignarran Emprire'];
        _: male_ratio = gen_ratio_data['Blachol'];
    
    return WeightedChoice.pick({"MALE": male_ratio, "FEMALE": 1 - male_ratio});

static func get_rand_race_w(nationality: Adventurer.Nationality) -> Adventurer.Race:
    var race_ratio_data = race_ratio.data;

    var human_ratio: float = 1;
    match nationality:
        Adventurer.Nationality.Montian: human_ratio = race_ratio_data['Montia'];
        Adventurer.Nationality.Vignarran: human_ratio = race_ratio_data['Vignarran Emprire'];
        _: human_ratio = race_ratio_data['Blachol'];
    
    return WeightedChoice.pick({Adventurer.Race.HUMAN: human_ratio, Adventurer.Race.DEMI_HUMAN: 1 - human_ratio}) as Adventurer.Race;