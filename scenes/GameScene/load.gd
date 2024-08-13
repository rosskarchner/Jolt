@tool
extends Node2D


@onready var connection_point1 = $ConnectionPoint1
@onready var connection_point2 = $ConnectionPoint2

var is_on = false:
	set(status):
		is_on = status
		update_display()

func _ready() -> void:
	if not Engine.is_editor_hint():
		NetworkEvents.network_changed.connect(update_status)


func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		#update_status()
		pass

func update_status()-> void:
	var cp1_positive = connection_point1.connected && connection_point1.connected_to.provides_positive_charge()
	var cp1_negative = connection_point1.connected && connection_point1.connected_to.provides_negative_charge()
	var cp2_positive = connection_point2.connected && connection_point2.connected_to.provides_positive_charge()
	var cp2_negative = connection_point2.connected && connection_point2.connected_to.provides_negative_charge()
	is_on = (cp1_negative && cp2_positive) || (cp1_positive && cp2_negative)
	
func update_display() -> void:
	if is_on:
		$OnSprite.show()
		$OffSprite.hide()
	else:
		$OnSprite.hide()
		$OffSprite.show()
