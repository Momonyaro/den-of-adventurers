extends BaseState;
class_name TestDeleteDismissedState;


var _agent = null;
var _party: Party = null;
var _activity = null;

func _init():
	_state_ref = StateReference.DELETE_DISMISSED;

func start(animator: AnimationPlayer):
	_animator = animator;
	_state_enter_count += 1;
	pass;
	
func update(delta: float, agent: Node, camera: Node):
	var game_manager : GameManager = agent.get_node("/root/Root/Game");
	
	if game_manager._selected_agent != "" && game_manager._selected_agent == agent.adv_id:
		game_manager.select_agent.emit("");
	agent.adv_manager._remove_adventurer(agent.adventurer._unique_id);
	agent.adventurer = null;
	return true;

func evaluate(agent: Agent, adv_state: Adventurer.Status, has_destination: bool, party: Party) -> bool:
	if adv_state == Adventurer.Status.DISMISSED:
		return true;
		
	return false;

func end() -> StateReference:
	_state_exit_count += 1;
	return StateReference.NIL;

func state_transition_allowed(state_ref: StateReference) -> bool:
	return false;
