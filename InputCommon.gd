extends Node2D

signal touch_on_screen(position: Vector2)

var input_direction: Vector2 = Vector2.ZERO

var touch_poits: Dictionary = {}


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		handle_drag(event)
	elif event is InputEventScreenTouch:
		handle_touch(event)
	
	if touch_poits.size() == 0:
		input_direction = Input.get_vector("left", "right", "up", "down")
	# if Input.is_action_pressed("action"):
	# 	touch_on_screen.emit(Vector2.ZERO)

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_poits[event.index] = event.position
		touch_on_screen.emit(event.position)
	else:
		input_direction = Vector2.ZERO
		touch_poits.erase(event.index)

func handle_drag(event: InputEventScreenDrag):
	input_direction = event.relative
