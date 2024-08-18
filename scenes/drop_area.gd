extends Node2D

@onready var starting_color = $Sprite2D.modulate

func _ready() -> void:
	Dragging.stopped_dragging.connect(
		func():
			$Sprite2D.modulate = starting_color
			)
	

func _on_drop_target_area_entered(area: Area2D) -> void:
	if Dragging.is_dragging:
		$Sprite2D.modulate = Color.RED



func _on_drop_target_area_exited(area: Area2D) -> void:
	$Sprite2D.modulate = starting_color
