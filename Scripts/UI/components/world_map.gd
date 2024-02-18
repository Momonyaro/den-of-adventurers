extends TextureRect

const GUILD_LOCATION_ID = "Hearhal (HOME)";
const ADV_MOVE_SPEED = 5.1; # km/h
@onready var map_nodes = $MapNodes.get_children();
@onready var flag = $FLAG;
@onready var line_2d: Line2D = $Line2D;

func _ready():
	clear_path();

func calculate_path(destination: String) -> float:
	var path = AStar.AStarFind(map_nodes, GUILD_LOCATION_ID, destination);
	var positions = path_to_positions(path);
	
	var target_pos = positions[-1];
	flag.visible = true;
	flag.position = target_pos + Vector2(-flag.size.x * 0.5, -flag.size.y * 1.25);
	line_2d.clear_points();

	var total_distance = 0;
	for i in positions.size():
		var current = positions[i];
		var next = positions[i + 1] if positions.size() > (i + 1) else null;

		if next != null:
			total_distance = total_distance + current.distance_to(next);

		line_2d.add_point(positions[i]);

	return (total_distance * 75) / ADV_MOVE_SPEED;

func clear_path():
	flag.visible = false;
	line_2d.clear_points();


func path_to_positions(path: Array) -> Array:
	var nodes = [];
	for point in path:
		var map_node = map_nodes.filter(func (n): return n.name == point);
		nodes.push_back(map_node[0].position + map_node[0].get_sprite_offset());
	return nodes;
