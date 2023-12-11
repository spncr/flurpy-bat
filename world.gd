extends Node

@export var obstacle_scene: PackedScene

enum GameState {
	READY,
	GAME,
	OVER
}

const SAVE_FILE_PATH := "user://highscore.save"

var game_state: GameState = GameState.READY

var score: int = 0
var high_score: int= 0
var speed: float = 100

@onready var _score_label := $"HUD/Score"
@onready var _bat := $Bat
@onready var _start_position: Vector2 = $StartPosition.position
@onready var _animation_player := $AnimationPlayer
@onready var _obstacle_timer := $ObstacleTimer
@onready var _floor_stripe := $Floor/Stripe

func _ready():
	load_high_score()
	ready()

func _process(delta):
	match game_state:
		GameState.READY:
			move_floor(delta)
			if Input.is_action_just_pressed("button"):
				start_game()
		GameState.GAME:
			move_floor(delta)
		GameState.OVER:
			if Input.is_action_just_pressed("button") and not _animation_player.is_playing():
				get_ready(delta)

func ready():
	_animation_player.play_backwards("ready_go")
	_bat.get_ready(_start_position)


func get_ready(delta):
	_animation_player.play("fade_to_black")
	await _animation_player.animation_finished
	get_tree().call_group("obstacles", "queue_free")
	_animation_player.play_backwards("game_over_descends")
	await _animation_player.animation_finished
	ready()
	_animation_player.play_backwards("fade_to_black")
	await _animation_player.animation_finished
	game_state = GameState.READY


func start_game():
	_animation_player.play("ready_go")
	_bat.can_move = true
	_obstacle_timer.start()
	score = 0
	_score_label.text = str(score)
	game_state = GameState.GAME


func end_game():
	_obstacle_timer.stop()
	get_tree().call_group("obstacles", "stop_moving")
	_animation_player.play("game_over_descends")
	
	if score > high_score:
		high_score = score
		save_high_score()
	game_state = GameState.OVER

func move_floor(delta):
	_floor_stripe.region_rect.position.x += (speed / 2 * delta)


func save_high_score():
	var save_data = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	save_data.store_var(high_score)


func load_high_score():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var save_data = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		high_score = save_data.get_var()

## Callbacks
func _on_obstacle_timer_timeout():
	var obstacle = obstacle_scene.instantiate()
	obstacle.position.x = 500
	obstacle.position.y = randf_range(60, 290)
	obstacle.start_moving(speed)
	obstacle.add_to_group("obstacles")
	obstacle.scored.connect(_on_scored)
	add_child(obstacle)


func _on_bat_died():
	_animation_player.play("whiteout")
	await _animation_player.animation_finished

func _on_scored():
	if game_state == GameState.GAME:
		score += 1
		if score > 0:
			_score_label.visible = true
		_score_label.text = str(score)

func _on_bat_corpse_on_floor():
	end_game()
