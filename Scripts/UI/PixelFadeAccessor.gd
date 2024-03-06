extends TextureRect

@onready var mat = self.material as ShaderMaterial;

func _ready():
	mat.set_shader_parameter('resolution', get_window().size);
	_set_opacity(1);
	await get_tree().create_timer(1).timeout;
	_transition(1, 0, 1.2);

func _transition(from: float, to: float, duration: float):
	var tween = get_tree().create_tween();
	tween.tween_method(_set_opacity, from, to, duration);

func _set_opacity(value: float):
	mat.set_shader_parameter('opacity', value);
