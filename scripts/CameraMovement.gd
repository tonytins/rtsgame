extends Camera2D

export var speed = 10.0


func _ready():
	pass 


func _process(delta):
	# Smooth Movement
	var inputx = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
	var inputy = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	position.x += inputx * speed
	position.y += inputy * speed
	print(inputx)
	pass
