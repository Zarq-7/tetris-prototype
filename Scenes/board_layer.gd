extends TileMapLayer

var j_0 	:= [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var j_90	:= [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 2), Vector2i(2, 2)]
var j_180	:= [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2)]
var j_270	:= [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]
var j		:= [j_0, j_90, j_180, j_270]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
