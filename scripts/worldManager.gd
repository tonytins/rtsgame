extends Node2D

var selected_units = []

onready var button = preload("res://scenes/Button.tscn")
var buttons = []

func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
	print("selected %s" % unit.name)
	create_buttons()
func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
	print("deselected %s" % unit.name)
	create_buttons()

func create_buttons():
	delete_buttons()
	for unit in selected_units:
		if not buttons.has(unit.name):
			var but = button.instance()
			but.connect_me(self, unit.name)
			but.rect_position()

func delete_buttons():
	for but in buttons:
		if "UI/Base".has_node(but):
			var b = $"UI/Base".get_node(but)
			b.queue_free()
			$"UI/Base".remove_child(b)
	buttons.clear()
