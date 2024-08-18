extends Node2D



@onready var puzzle_scene = preload("res://scenes/GameScene/game.tscn")
@onready var puzzles = puzzle_scene.instantiate()
@onready var level_complete_scene = preload("res://scenes/dialog/level_complete_dialog.tscn")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	puzzles.hide()
	puzzles.overworld_mode = true
	puzzles.puzzle_completed.connect(puzzle_completed)
	$PuzzleLayer.add_child(puzzles)

func puzzle_completed(level):
	puzzles.hide()
	puzzles.advance_level()
	var cp = get_node("ControlPanel" + str(level+1))
	await get_tree().create_timer(1.0).timeout
	cp.turn_on()
	
func _on_control_panel_activated() -> void:
	puzzles.show()



func _on_finish_game_area_body_entered(_body: Node2D) -> void:
	var level_complete_dialog = level_complete_scene.instantiate()
	level_complete_dialog.clicked_next_level.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/Credits/Credits.tscn")
	)
	$HUD.add_child(level_complete_dialog)
