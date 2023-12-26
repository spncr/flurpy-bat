extends Area2D

signal scored

var speed: float = 0


func _process(delta):
	position.x -= speed * delta


func start_moving(new_speed):
	speed = new_speed


func stop_moving():
	speed = 0


func _on_screen_exited():
	queue_free()
