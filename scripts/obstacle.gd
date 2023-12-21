extends Area2D

signal scored

var speed:float = 0

@onready var _squeak_player := $SqueakPlayer

func _process(delta):
	position.x -= speed * delta

func _on_screen_exited():
	queue_free()


func start_moving(new_speed):
	speed = new_speed


func stop_moving():
	speed = 0


func _on_score_area_exited(_area):
	$SqueakPlayer.pitch_scale = randf_range(.8, 2)
	$SqueakPlayer.play()
	emit_signal("scored")
