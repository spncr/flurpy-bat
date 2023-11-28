extends Node

@export var obstacle_scene: PackedScene

var score: int = 0
var speed: float = 100
var game_over: bool = false

func _ready():
	start_game()

func _process(delta):
	if game_over:
		if Input.is_action_just_pressed("button"):
			start_game()
	else:
		$Floor/Stripe.region_rect.position.x += (speed / 2 * delta)

func end_game():
	$ObstacleTimer.stop()
	get_tree().call_group("obstacles", "stop_moving")
	game_over = true
	$"HUD/Game Over".visible = true
	
func start_game():
	score = 0
	game_over = false
	$"HUD/Game Over".visible = false
	get_tree().call_group("obstacles", "queue_free")
	$ObstacleTimer.start()
	$Bat.start($StartPosition.position)
	
func _on_obstacle_timer_timeout():
	var obstacle = obstacle_scene.instantiate()
	obstacle.position.x = 500
	obstacle.position.y = randf_range(60, 290)
	obstacle.start_moving(speed)
	obstacle.add_to_group("obstacles")
	obstacle.scored.connect(_on_scored)
	add_child(obstacle)

func _on_bat_died():
	end_game()

func _on_scored():
	if not game_over: score += 1
	$HUD/Score.text = str(score)
