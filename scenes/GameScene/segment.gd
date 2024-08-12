@tool
extends Node2D

var initialized = false
var draggable = false
var is_inside_dropable = false
var offset: Vector2
var initialPos: Vector2
var dragging = false

@export var shape: ConnectorShape:
	set(newshape):
		shape=newshape
		update_shape()

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
		


func update_shape() -> void:
	if shape:
		$Sprite2D.texture = shape.texture
		$ConnectionPoint1.position = shape.connection_point1 + Vector2(-25,-25)
		$ConnectionPoint2.position = shape.connection_point2 + Vector2(-25,-25)
		$ConnectionPoint1.monitoring = true
		$ConnectionPoint2.monitoring = true
	else:
		$Sprite2D.texture = null
		$ConnectionPoint1.position = Vector2.ZERO
		$ConnectionPoint2.position = Vector2.ZERO
		$ConnectionPoint1.monitoring = false
		$ConnectionPoint2.monitoring = false
	initialized = true


func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Engine.is_editor_hint():
		return
	if event.is_action_pressed("click"):
		dragging = true
		offset = get_global_mouse_position() - global_position
		initialPos=global_position
		Dragging.is_dragging = true
	elif event.is_action_released("click"):
		dragging = false
		Dragging.is_dragging = false
