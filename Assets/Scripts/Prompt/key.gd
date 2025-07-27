extends Control

@onready var bg = $Background
@onready var label = $Background/Label
var target_char := ""

func _ready():
	if label: # safety check
		label.text = target_char

func update_label(c: String):
	target_char = c
	
func correct():
	bg.color = Color.BLUE
	
func incorrect():
	bg.color = Color.RED
