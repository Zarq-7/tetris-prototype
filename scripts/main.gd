extends Node2D

const COLS: int = 10
const ROWS: int = 20

const MOVEMENT_DIRECTIONS: Array[Vector2i] = [Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT]

const START_POS: Vector2i = Vector2i(5, 1)

var current_pos: Vector2i

var i_shape: Array = [
	[Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)], # 0 degrees
	[Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)], # 90 degrees
	[Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)], # 180 degrees
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)] # 270 degrees
]
var t_shape: Array = [
	[Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(1,1)],
	[Vector2i(0,1), Vector2i(1,0), Vector2i(1,1), Vector2i(1,2)],
	[Vector2i(0,1), Vector2i(1,0), Vector2i(1,1), Vector2i(2,1)],
	[Vector2i(1,0), Vector2i(1,1), Vector2i(1,2), Vector2i(2,1)]
]
var o_shape: Array = [
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)],
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)],
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)],
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
]
var z_shape: Array = [
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)],
	[Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)],
	[Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)],
	[Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)]
]
var s_shape: Array = [
	[Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1)],
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)],
	[Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2), Vector2i(1, 2)],
	[Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
]
var l_shape: Array = [
	[Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)],
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)],
	[Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2)],
	[Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]
]
var j_shape: Array = [
	[Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)],
	[Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)],
	[Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)],
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)]
]

var shapes: Array = [i_shape, t_shape, o_shape, z_shape, s_shape, l_shape, j_shape]
var all_shapes: Array = shapes.duplicate()

var current_shape_type: Array
var next_shape_type: Array
var rotation_index: int = 0
var active_shape: Array = []

var fall_timer: float = 0
var fall_interval: float = 1.0
var fast_fall: float = 10.0

var tile_id: int = 0
var piece_atlas: Vector2i
var next_piece_atlas: Vector2i

@onready var board_layer: TileMapLayer = $Board
@onready var active_layer: TileMapLayer = $Active

func _ready() -> void:
	start_new_game()

func _physics_process(delta: float) -> void:
	var movement_dir: Vector2i = Vector2i.ZERO
	var current_fall_interval: float = fall_interval
	if Input.is_action_just_pressed("ui_left"):
		movement_dir = Vector2i.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		movement_dir = Vector2i.RIGHT
	
	if movement_dir != Vector2i.ZERO:
		move_shape(movement_dir)
	
	if Input.is_action_just_pressed("ui_up"):
		rotate_shape()
	
	if Input.is_action_pressed("ui_down"):
		current_fall_interval /= fast_fall
	fall_timer  += delta
	if fall_timer >= current_fall_interval:
		move_shape(Vector2i.DOWN)
		fall_timer = 0


func start_new_game() -> void:
	current_shape_type = choose_shape()
	piece_atlas = Vector2i(all_shapes.find(current_shape_type), 0)
	next_shape_type = choose_shape()
	next_piece_atlas = Vector2i(all_shapes.find(next_shape_type), 0)
	initialize_shape()

func choose_shape() -> Array:
	var selected_shape: Array
	if not shapes.is_empty():
		shapes.shuffle()
		selected_shape = shapes.pop_front()
	else:
		shapes = all_shapes.duplicate()
		shapes.shuffle()
		selected_shape = shapes.pop_front()
	return selected_shape

func initialize_shape() -> void:
	current_pos = START_POS
	active_shape = current_shape_type[rotation_index]
	render_shape(active_shape, current_pos, piece_atlas)
	render_shape(next_shape_type[0], Vector2i(15, 2), next_piece_atlas)

func render_shape(shape: Array, pos: Vector2i, atlas: Vector2i) -> void:
	for block in shape:
		active_layer.set_cell(pos + block, tile_id, atlas)

func clear_shape() -> void:
	for block in active_shape:
		active_layer.erase_cell(current_pos + block)

func clear_next_shape_preview() -> void:
	for i in range(14, 19):
		for j in range(2, 6):
			active_layer.erase_cell(Vector2i(i, j))

func rotate_shape() -> void:
	if is_valid_rotation():
		clear_shape()
		rotation_index = (rotation_index - 1) % 4
		active_shape = current_shape_type[rotation_index]
		render_shape(active_shape, current_pos, piece_atlas)
		pass

func move_shape(direction: Vector2i) -> void:
	if is_valid_move(direction):
		clear_shape()
		current_pos += direction
		render_shape(active_shape, current_pos, piece_atlas)
	else:
		if direction == Vector2i.DOWN:
			land_shape()
			current_shape_type = next_shape_type
			piece_atlas = next_piece_atlas
			next_shape_type = choose_shape()
			next_piece_atlas = Vector2i(all_shapes.find(next_shape_type), 0)
			clear_next_shape_preview()
			initialize_shape()

func land_shape() -> void:
	for i in active_shape:
		active_layer.erase_cell(current_pos + i)
		board_layer.set_cell(current_pos + i, tile_id, piece_atlas)
		

func is_valid_move(new_pos: Vector2i) -> bool:
	for block in active_shape:
		if not is_within_bounds(current_pos + block + new_pos):
			return false
	return true

func is_valid_rotation() -> bool:
	var next_rotation = (rotation_index + 1) % 4
	var rotated_shape = current_shape_type[next_rotation]
	
	for block in rotated_shape:
		if not is_within_bounds(current_pos + block):
			return false
	return true

func is_within_bounds(pos: Vector2i) -> bool:
	if pos.x < 0 or pos.x >= COLS + 1 or pos.y < 0 or pos.y >= ROWS + 1:
		return false
	
	return board_layer.get_cell_source_id(pos) == -1
