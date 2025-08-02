extends Node2D

enum Direction { UP, DOWN, LEFT, RIGHT }

@export var direction: Direction = Direction.UP
@export var scroll_speed: float = 6.5

#True if arrow has passed the key_listener
var has_passed = false
var pass_threshold = 520.0
var arrow_direction = "ui_up"

var init_position_x = -620
var dir_map = {
	"ui_left": Direction.LEFT,
	"ui_right": Direction.RIGHT,
	"ui_up": Direction.UP,
	"ui_down": Direction.DOWN,
}

func _init() -> void:
	set_process(false)

func _ready():
	update_direction(direction)
	
func _process(delta: float) -> void:
	global_position += Vector2(scroll_speed, 0)
	
	#How long it takes for arrow to reach key_listener
	if global_position.x > pass_threshold and not $Timer.is_stopped():
		#print($Timer.wait_time - $Timer.time_left)
		$Timer.stop()
		has_passed = true
	
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

func Setup(target_y: float, direction_input):
	global_position = Vector2(init_position_x, target_y)
	arrow_direction = direction_input
	direction = dir_map[direction_input]
	update_direction(direction)
	set_process(true)

func _on_destroy_timer_timeout() -> void:
	queue_free()
