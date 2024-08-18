extends Node2D

@export var levels:Array[PackedScene]

var current_level = 0
var current_level_instance = null


@onready var piece_spawner = $GamepieceSpawner
@onready var level_container = $LevelContainer
@onready var level_complete_scene = preload("res://scenes/dialog/level_complete_dialog.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NetworkEvents.circuit_complete.connect(level_complete)
	load_current_level()

func level_complete():
	var level_complete_dialog = level_complete_scene.instantiate()
	var remaining_levels =  2 - current_level
	level_complete_dialog.remaining_levels = remaining_levels
	if remaining_levels > 0:
		level_complete_dialog.clicked_next_level.connect(advance_level)
	else:
		level_complete_dialog.clicked_next_level.connect(func():
			get_tree().change_scene_to_file("res://scenes/Credits/Credits.tscn")
			)
	$HUD.add_child(level_complete_dialog)

func advance_level():
	current_level_instance.queue_free()
	current_level +=1
	load_current_level()

func load_current_level():
	current_level_instance = levels[current_level].instantiate()
	piece_spawner.prepare()
	level_container.add_child(current_level_instance)
	piece_spawner.add_segments_to_queue(current_level_instance.get_node("PossibleSolution").get_children())
	piece_spawner.reveal_next_piece()
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip_level"):
		advance_level()
	if event.is_action_pressed("cheat"):
		level_complete()

func _on_undo_button_pressed() -> void:
	piece_spawner.undo()


func _on_gamepiece_spawner_piece_count_changed(history_depth: Variant, remaining_pices: Variant) -> void:
	if history_depth == 0:
		%UndoButton.disabled = true
	else:
		%UndoButton.disabled = false


func _on_start_over_button_pressed() -> void:
	current_level_instance.queue_free()
	load_current_level()
