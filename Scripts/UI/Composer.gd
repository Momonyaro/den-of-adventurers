extends Node

@export var sfx_play_on_awake: String = "";
@export var delay_awake_sfx: float = 0.4;

var _audio_cache = {};

func _ready():
	await get_tree().create_timer(delay_awake_sfx).timeout;
	if sfx_play_on_awake != "":
		play(sfx_play_on_awake);

func play(stream_path: String):
	var sfx: AudioStream = null;
	if _audio_cache.has(stream_path):
		sfx = _audio_cache[stream_path];
	else:
		sfx = ResourceLoader.load(stream_path);
		print(" [UI_SFX] -> Loaded new audio into buffer :: '", stream_path, "'");
		_audio_cache[stream_path] = sfx;
	
	var player: AudioStreamPlayer2D = _create_player();
	player.stream = sfx;
	player.play();
	player.finished.connect(func (): _on_player_finished(player));

func _create_player() -> AudioStreamPlayer2D:
	var player = AudioStreamPlayer2D.new();
	player.process_mode = Node.PROCESS_MODE_ALWAYS;
	self.add_child(player);
	return player;

func _on_player_finished(player: AudioStreamPlayer2D):
	if player.stream.resource_path == sfx_play_on_awake:
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn");

	player.stop();
	player.queue_free();
