extends Node2D

signal activated

@export var light: PointLight2D
@export var barrier: StaticBody2D

var enabled = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if light:
		light.enabled = false

func turn_on():
	enabled = false
	light.enabled = true
	barrier.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if enabled:
		activated.emit()
