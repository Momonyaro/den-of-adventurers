extends PanelContainer

func populate(icon: Texture2D, key: String, text: String):
    var _icon = get_node("HBoxContainer/TextureRect") as TextureRect;
    var _text = get_node("HBoxContainer/Label") as Label;

    _icon.texture = icon;
    _text.text = text;
    self.tooltip_text = key;
    pass;