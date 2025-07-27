extends Node2D

enum Direction { UP, DOWN, LEFT, RIGHT }

@export var direction: Direction = Direction.UP

func _ready():
	update_direction(direction)
	
func update_direction(direction: Direction):
	match  direction:
		Direction.UP:
			rotation_degrees = 180
		Direction.RIGHT:
			rotation_degrees = 270
		Direction.DOWN:
			rotation_degrees = 0
		Direction.LEFT:
			rotation_degrees = 90
