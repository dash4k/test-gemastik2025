extends Control

signal image_picked(is_correct: bool)

@onready var hbox = $HBoxContainer
@onready var timer = $Timer
@onready var hint = $Hint

var image_paths = {
	"Bicycle": "res://Assets/Imgs/Photo/bicycle.png",
	"Bird": "res://Assets/Imgs/Photo/bird.png",
	"Car": "res://Assets/Imgs/Photo/car.png",
	"Cat": "res://Assets/Imgs/Photo/cat.png",
	"Cow": "res://Assets/Imgs/Photo/cow.png",
	"Dog": "res://Assets/Imgs/Photo/dog.png",
	"Fish": "res://Assets/Imgs/Photo/fish.png",
	"Plane": "res://Assets/Imgs/Photo/plane.png",
	"Ship": "res://Assets/Imgs/Photo/ship.png",
	"Train": "res://Assets/Imgs/Photo/train.png",
}

var correct_image_path: String
var game_active: bool = true

func _ready():
	randomize()
	start_game()
	hbox.add_theme_constant_override("separation", 30)
	timer.timeout.connect(_on_timer_timeout)

func start_game():
	clear_hbox()
	game_active = true

	# Get 3 random unique items from image_paths
	var keys = image_paths.keys()
	keys.shuffle()
	var selected_keys = keys.slice(0, 3)

	# Pick one of the 3 as the correct answer
	var correct_key = selected_keys[randi() % selected_keys.size()]
	correct_image_path = image_paths[correct_key]

	# Update hint text
	hint.text = "Choose " + correct_key

	# Create a reduced dictionary of selected images
	var selected_paths = {}
	for key in selected_keys:
		selected_paths[key] = image_paths[key]

	# Spawn buttons for the selected images
	spawn_image_buttons(selected_paths)

	timer.start()

func spawn_image_buttons(selected_images: Dictionary):
	var shuffled_paths = selected_images.values()
	shuffled_paths.shuffle()

	for path in shuffled_paths:
		var panel = Panel.new()
		panel.custom_minimum_size = Vector2(100, 100)

		var style = StyleBoxFlat.new()
		style.bg_color = Color.AZURE
		style.border_color = Color.BLACK
		set_all_border_width(style, 2)
		style.corner_radius_top_left = 6
		style.corner_radius_top_right = 6
		style.corner_radius_bottom_left = 6
		style.corner_radius_bottom_right = 6
		panel.add_theme_stylebox_override("panel", style)

		var btn = TextureButton.new()
		btn.texture_normal = load(path)
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		btn.set_meta("image_path", path)
		btn.pressed.connect(_on_image_pressed.bind(btn))

		panel.add_child(btn)
		hbox.add_child(panel)

func _on_image_pressed(button):
	if not game_active:
		return

	var picked_path = button.get_meta("image_path")

	if picked_path == correct_image_path:
		game_active = false
		timer.stop()
		emit_signal("image_picked", true)
		_disable_all_buttons()
	else:
		emit_signal("image_picked", false)

		var panel = button.get_parent()
		play_jitter_animation(panel)

		await get_tree().create_timer(0.4).timeout
		start_game()

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

func _disable_all_buttons():
	for child in hbox.get_children():
		if child is TextureButton:
			child.disabled = true

func set_all_border_width(stylebox: StyleBoxFlat, width: int):
	stylebox.border_width_left = width
	stylebox.border_width_top = width
	stylebox.border_width_right = width
	stylebox.border_width_bottom = width

func play_jitter_animation(node: Control):
	var original_pos = node.position
	var shake_amount = 5
	var tween = create_tween()

	for i in range(4):
		var offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		tween.tween_property(node, "position", original_pos + offset, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Return to original position at the end
	tween.tween_property(node, "position", original_pos, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
