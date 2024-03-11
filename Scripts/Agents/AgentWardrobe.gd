class_name AgentWardrobe;

static func dress_up(adv: Adventurer, model: Node):
	var class_appearance = ClassDataContainer.get_class_from_id(adv._class)['appearance'];
	hide_all_children(model.find_child("Skeleton3D"));
	enable_body(model);
	color_clothes(model, Color.from_string(class_appearance['shirtCol'], Color.MAGENTA), Color.from_string(class_appearance['armCol'], Color.MAGENTA));
	
	var race = find_child_node(model, adv.LOOK_race);
	if race != null:
		race.show();

	var hat = find_child_node(model, adv.LOOK_hat);
	if hat != null:
		hat.show();

	var weapon = find_child_node(model, adv.LOOK_weapon);
	if weapon != null:
		weapon.show();
	
	var hair = find_child_node(model, adv.LOOK_hair);
	if hair != null:
		hair.show();
	
	pass;

static func hide_all_children(parent: Node):
	for child in parent.get_children():
		child.hide();

static func color_clothes(parent: Node, shirt_col: Color, arm_col: Color):
	var shoulders = find_child_node(parent, "SHOULDERS") as MeshInstance3D;
	var torso = find_child_node(parent, "BODY") as MeshInstance3D;
	
	var shoulder_mat = (shoulders.get_active_material(0) as Material).duplicate(true);
	shoulder_mat.albedo_color = arm_col;
	shoulders.material_override = shoulder_mat;

	var torso_mat = (torso.get_active_material(0) as Material).duplicate(true);
	torso_mat.albedo_color = shirt_col;
	torso.material_override = torso_mat;


static func enable_body(parent: Node):
	find_child_node(parent, "BODY").show();
	#find_child_node(parent, "EYES").show();
	find_child_node(parent, "FEET").show();
	find_child_node(parent, "HEAD").show();
	find_child_node(parent, "L_HAND").show();
	find_child_node(parent, "R_HAND").show();
	find_child_node(parent, "SHOULDERS").show();

static func find_child_node(model: Node, node_ref: String):
	if node_ref == "":
		return null;
	return model.find_child(node_ref);
