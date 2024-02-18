extends TextureRect

@export var _neighbors: Array[NodePath] = [];

func _ready():
    self.tooltip_text = self.name;

func get_sprite_offset():
    var width = size.x;
    var height = size.y;

    return Vector2(width / 2, height / 2);    

func get_neighbors():
    var to_return = [];
    for neighbor in _neighbors:
        var node = get_node(neighbor);
        to_return.push_back(node.name);
    return to_return;