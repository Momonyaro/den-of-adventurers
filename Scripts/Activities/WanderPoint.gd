extends Node3D

@export var point_radius: float = 1;

@export_group("Debug")
@export var debug_draw = false;

func _ready():
	if debug_draw:
		var draw_bounds = Draw3D.new();
		add_child(draw_bounds);
		draw_bounds.circle_XZ(Vector3(0, 0.1, 0), point_radius, Color.TEAL);