extends Control

func SetTextInfo(text: String):
	$ScoreType.text = text
	
	match text:
		"PERFECT":
			$ScoreType.set("theme_override_colors/default_color", Color("ffbe00"))
		"GREAT":
			$ScoreType.set("theme_override_colors/default_color", Color("e2dd25"))
		"GOOD":
			$ScoreType.set("theme_override_colors/default_color", Color("a7dd25"))
		"OK":
			$ScoreType.set("theme_override_colors/default_color", Color("8dbfc7"))
		_:
			$ScoreType.set("theme_override_colors/default_color", Color("5a5758"))
