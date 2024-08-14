extends Node2D
class_name GamepieceSpawner


@onready var queue = Node2D.new()


func _ready() -> void:
	queue.hide()
	add_child(queue)


func add_segments_to_queue(pieces:Array[Node]) -> void:
	pieces.shuffle()
	for piece in pieces:
		piece.position=Vector2.ZERO
		piece.dropped.connect(reveal_next_piece)
		piece.reparent(queue)
	
func reveal_next_piece() -> void:
	var next_piece = queue.get_child(0)
	if next_piece:
		next_piece.reparent(self)
