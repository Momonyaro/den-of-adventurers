extends Node

var _audio_cache = {};

func play(stream_path: String):
	var sfx: AudioStream = null;
	if _audio_cache.has(stream_path):
		sfx = _audio_cache[stream_path];
	else:
		sfx = ResourceLoader.load(stream_path);
		_audio_cache[stream_path] = sfx;
	
	var player: AudioStreamPlayer2D = _create_player();
	self.add_child(player);
	player.stream = sfx;
	player.play();
	player.finished.connect(func (): _on_player_finished(player));

func _create_player() -> AudioStreamPlayer2D:
	return AudioStreamPlayer2D.new();

func _on_player_finished(player: Node):
	player.queue_free();
