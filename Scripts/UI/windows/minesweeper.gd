extends Panel

const _small_size: Vector2i = Vector2i(248, 276);
const _medium_size: Vector2i = Vector2i(488, 514);

const _small_board: Vector2i = Vector2i(8, 8);
const _medium_board: Vector2i = Vector2i(16, 16);
const _large_board: Vector2i = Vector2i(30, 16);

const _small_bomb_amt: int = 10;
const _medium_bomb_amt: int = 40;
const _large_bomb_amt: int = 99;

@onready var piece = ResourceLoader.load("res://Prefabs/UI/minesweeper/piece.tscn");

@export var _menu: Panel = null;
@export var _board: Panel = null;
var _window_base: Node = null;
var game_board: Array = [];
var game_board_size: Vector2i = Vector2i();
var game_bomb_amt: int = 0;
var game_over = false;
var first_click = true;
var start_msg = "";

func _ready():
	_board.visible = false;

func _on_small_btn_pressed():
	_menu.visible = false;
	_board.visible = true;
	start_msg = "Small Board";
	_board.set_size(_small_size);
	self.set_size(_small_size);
	_window_base.resize_app();
	game_board_size = _small_board;
	game_bomb_amt = _small_bomb_amt;
	var grid = _board.get_child(0);
	grid.columns = _small_board.x;
	create_board(_small_board, _small_bomb_amt);

func _on_medium_btn_pressed():
	_menu.visible = false;
	_board.visible = true;
	start_msg = "Medium Board";
	_board.set_size(_medium_size);
	self.set_size(_medium_size);
	_window_base.resize_app();
	game_board_size = _medium_board;
	game_bomb_amt = _medium_bomb_amt;
	var grid = _board.get_child(0);
	grid.columns = _medium_board.x;
	create_board(_medium_board, _medium_bomb_amt);

func _on_restart_btn_pressed():
	create_board(game_board_size, game_bomb_amt);

func _on_quit_to_menu_btn_pressed():
	_menu.visible = true;
	_board.visible = false;
	self.set_size(_menu.get_global_rect().size);
	_window_base.resize_app();
	pass # Replace with function body.
	

func create_board(_size: Vector2i, _bomb_amount: int):
	var grid = _board.get_child(0);
	game_over = false;
	game_board = [];
	game_board.resize(_size.x * _size.y);
	game_board.fill(0);
	game_board = _place_mines(game_board, _bomb_amount);
	first_click = true;
	get_node("board/status").text = start_msg;

	for child in grid.get_children():
		child.queue_free();

	for x in _size.x:
		for y in _size.y:
			var _piece = piece.instantiate();
			grid.add_child(_piece);
			_piece.piece_pos = Vector2i(x, y);
			_piece.click_callback = _piece_callback;

func _check_win_condition():
	var _unflipped: int = 0;
	var _mines: int = 0;

	var grid = _board.get_child(0);
	for child in grid.get_children():
		if child.flipped == false:
			_unflipped += 1;
			_mines += 1 if _has_mine(child.piece_pos) else 0;
	
	return _unflipped == _mines;


func _place_mines(board: Array, bomb_count: int) -> Array:
	for bomb in bomb_count:
		while true:
			var rand_index = randi_range(0, board.size() - 1);
			if board[rand_index] == 0:
				board[rand_index] = 1;
				break;

	return board;

func _move_mine(pos: Vector2i):
	var linear_pos = (pos.x + game_board_size.y * pos.y);
	while true:
		var rand_index = randi_range(0, game_board.size() - 1);
		if game_board[rand_index] == 0 && rand_index != linear_pos:
			game_board[rand_index] = 1;
			game_board[linear_pos] = 0;
			break;

func _piece_callback(_piece, _pos: Vector2i):
	if game_over:
		return;

	_window_base.play_audio("res://Audio/SFX/UI/click_004.ogg");
	var tile_data = game_board[_pos.x + game_board_size.y * _pos.y];
	var has_mine = bool(tile_data);

	if first_click:
		first_click = false;
		if has_mine:
			#move the mine
			_move_mine(_pos);
			has_mine = false;
			tile_data = game_board[_pos.x + game_board_size.y * _pos.y];

	if has_mine:
		game_over = true;
		get_node("board/status").text = "Game Over";
		_flip_all();
		return;
	print(_pos, " board value: ", tile_data);
	var neighbors = _calc_neighbors(_pos);
	if neighbors == 0:
		_cascade_zero_tiles_from(_pos);

	_piece.flip(bool(tile_data), neighbors);
	if game_over == false:
		if _check_win_condition():
			game_over = true;
			get_node("board/status").text = "You Win!";



