@tool
extends Node2D
class_name Segment

signal dropped

var draggable = true
var is_inside_dropable = false
var offset: Vector2
var dragStartPosition: Vector2
var dragging = false
var drop_target:Area2D

var connection_point_scene=preload("res://scenes/GameScene/connection_point.tscn")

@export var connection_pairs:Array[Vector2i]:
	set(newpairs):
		connection_pairs = newpairs
		configure_control_points()
		queue_redraw()

const positions = [
	Vector2i(21,12),
	Vector2i(70,12),
	Vector2i(92,46 ),
	Vector2i(70,80),
	Vector2i(21,79),
	Vector2i(0,46 ),
]

func configure_control_points():
	
	for node in get_children():
		if node is ConnectionPoint:
			node.queue_free()
	
	if Engine.is_editor_hint():
		return
	for pair in connection_pairs:
		var position1 = positions[pair[0]]
		var position2 = positions[pair[1]]
		create_connection_pair(position1,position2)
	
		

func create_connection_pair(position1, position2):
		var connector1:ConnectionPoint = connection_point_scene.instantiate()
		var connector2:ConnectionPoint = connection_point_scene.instantiate()
		connector1.disposition = ConnectionPoint.Disposition.PAIRED
		connector2.disposition = ConnectionPoint.Disposition.PAIRED
		connector1.partner = connector2
		connector2.partner = connector1
		connector1.position = position1 - Vector2i(46,46)
		connector2.position = position2 - Vector2i(46,46)
		connector1.monitoring = true
		connector2.monitoring = true
		add_child(connector1)
		add_child(connector2)
		
func _draw() -> void:
	for pair in connection_pairs:
		var position1 = positions[pair[0]]
		var position2 = positions[pair[1]]
		draw_line(position1 - Vector2i(46,46),Vector2.ZERO,Color.BLACK,2.0)
		draw_line(position2 - Vector2i(46,46),Vector2.ZERO,Color.BLACK,2.0)
		print("drawing!")
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if dragging:
			global_position = get_global_mouse_position()

func _on_click_area_mouse_entered():
	if not Engine.is_editor_hint():
		if not Dragging.is_dragging:
			draggable = true
		#scale *= 1.1

func _on_click_area_mouse_exited() -> void:
	if not Engine.is_editor_hint():
		if not Dragging.is_dragging:
			draggable = false
			#scale = Vector2(1.0,1.0)
		

func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Engine.is_editor_hint():
		return
	if event.is_action_pressed("click") and draggable:
		dragging = true
		offset = get_global_mouse_position() - global_position
		dragStartPosition =global_position
		Dragging.is_dragging = true
	elif event.is_action_released("click") and draggable:
		dragging = false
		Dragging.is_dragging = false
		if drop_target:
			drop_target.monitorable = false
			global_position = drop_target.global_position
			dropped.emit()
			$ClickArea.queue_free()
			drop_target = null
		else:
			global_position = dragStartPosition


func _on_drop_target_detector_area_entered(area: Area2D) -> void:
	print("entered target")
	drop_target = area


func _on_drop_target_detector_area_exited(area: Area2D) -> void:
	print("exit target")
	drop_target = null
