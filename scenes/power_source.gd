extends Node2D


const positions = [
	Vector2i(21,12),
	Vector2i(70,12),
	Vector2i(92,46 ),
	Vector2i(70,80),
	Vector2i(21,79),
	Vector2i(0,46 ),
]

@export var positive_location = 0
@export var negative_location =3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
