extends Control
signal clicked_next_level

var remaining_levels = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if remaining_levels == 0:
		%Message.text = "You've completed all of the levels"
		%Title.text = "[rainbow freq=1.0 sat=0.8 val=0.8][wave amp=50.0 freq=5.0 connected=1][center]Whoa![/center][/wave]"
		%Button.text = "Who made this crazy thing?"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	clicked_next_level.emit()
	queue_free()
