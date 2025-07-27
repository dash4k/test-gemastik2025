extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		$ArrowDown.update_direction($ArrowDown.Direction.LEFT)
	if event.is_action_pressed("ui_right"):
		$ArrowDown.update_direction($ArrowDown.Direction.RIGHT)
	if event.is_action_pressed("ui_up"):
		$ArrowDown.update_direction($ArrowDown.Direction.UP)
	if event.is_action_pressed("ui_down"):
		$ArrowDown.update_direction($ArrowDown.Direction.DOWN)