func _calc_neighbors(_pos: Vector2i) -> int:
	var result = 0;
	if _is_valid_pos(Vector2i(_pos.x - 1, _pos.y - 1)): result += int(_has_mine(Vector2i(_pos.x - 1, _pos.y - 1)));
	if _is_valid_pos(Vector2i(_pos.x - 0, _pos.y - 1)): result += int(_has_mine(Vector2i(_pos.x - 0, _pos.y - 1)));
	if _is_valid_pos(Vector2i(_pos.x + 1, _pos.y - 1)): result += int(_has_mine(Vector2i(_pos.x + 1, _pos.y - 1)));
	if _is_valid_pos(Vector2i(_pos.x - 1, _pos.y - 0)): result += int(_has_mine(Vector2i(_pos.x - 1, _pos.y - 0)));
	if _is_valid_pos(Vector2i(_pos.x + 1, _pos.y - 0)): result += int(_has_mine(Vector2i(_pos.x + 1, _pos.y - 0)));
	if _is_valid_pos(Vector2i(_pos.x - 1, _pos.y + 1)): result += int(_has_mine(Vector2i(_pos.x - 1, _pos.y + 1)));
	if _is_valid_pos(Vector2i(_pos.x - 0, _pos.y + 1)): result += int(_has_mine(Vector2i(_pos.x - 0, _pos.y + 1)));
	if _is_valid_pos(Vector2i(_pos.x + 1, _pos.y + 1)): result += int(_has_mine(Vector2i(_pos.x + 1, _pos.y + 1)));
	return result;

func _cascade_zero_tiles_from(_pos: Vector2i):
	var zero_stack = [_pos];
	var index = 0;
	var grid = _board.get_child(0);

	while zero_stack.size() > index:
		var top = zero_stack[index];
		var neighbors = _calc_neighbors(top);
		if neighbors == 0:
			if _is_valid_pos(Vector2i(top.x - 1, top.y - 1)) && !zero_stack.has(Vector2i(top.x - 1, top.y - 1)): zero_stack.push_back(Vector2i(top.x - 1, top.y - 1));
			if _is_valid_pos(Vector2i(top.x - 0, top.y - 1)) && !zero_stack.has(Vector2i(top.x - 0, top.y - 1)): zero_stack.push_back(Vector2i(top.x - 0, top.y - 1));
			if _is_valid_pos(Vector2i(top.x + 1, top.y - 1)) && !zero_stack.has(Vector2i(top.x + 1, top.y - 1)): zero_stack.push_back(Vector2i(top.x + 1, top.y - 1));
			if _is_valid_pos(Vector2i(top.x - 1, top.y - 0)) && !zero_stack.has(Vector2i(top.x - 1, top.y - 0)): zero_stack.push_back(Vector2i(top.x - 1, top.y - 0));
			if _is_valid_pos(Vector2i(top.x + 1, top.y - 0)) && !zero_stack.has(Vector2i(top.x + 1, top.y - 0)): zero_stack.push_back(Vector2i(top.x + 1, top.y - 0));
			if _is_valid_pos(Vector2i(top.x - 1, top.y + 1)) && !zero_stack.has(Vector2i(top.x - 1, top.y + 1)): zero_stack.push_back(Vector2i(top.x - 1, top.y + 1));
			if _is_valid_pos(Vector2i(top.x - 0, top.y + 1)) && !zero_stack.has(Vector2i(top.x - 0, top.y + 1)): zero_stack.push_back(Vector2i(top.x - 0, top.y + 1));
			if _is_valid_pos(Vector2i(top.x + 1, top.y + 1)) && !zero_stack.has(Vector2i(top.x + 1, top.y + 1)): zero_stack.push_back(Vector2i(top.x + 1, top.y + 1));
		
		for child in grid.get_children():
			if child.piece_pos == top:
				child.flip(false, neighbors);

		index += 1;

	pass;

func _is_valid_pos(_pos: Vector2i) -> bool:
	return _pos.x >= 0 && _pos.x < game_board_size.x && _pos.y >= 0 && _pos.y < game_board_size.y;

func _has_mine(_pos: Vector2i) -> bool:
	return bool(game_board[_pos.x + game_board_size.y * _pos.y]);

func _flip_all():
	var grid = _board.get_child(0);
	for child in grid.get_children():
		var tile_data = game_board[child.piece_pos.x + game_board_size.y * child.piece_pos.y];
		var neighbors = _calc_neighbors(child.piece_pos);
		child.flip(bool(tile_data), neighbors);
