@tool
extends Node2D

var initialized = false

@export var shape: ConnectorShape:
	set(newshape):
		shape=newshape
		update_shape()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

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
