extends Panel

@export var _app_ver_label: RichTextLabel = null;
@export var _mem_used_label: RichTextLabel = null;
@export var _fps_count_label: RichTextLabel = null;

func _ready():
	_app_ver_label.text = str("[u]Build Version:[/u]  [i]", ProjectSettings.get("global/app_version"), "[/i]");

func _process(_delta):
	var mem_usage: String = "%0.2f" % (OS.get_static_memory_usage() / 1000000.0); #might break in production build :( Gonna see what I can do.
	_mem_used_label.text = str("[u]Used Memory:[/u]  [i]", mem_usage, " MB[/i]");

	var fps: int = roundi(Engine.get_frames_per_second());
	_fps_count_label.text = str("[u]Frames per Second:[/u]  [i]", "%0.0f" % fps, " FPS (", "%0.0f" % ((1.0 / fps) * 1000), " ms)[/i]");
