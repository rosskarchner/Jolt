extends Node2D

@export var levels:Array[PackedScene]

var current_level = 0
var current_level_instance = null

@onready var piece_spawner = $GamepieceSpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_current_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_current_level():
	if not current_level_instance:
		current_level_instance = levels[current_level].instantiate()
		add_child(current_level_instance)
		piece_spawner.add_segments_to_queue(current_level_instance.get_node("PossibleSolution").get_children())
		piece_spawner.reveal_next_piece()
		
