extends Control

signal image_picked(is_correct: bool)

@onready var hbox = $HBoxContainer
@onready var timer = $Timer

var image_paths = [
	"res://Assets/Imgs/Rythm/arrow_down.png",
	"res://Assets/Imgs/Rythm/bar.png",
	"res://Assets/Imgs/Rythm/bg.png",
	"res://icon.svg"
]

var correct_image_path = "res://icon.svg"

func _ready():
	randomize()
	spawn_image_buttons()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func spawn_image_buttons():
	clear_hbox()
	var shuffled_paths = image_paths.duplicate()
	shuffled_paths.shuffle()

	for path in shuffled_paths:
		var btn = TextureButton.new()
		btn.texture_normal = load(path)
		btn.set_meta("image_path", path)
		btn.connect("pressed", Callable(self, "_on_image_pressed").bind(btn))
		hbox.add_child(btn)

func _on_image_pressed(button):
	var picked_path = button.get_meta("image_path")
	emit_signal("image_picked", picked_path == correct_image_path)

func _on_timer_timeout():
	shuffle_buttons()

func shuffle_buttons():
	var buttons = hbox.get_children()
	buttons.shuffle()
	for b in buttons:
		hbox.remove_child(b)
	for b in buttons:
		hbox.add_child(b)

func clear_hbox():
	for child in hbox.get_children():
		hbox.remove_child(child)
		child.queue_free()
