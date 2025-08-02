extends Area2D

@onready var arrow = preload("res://Assets/Scenes/Rythm/arrow.tscn")
@onready var score_text = preload("res://Assets/Scenes/Rythm/score_press_text.tscn")

var arrow_queue = []
var arrow_map = {
	1: "ui_left",
	2: "ui_right",
	3: "ui_up",
	4: "ui_down",
}
var curr_arrow = 1
var curr_arrow_direction = ""

var perfect_threshold: float = 30
var great_threshold: float = 50
var good_threshold: float = 60
var ok_threshold: float = 80

var perfect_score: float = 150
var great_score: float = 100
var good_score: float = 75
var ok_score: float = 50

func _process(delta: float) -> void:
	if arrow_queue.size() > 0:
		if arrow_queue.front().has_passed:
			arrow_queue.pop_front().queue_free()
			
			var score_text_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", score_text_inst)
			
			score_text_inst.SetTextInfo("MISS")
			
			score_text_inst.global_position = global_position + Vector2(0, 50)
	
		#Iterate over every possible key inputs
		for key in arrow_map.values():
			if Input.is_action_just_pressed(key):
				var current_key = arrow_queue.pop_front()
				
				var distance_from_key_listener = abs(current_key.pass_threshold - current_key.global_position.x)
				
				var score_type: String = ""
				
				if distance_from_key_listener < perfect_score:
					RythmSignals.IncrementScore.emit(perfect_score)
					score_type = "PERFECT"
				elif distance_from_key_listener < great_score:
					RythmSignals.IncrementScore.emit(great_score)
					score_type = "GREAT"
				elif distance_from_key_listener < good_score:
					RythmSignals.IncrementScore.emit(good_score)
					score_type = "GOOD"
				elif distance_from_key_listener < ok_score:
					RythmSignals.IncrementScore.emit(ok_score)
					score_type = "OK"
				else:
					score_type = "MISS"
				
				current_key.queue_free()
				
				var score_text_inst = score_text.instantiate()
				get_tree().get_root().call_deferred("add_child", score_text_inst)
				
				score_text_inst.SetTextInfo(score_type)
				
				score_text_inst.global_position = global_position + Vector2(0, 50)

func CreateArrow(arrow_direction):
	var arrow_inst = arrow.instantiate()
	get_tree().get_root().call_deferred("add_child", arrow_inst)
	arrow_inst.Setup(position.y, arrow_direction)
	
	arrow_queue.push_back(arrow_inst)


func _on_random_spawn_timer_timeout() -> void:
	curr_arrow = randi_range(1, 4)
	curr_arrow_direction = arrow_map[curr_arrow]
	CreateArrow(curr_arrow_direction)
	$RandomSpawnTimer.wait_time = randi_range(0.01, 1)
	$RandomSpawnTimer.start()
