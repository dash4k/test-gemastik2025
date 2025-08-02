extends Control

var score: int = 0

func _ready() -> void:
	RythmSignals.IncrementScore.connect(IncrementScore)
	
func IncrementScore(score_increment: int):
	score += score_increment
	%RythmScoreLabel.text = str(score) + " pts"
