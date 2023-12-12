extends Label

func show_score(value):
	var tween = create_tween()
	text = str(value)
	tween.tween_property(self, "modulate", Color(1,1,1,0), 2)
	tween.tween_callback(queue_free)
