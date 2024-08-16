extends Node

signal network_changed
signal circuit_complete

func _ready() -> void:
	network_changed.emit()
