extends PanelContainer

var notification_item = preload("res://Prefabs/UI/components/notification_item.tscn");
@onready var notification_parent = self.get_node("MarginContainer/VBoxContainer");

func _ready():
    _clear_notifs();
    pass;

func create_notification(icon: Texture2D, content: String, callback: Callable,  duration: float = 0):
    var instance = notification_item.instantiate();
    notification_parent.add_child(instance);
    var tween = get_tree().create_tween();
    instance.populate_item(tween, icon, content, callback, duration);

func _clear_notifs():
    var children = notification_parent.get_children();

    for child in children:
        child.queue_free();