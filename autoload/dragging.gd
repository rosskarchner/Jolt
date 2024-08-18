extends Node2D

signal started_dragging
signal stopped_dragging

var is_dragging=false:
	set(state):
		is_dragging = state
		if state:
			started_dragging.emit()
		else:
			stopped_dragging.emit()
