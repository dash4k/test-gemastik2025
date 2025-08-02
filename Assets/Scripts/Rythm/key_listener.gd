extends Sprite2D

@onready var arrow = preload("res://Assets/Scenes/Rythm/arrow.tscn")
@onready var score_text = preload("res://Assets/Scenes/Rythm/score_press_text.tscn")
@onready var glow_anim: AnimationPlayer = $AnimationPlayer

var arrow_queue = []
var arrow_map = {
	0: "ui_left",
	1: "ui_right",
	2: "ui_up",
	3: "ui_down",
}
var curr_arrow = 1
var curr_arrow_direction = ""

var perfect_threshold: float = 15
var great_threshold: float = 30
var good_threshold: float = 45
var ok_threshold: float = 60

var perfect_score: int = 150
var great_score: int = 100
var good_score: int = 75
var ok_score: int = 50

func _ready() -> void:
	RythmSignals.CreateArrow.connect(CreateArrow)

func _process(delta: float) -> void:
	if arrow_queue.is_empty():
		return

	var front_arrow = arrow_queue.front()

	# On miss
	if front_arrow.has_passed:
		if front_arrow.has_missed:
			arrow_queue.pop_front().queue_free()
			_spawn_score_text("MISS", front_arrow.global_position)
			return
		else:
			# Check if any directional input was pressed
			for dir in arrow_map.values():
				if Input.is_action_just_pressed(dir):
					# Check if it matches the expected arrow
					if front_arrow.arrow_direction != dir:
						if glow_anim:
							glow_anim.play("glow_red")
						_spawn_score_text("MISS", front_arrow.global_position)
						arrow_queue.pop_front().queue_free()
					else:
						# Right key pressed, calculate score based on distance
						var distance = abs(front_arrow.pass_threshold - front_arrow.global_position.x)
						var score_type = "MISS"
						var score_value = 0

						if distance <= perfect_threshold:
							score_type = "PERFECT"
							score_value = perfect_score
						elif distance <= great_threshold:
							score_type = "GREAT"
							score_value = great_score
						elif distance <= good_threshold:
							score_type = "GOOD"
							score_value = good_score
						elif distance <= ok_threshold:
							score_type = "OK"
							score_value = ok_score
							
						if score_type == "MISS":
							if glow_anim:
								glow_anim.play("glow_red")
						else:
							if glow_anim:
								glow_anim.play("glow_blue")

						RythmSignals.IncrementScore.emit(score_value)
						_spawn_score_text(score_type, front_arrow.global_position)
						arrow_queue.pop_front().queue_free()

					break  # Don't check other inputs in the same frame
			


func _spawn_score_text(text: String, position: Vector2):
	var score_text_inst = score_text.instantiate()
	score_text_inst.SetTextInfo(text)
	score_text_inst.global_position = position
	get_tree().get_root().call_deferred("add_child", score_text_inst)

func CreateArrow(arrow_direction: String):
	var arrow_inst = arrow.instantiate()
	get_tree().get_root().call_deferred("add_child", arrow_inst)
	arrow_inst.Setup(position.y, arrow_direction)
	arrow_queue.push_back(arrow_inst)

func get_array_index_for_dir(dir: String) -> int:
	for i in arrow_map:
		if arrow_map[i] == dir:
			return i
	return -1  # fallback in case of error

func _input(event: InputEvent) -> void:
	for dir in arrow_map.values():
		if Input.is_action_just_pressed(dir):
			var array_num = get_array_index_for_dir(dir)
			RythmSignals.KeyListenerPress.emit(dir, array_num)

func _on_random_spawn_timer_timeout() -> void:
	curr_arrow = randi_range(0, 3)
	curr_arrow_direction = arrow_map[curr_arrow]
	#CreateArrow(curr_arrow_direction)
	$RandomSpawnTimer.wait_time = randf_range(0.1, 1)
	$RandomSpawnTimer.start()
