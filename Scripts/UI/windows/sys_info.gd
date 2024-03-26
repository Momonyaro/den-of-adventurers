extends Panel

@export var _app_ver_label: RichTextLabel = null;
@export var _mem_used_label: RichTextLabel = null;
@export var _fps_count_label: RichTextLabel = null;
@export var _close_btn: Button = null;
var _window_base: Node = null;

func _ready():
	_app_ver_label.text = str("Build Version: ", ProjectSettings.get("global/app_version"));
	_close_btn.pressed.connect(_on_close);

func _process(_delta):
	var mem_usage: String = "%0.2f" % (OS.get_static_memory_usage() / 1000000.0); #tagged as debug only, might not work in finished game :(
	_mem_used_label.text = str("Used Memory: ", mem_usage, " MB");

	var fps: int = roundi(Engine.get_frames_per_second());
	_fps_count_label.text = str("Frames per Second: ", "%0.0f" % fps, " FPS (", "%0.0f" % ((1.0 / fps) * 1000), " ms)");

func _on_close():
	_window_base._on_win_close();
