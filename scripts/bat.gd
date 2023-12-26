@icon("res://art/bat_body.png")
class_name Bat extends Area2D

signal scored()
signal died()
signal corpse_on_floor()

enum Layer {
	DEATH = 1,
	SCORE = 2
}

const GRAV = 1100
const MAX_SPEED = 1200
const POWER = 32000

var velocity = Vector2.ZERO
var can_move = false
var can_input = false 

@onready var _sprite = $body
@onready var _particles := $JumpParticles
@onready var _animation_player := $AnimationPlayer
@onready var _flap_sound_player := $FlapSoundPlayer
@onready var _death_sound_player := $DeathSoundPlayer
@onready var _squeak_sound_player := $SqueakSoundPlayer


func _process(delta):
	if can_move:
		velocity.y += GRAV * delta
		
		if Input.is_action_just_pressed("button") and can_input:
			_animation_player.play("jump")
			_flap_sound_player.pitch_scale = randf_range(1, 3)
			_flap_sound_player.play( )
			velocity.y -= POWER * delta
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
	_animation_player.play("flappy")
	_sprite.set_rotation(0)


func _on_area_entered(area):
	if area.get_collision_layer_value(Layer.DEATH):
		velocity = Vector2.ZERO
		_death_sound_player.pitch_scale = randf_range(0.4, 1.6)
		_death_sound_player.play()

		if can_input == true:
			_animation_player.play("dead")
			emit_signal("died")
			can_input = false

		if area.name == "Floor":
			can_move = false
			emit_signal("corpse_on_floor")


func _on_area_exited(area):
	if area.get_collision_layer_value(Layer.SCORE) and can_input:
		_squeak_sound_player.pitch_scale = randf_range(.8, 2)
		_squeak_sound_player.play()
		emit_signal("scored")
