@tool
extends Node2D
class_name Segment

signal dropped(segment:Segment)

var draggable = true
var is_inside_dropable = false
var offset: Vector2
var dragStartPosition: Vector2
var dragging = false
var drop_target:Area2D
var played = false

var wire_colors = [Color.BLACK, Color.CORAL, Color.DARK_GREEN]

var connection_point_scene=preload("res://scenes/GameScene/connection_point.tscn")
var connection_points = []

@export var connection_pairs:Array[Vector2i]:
	set(newpairs):
		connection_pairs = newpairs
		queue_redraw()

const positions = [
	Vector2i(21,12),
	Vector2i(70,12),
	Vector2i(92,46 ),
	Vector2i(70,80),
	Vector2i(21,79),
	Vector2i(0,46 ),
]


func clear_control_points():
	for node in get_children():
		if node is ConnectionPoint:
			node.queue_free()

func configure_control_points():
	
	clear_control_points()
	
	if Engine.is_editor_hint():
		return
	for pair in connection_pairs:
		var position1 = positions[pair[0]]
		var position2 = positions[pair[1]]
		create_connection_pair(position1,position2)
	
		



func create_connection_pair(position1, position2):
		var connector1:ConnectionPoint = connection_point_scene.instantiate()
		var connector2:ConnectionPoint = connection_point_scene.instantiate()
		connection_points.append(connector1)
		connection_points.append(connector2)
		connector1.disposition = ConnectionPoint.Disposition.PAIRED
		connector2.disposition = ConnectionPoint.Disposition.PAIRED
		connector1.partner = connector2
		connector2.partner = connector1
		connector1.position = position1 - Vector2i(46,46)
		connector2.position = position2 - Vector2i(46,46)
		add_child(connector1)
		add_child(connector2)
		
func _draw() -> void:
	var i = 0
	for pair in connection_pairs:
		var position1 = positions[pair[0]]
		var position2 = positions[pair[1]]
		draw_line(position1 - Vector2i(46,46),Vector2.ZERO,wire_colors[i],3.0)
		draw_line(position2 - Vector2i(46,46),Vector2.ZERO,wire_colors[i],3.0)
		i+=1
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
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
		

func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if Engine.is_editor_hint():
		return
	if event.is_action_pressed("click") and draggable:
		dragging = true
		offset = get_global_mouse_position() - global_position
		dragStartPosition =global_position
		Dragging.is_dragging = true
		clear_control_points()
		if drop_target:
			drop_target.monitorable = true
	elif event.is_action_released("click") and draggable:
		dragging = false
		Dragging.is_dragging = false
		if drop_target:
			
			global_position = drop_target.global_position
			if not played:
				dropped.emit(self)
				played = true
			configure_control_points()
			NetworkEvents.network_changed.emit()
			drop_target.monitorable = false
			#$ClickArea.hide()
		else:
			global_position = dragStartPosition


func restore_playable():
	drop_target.monitorable = true
	$ClickArea.show()

func _on_drop_target_detector_area_entered(area: Area2D) -> void:
	drop_target = area


func _on_drop_target_detector_area_exited(_area: Area2D) -> void:
	drop_target = null
