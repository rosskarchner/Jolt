@tool
extends Node2D
class_name Light

var triggered = false

@onready var connection_point1 = $ConnectionPoint1
@onready var connection_point2 = $ConnectionPoint2

var is_on = false:
	set(status):
		is_on = status
		if status and not triggered:
			NetworkEvents.circuit_complete.emit()
			triggered = true
		update_display()


func update_status()-> void:
	if Dragging.is_dragging:
		return
	var cp1_positive = connection_point1.connected && is_instance_valid(connection_point1.connected_to) && connection_point1.connected_to.provides_positive_charge()
	var cp1_negative = connection_point1.connected && is_instance_valid(connection_point1.connected_to) && connection_point1.connected_to.provides_negative_charge()
	var cp2_positive = connection_point2.connected && is_instance_valid(connection_point2.connected_to) &&  connection_point2.connected_to.provides_positive_charge()
	var cp2_negative = connection_point2.connected && is_instance_valid(connection_point2.connected_to) &&  connection_point2.connected_to.provides_negative_charge()
	is_on = (cp1_negative && cp2_positive) || (cp1_positive && cp2_negative)
	
func update_display() -> void:
	if Engine.is_editor_hint():
		return
	if is_on:
		$OnSprite.show()
		$PointLight2D.show()
		$OffSprite.hide()
		
	else:
		$OnSprite.hide()
		$OffSprite.show()
		$PointLight2D.hide()
		
