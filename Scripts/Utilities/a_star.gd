class_name AStar;

static func AStarFind(nodes: Array, start_id: String, goal_id: String):
	var internal_nodes = convert_nodes_to_internal_nodes(nodes);
	var start_node = get_node_by_name(internal_nodes, start_id);
	var goal_node = get_node_by_name(internal_nodes, goal_id);
	start_node._g = 0; 
	start_node._h = 0;

	var open: Array = [start_node];
	var closed: Array = [];

	while open.size() > 0:
		var current_node = get_lowest_f_in_list(open);
		move_node_between_lists(current_node, open, closed);

		if current_node._id == goal_node._id:
			var path = get_path_from_prev_nodes(current_node, internal_nodes);
			return path;
		
		for neighbor in current_node._neighbors:
			var neighbor_node = get_node_by_name(internal_nodes, neighbor);
			if node_in_list(neighbor_node, closed):
				continue;

			var calc_g = current_node._g + current_node._position.distance_to(neighbor_node._position);
			var calc_h = goal_node._position.distance_to(neighbor_node._position);

			if node_in_list(neighbor_node, open):
				if calc_g > neighbor_node._g:
					continue;
			
			var in_global_list = get_node_by_name(internal_nodes, neighbor_node._id);
			in_global_list._prev_node = current_node._id;
			open.push_back(InternalNode.new(neighbor_node._id, neighbor_node._neighbors, neighbor_node._position, current_node._id, calc_g, calc_h));
		
		pass;

	return []; # No path found, failed.

static func convert_nodes_to_internal_nodes(nodes: Array) -> Array:
	var to_return = [];
	for node in nodes:
		to_return.push_back(InternalNode.new(node.name, node.get_neighbors(), node.position, null));
	return to_return;

static func get_path_from_prev_nodes(node: InternalNode, all_nodes: Array) -> Array:
	var path = [];
	var current = node;
	while current != null:
		path.push_front(current._id);
		current = get_node_by_name(all_nodes, current._prev_node);
	return path;

static func get_node_by_name(nodes: Array, to_find) -> InternalNode:
	if to_find == null:
		return null;

	var result = nodes.filter(func (n): return n._id == to_find);
	if result.size() > 0:
		return result[0];
	else:
		return null;

static func node_in_list(node: InternalNode, list: Array) -> bool:
	var result = list.filter(func (n): return n._id == node._id);
	return result.size() > 0;

static func add_node_to_list(node: InternalNode, list: Array):
	list.push_back(node);

static func remove_node_from_list(node: InternalNode, list: Array):
	for item in list:
		if item._id == node._id:
			list.erase(item);
			return;

static func move_node_between_lists(node: InternalNode, list_from: Array, list_to: Array):
	add_node_to_list(node, list_to);
	remove_node_from_list(node, list_from);

static func get_lowest_f_in_list(nodes: Array) -> InternalNode:
	var lowest = null;
	for node in nodes:
		if lowest == null:
			lowest = node;
		else:
			if node.f() < lowest.f():
				lowest = node;
	return lowest;

class InternalNode:
	var _id: String;
	var _prev_node;
	var _neighbors: Array;
	var _position: Vector2;
	var _g: float;
	var _h: float;

	func f() -> float:
		return _g + _h;
	
	func _init(id: String, neighbors: Array, position: Vector2, prev_node = null, g: float = 999999999, h: float = 999999999):
		_id = id;
		_prev_node = prev_node;
		_neighbors = neighbors;
		_position = position;
		_g = g;
		_h = h;
