extends PanelContainer

@onready var icon_item: TextureRect = self.get_node("VBoxContainer/HBoxContainer/IconMargins/TextureRect");
@onready var label_item: Label = self.get_node("VBoxContainer/HBoxContainer/LabelMargins2/Label");
@onready var timer_bar: ProgressBar = self.get_node("VBoxContainer/TIMER_BAR");

func populate_item(tween: Tween, icon: Texture2D, content: String, callback: Callable, duration: float = 0):
	var has_icon = icon != null;
	icon_item.get_parent().visible = has_icon;

	if has_icon:
		icon_item.texture = icon;
	
	var has_duration = duration > 0;
	timer_bar.visible = has_duration;

	tween.tween_method(_set_bar_value, 1 as float, 0 as float, duration);
	tween.connect("finished", func(): if duration > 0: _on_close_pressed());

	label_item.text = content;

func _set_bar_value(value: float):
	timer_bar.set_value_no_signal(value);

func _on_close_pressed():
	self.queue_free();