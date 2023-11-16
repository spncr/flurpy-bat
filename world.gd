extends Node

@export var obstacle_scene: PackedScene
var score: int = 0

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Floor/Stripe.region_rect.position.x = $Floor/Stripe.region_rect.position.x + (50 * delta)

func game_over():
	$ObstacleTimer.stop()
	
func start():
	score = 0
	$StartTimer.start()
	$Bat.start($StartPosition.position)

func _on_start_timer_timeout():
	$ObstacleTimer.start()
	print('go')
	
func _on_obstacle_timer_timeout():
	var obstacle = obstacle_scene.instantiate()
	obstacle.position.x = 500
	obstacle.position.y = randf_range(60, 290)
	add_child(obstacle)

