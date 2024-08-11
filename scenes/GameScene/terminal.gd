@tool
extends Node2D

enum CurrentDirection { POSITIVE, NEGATIVE}

@export var direction: CurrentDirection:
	set(newdir):
		direction = newdir
		update_direction()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_direction()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_direction() -> void:
	if direction == CurrentDirection.POSITIVE:
		$Label.text = "+"
		$ConnectionPoint.disposition = ConnectionPoint.Disposition.PROVIDES_POSITIVE
		$ConnectionPoint.monitoring = true
	else:
		$Label.text = "-"
		$ConnectionPoint.disposition = ConnectionPoint.Disposition.PROVIDES_NEGATIVE
