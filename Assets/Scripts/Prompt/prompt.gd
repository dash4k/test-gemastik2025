extends Node2D

signal prompt_completed(result: bool)

const keys = [
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
	"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
	"U", "V", "W", "X", "Y", "Z",
	"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
]

var current_prompt: Array = []
var current_index := 0
var attempt = 0
var status := true
@export var key_scene: PackedScene
@onready var key_container = $HBoxContainer

func _ready():
	current_prompt = generate_prompt(8)
	current_index = 0
	status = true
	display_prompt()

func generate_prompt(count: int) -> Array:
	var prompt = []
	for i in count:
		prompt.append(keys[randi() % keys.size()])
	return prompt

func display_prompt():
	for child in key_container.get_children():
		child.queue_free()
	for char in current_prompt:
		var k = key_scene.instantiate()
		k.update_label(char)
		key_container.add_child(k)

func _input(event):
	if event is InputEventKey and event.pressed:
		var pressed_key = OS.get_keycode_string(event.keycode).to_upper()

		if current_index >= current_prompt.size():
			return

		var expected = current_prompt[current_index]

		if pressed_key == expected:
			mark_key_correct(current_index)
		else:
			mark_key_incorrect(current_index)
			status = false

		current_index += 1  # <-- Now moved after both branches

		if current_index == current_prompt.size():
			if status:
				emit_signal("prompt_completed", true)
			else:
				#if attempt < 3:
					#attempt += 1
					#await get_tree().create_timer(0.5).timeout
					#reset_prompt()
				#else:
					#emit_signal("prompt_completed", false)
				await get_tree().create_timer(0.5).timeout
				reset_prompt()

func mark_key_correct(index):
	var key_node = key_container.get_child(index)
	key_node.correct()

func mark_key_incorrect(index):
	var key_node = key_container.get_child(index)
	key_node.incorrect()

func reset_prompt():
	current_prompt = generate_prompt(8)
	current_index = 0
	status = true
	display_prompt()
