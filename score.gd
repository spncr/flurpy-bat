extends Label

func show_score(value, speed):
	var tween = create_tween()
	text = str(value)
	var destination = position - Vector2(1.5 * speed, 80)
	tween.set_parallel(true)
	tween.tween_property(self, "position", destination , 1.5)
	tween.tween_property(self, "modulate", Color(1,1,1,0), 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.set_parallel(false)
	tween.tween_callback(queue_free)
