extends TextureRect

@onready var mat = self.material as ShaderMaterial;
@export var delay = 1;
@export var dur = 1.2;
@export var play_on_ready = true;

func _ready():
	if !play_on_ready:
		return;
	
	mat.set_shader_parameter('resolution', get_window().size);
	_set_opacity(1);

	if delay > 0:
		await get_tree().create_timer(delay).timeout;
		
	await _transition(1, 0, dur);

func _transition(from: float, to: float, duration: float):
	var tween = get_tree().create_tween();
	tween.tween_method(_set_opacity, from, to, duration);

func _set_opacity(value: float):
	mat.set_shader_parameter('opacity', value);

func _col_to_vec4(value: Color):
	return Vector4(value.r, value.g, value.b, value.a);

func _set_color(value: Vector4):
	print(value)
	mat.set_shader_parameter('color', value);
