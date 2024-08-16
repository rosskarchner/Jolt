extends Node2D
class_name GamepieceSpawner


var queue:Node2D

var next_piece:Segment = null 
var history =[]


func _ready() -> void:
	prepare()


func prepare():
	history= []
	next_piece = null
	for child in get_children():
		child.queue_free()
	queue = Node2D.new()
	queue.hide()
	add_child(queue)

func add_segments_to_queue(pieces:Array[Node]) -> void:
	pieces.shuffle()
	for piece in pieces:
		piece.position=Vector2.ZERO
		piece.dropped.connect(record_history)
		piece.dropped.connect(reveal_next_piece)
		piece.reparent(queue)
	
func record_history(last_played_segment):
	history.append(last_played_segment)
	
func undo():
	if next_piece:
		next_piece.reparent(queue)
		queue.move_child(next_piece,0)
	var last_piece = history.pop_back()
	last_piece.global_position = global_position
	last_piece.restore_playable()
	next_piece = last_piece
	
func reveal_next_piece(_last_played_segment=null) -> void:
	if queue.get_child_count()<1:
		return
	next_piece = queue.get_child(0)
	if next_piece:
		next_piece.global_position = global_position
		next_piece.reparent(self)
