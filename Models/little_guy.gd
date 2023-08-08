extends Node3D

const anims : Array[String] = ["IDLE", "WALK", "CHEER"];


@export var change_anim_time : float = 2.0;
var _timer = 0;
var _index = 0;

func _ready():
	$AnimationPlayer.play(anims[_index]);
	pass

func _process(delta):
	_timer += delta;
	
	if _timer >= change_anim_time or not $AnimationPlayer.is_playing():
		_timer = 0;
		_index = (_index + 1) % anims.size();
		$AnimationPlayer.play(anims[_index], 0.25);
