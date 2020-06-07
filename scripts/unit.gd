extends KinematicBody2D

export var selected = false setget set_selected
onready var box = $box
onready var bar = $bar
onready var unitname = $unitname

signal was_selected
signal was_deselected

func set_selected(value):
	if selected != value:
		selected = value
		box.visible = value
		unitname.visible = value
		bar.visible = value
		if selected:
			emit_signal("was_selected", self)
		else:
			emit_signal("was_deselected", self)

func _ready():
	randomize()
	unitname.text = name
	bar.value = randi() % 90 + 10
	connect("was_selected", get_parent(), "select_unit")
	connect("was_deselected", get_parent(), "deselect_unit")
	pass


func _process(delta):
	pass


func _on_unit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				set_selected(true)
			if event.button_index == BUTTON_RIGHT:
				set_selected(false)
