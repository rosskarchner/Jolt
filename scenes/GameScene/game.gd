extends Node2D

@export var levels:Array[PackedScene]

var current_level = 0
var current_level_instance = null

@onready var piece_spawner = $GamepieceSpawner
@onready var level_container = $LevelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NetworkEvents.circuit_complete.connect(advance_level)
	load_current_level()

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
		


func _on_undo_button_pressed() -> void:
	piece_spawner.undo()
