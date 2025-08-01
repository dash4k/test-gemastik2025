extends Marker2D

func _draw() -> void:
	draw_circle(Vector2.ZERO, 75, Color.BLANCHED_ALMOND)
	
func select():
	for child in get_tree().get_nodes_in_group("file_drop_zone"):
		child.deselect()
	modulate = Color.WEB_MAROON
	
func deselect():
	modulate = Color.BLANCHED_ALMOND
