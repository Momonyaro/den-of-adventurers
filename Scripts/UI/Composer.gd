extends Node

var _audio_cache = {};

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
	self.add_child(player);
	return player;

func _on_player_finished(player: AudioStreamPlayer2D):
	player.stop();
	player.queue_free();
