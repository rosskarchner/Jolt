extends Area2D
class_name ConnectionPoint

signal connection_updated

enum Disposition { PROVIDES_POSITIVE, PROVIDES_NEGATIVE,PAIRED}

@export var disposition: Disposition = Disposition.PAIRED
@export var partner:ConnectionPoint = null

var connected = false
var connected_to:ConnectionPoint= null:
	set(new_connection):
		connected_to = new_connection
		connection_updated.emit()
		NetworkEvents.network_changed.emit()
		print(new_connection)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass


func query_connections() -> void:
	if monitoring && has_overlapping_areas():
		connected = true
		var overlapping_areas:Array = get_overlapping_areas()
		if overlapping_areas[0] != connected_to:
			
			connected_to = overlapping_areas[0]
	else:
		connected = false
		connected_to = null
		
func provides_positive_charge()->bool:
	if disposition == Disposition.PROVIDES_POSITIVE:
		return true
	if disposition == Disposition.PAIRED:
		var partner_connected = partner.connected
		if partner.connected:
			return partner.connected_to.provides_positive_charge()
		else:
			return false
	return false
func provides_negative_charge() -> bool:
	if disposition == Disposition.PROVIDES_NEGATIVE:
		return true
	elif disposition == Disposition.PAIRED and partner.connected:
		return partner.connected_to.provides_negative_charge()
	else:
		return false


func _on_area_entered(area: Area2D) -> void:
	query_connections()


func _on_area_exited(area: Area2D) -> void:
	query_connections()
