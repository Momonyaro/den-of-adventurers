extends Control

@export var _neighbors: Array[NodePath] = [];

func _ready():
    self.tooltip_text = self.name;