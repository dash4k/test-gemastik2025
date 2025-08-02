extends Control

@onready var bg: Panel = $Background
@onready var label: Label = $Background/Label
var target_char: String = ""

func _ready():
	if label:
		label.text = target_char
	apply_default_style()

func update_label(c: String):
	target_char = c
	if label:
		label.text = target_char

func correct():
	set_panel_color(Color.BLUE, true)

func incorrect():
	set_panel_color(Color.RED, false)

func apply_default_style():
	set_panel_color(Color.GRAY, false)

func set_panel_color(color: Color, border: bool):
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(4)
	bg.add_theme_stylebox_override("panel", style)
	if border:
		style.border_color = Color.BLACK
		style.border_width_bottom = 3
		style.border_width_left = 3
		style.border_width_right = 3
		style.border_width_top = 3
