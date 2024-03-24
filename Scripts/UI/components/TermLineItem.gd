extends HBoxContainer

var active = false;

func _process(_delta):
	if active:
		var time = Time.get_ticks_msec() / 1000.0;
		get_child(1).visible = fmod(roundf(time), 2) as bool;
	elif !active && get_child(1).visible:
		get_child(1).visible = false;
