extends Node2D

const COLS: int = 10
const ROWS: int = 20

const START_POS: Vector2i = Vector2i(5, 1)

var current_pos: Vector2i

var i_shape: Array = [
	[Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)], # 0 degrees
	[Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)], # 90 degrees
	[Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)], # 180 degrees
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)] # 270 degrees
]
var t_shape: Array = [
	[Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)],
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)],
	[Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)],
	[Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
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

var title_id: int = 0
var piece_atlas: Vector2i
var next_piece_atlas: Vector2i

@onready var board_layer: TileMapLayer = $Board
@onready var active_layer: TileMapLayer = $Active

func _ready() -> void:
	start_new_game()

func start_new_game() -> void:
	current_shape_type = choose_shape()
	piece_atlas = Vector2i(all_shapes.find(current_shape_type), 0)
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

func render_shape(shape: Array, position: Vector2i, atlas: Vector2i) -> void:
	for block in shape:
		board_layer.set_cell(position + block, title_id, atlas)
