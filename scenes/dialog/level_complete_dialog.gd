extends Control
signal clicked_next_level

var remaining_levels = 0


func _on_button_pressed() -> void:
	clicked_next_level.emit()
	queue_free()
