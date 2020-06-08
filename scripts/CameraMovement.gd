extends Camera2D

export var speed = 25.0
export var zoomspeed = 50.0
export var zoommargin = 0.3
export var panSpeed = 30.0

export var zoomMin = 0.5
export var zoomMax = 3.0
export var marginX = 100.0
export var marginY = 100.0

var mousepos = Vector2()
var mouseposGlobal = Vector2()
var start = Vector2()
var startv = Vector2()
var end = Vector2()
var endv = Vector2()
var zoompos = Vector2()
var zoomfactor = 1.0
var zooming = false
var is_dragging = false

onready var rectd = $'../ui/draw_rect'

signal area_selected


func _ready():
	connect("area_selected", get_parent(), "area_selected", [self]) 


func _process(delta):
	# Smooth Movement
	var inputx = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
	var inputy = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
	position.x = lerp(position.x, position.x + inputx * speed * zoom.x, speed * delta)
	position.y = lerp(position.y, position.y + inputy * speed * zoom.y, speed * delta)
	
	# Margin Movement
	
	if Input.is_key_pressed(KEY_CONTROL):
		if mousepos.x < marginX:
			position.x = lerp(position.x, position.x - abs(mousepos.x - marginX)/marginX * panSpeed * zoom.x, speed * delta)
		elif mousepos.x > OS.window_size.x - marginX:
			position.x = lerp(position.x, position.x + abs(mousepos.x - OS.window_size.x + marginX)/marginX * panSpeed * zoom.x, speed * delta)
		if mousepos.y < marginY:
			position.y = lerp(position.y, position.y - abs(mousepos.y - marginY)/marginY * panSpeed * zoom.y, speed * delta)
		elif mousepos.y > OS.window_size.y - marginY:
			position.y = lerp(position.y, position.y + abs(mousepos.y - OS.window_size.y + marginY)/marginY * panSpeed * zoom.y, speed * delta)
	
	if Input.is_action_just_pressed("ui_left_mouse_button"):
		start = mouseposGlobal
		startv = mousepos
		is_dragging = true
	if is_dragging:
		end = mouseposGlobal
		endv = mousepos
		draw_area()
	if Input.is_action_just_released("ui_left_mouse_button"):
		if startv.distance_to(mousepos) > 20:
			end = mouseposGlobal
			endv = mousepos
			is_dragging = false
			draw_area(false)
			emit_signal("area_selected")
		else:
			end = start
			is_dragging = false
			draw_area(false)
	
	# Zooming
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomspeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomspeed * delta)
	
	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)
	
	if not zooming:
		zoomfactor = 1.0

func draw_area(s = true):
	rectd.rect_size = Vector2(abs(startv.x-endv.x), abs(startv.y - end.y))
	
	var pos = Vector2()
	pos.x = min(startv.x, endv.x)
	pos.y = min(startv.y, endv.x)
	pos.y -= OS.window_size.y
	rectd.rect_position = pos
	
	rectd.rect_size *= int(s)

func _input(event):
	if abs(zoompos.x - get_global_mouse_position().x) > zoommargin:
		zoomfactor = 1.0
	if abs(zoompos.y - get_global_mouse_position().y) > zoommargin:
		zoomfactor = 1.0
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.button_index == BUTTON_WHEEL_UP:
				zoomfactor -= 0.01 * zoomspeed
				zoompos = get_global_mouse_position()
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoomfactor += 0.01 * zoomspeed
				zoompos = get_global_mouse_position()
		else:
			zooming = false
	
	if event is InputEventMouse:
		mousepos = event.position
