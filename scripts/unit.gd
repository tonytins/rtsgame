extends KinematicBody2D

export var selected = false
onready var box = $box

func _ready():
	pass # Replace with function body.


func _process(delta):
	if selected:
		if box.visible == false:
			box.visible = true
	else:
		if box.visible == true:
			box.visible = false
	pass


func _on_unit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				selected = true
			if event.button_index == BUTTON_RIGHT:
				selected = false
	pass
