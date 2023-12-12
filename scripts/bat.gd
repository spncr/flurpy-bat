extends Area2D

signal died()
signal corpse_on_floor()

var velocity = Vector2.ZERO
var can_move = false
var can_input = false 

@export var grav = 1100
@export var MAX_SPEED = 1200
@export var power = 32000

@onready var _sprite = $body
@onready var _particles := $JumpParticles
@onready var _score_label := $Score
@onready var _flap_sound_player := $FlapSoundPlayer
func _process(delta):
	if can_move:
		velocity.y += grav * delta
		
		if Input.is_action_just_pressed("button") and can_input:
			$AnimationPlayer.play("jump")
			_flap_sound_player.pitch_scale = randf_range(0.8, 1.2)
			_flap_sound_player.play( )
			velocity.y -= power * delta
			_particles.restart()
			_particles.emitting = true

		velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
		
		var new_rotation:float = 0
		if velocity.y < 0:
			new_rotation = remap(velocity.y, -MAX_SPEED, 0, -PI/4, 0)
		else:
			new_rotation = remap(velocity.y, 0, MAX_SPEED, 0, PI)
		_sprite.set_rotation(lerp_angle(_sprite.rotation, new_rotation, delta * 30))

		position += velocity * delta
		position.y = clampf(position.y, -20, 500)

func get_ready(pos):
	position = pos
	can_input = true
	$AnimationPlayer.play("flappy")
	_sprite.set_rotation(0)
	
func _on_area_entered(area):
	velocity = Vector2.ZERO
	
	if can_input == true:
		$AnimationPlayer.play("dead")
		emit_signal("died")
	can_input = false
	
	if area.name == "Floor":
		can_move = false
		emit_signal("corpse_on_floor")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "jump":
		$AnimationPlayer.play("flappy")