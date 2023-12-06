extends Area2D

signal died()

var velocity = Vector2.ZERO
var playing = false
var can_input = false

@export var grav = 1100
@export var MAX_SPEED = 1200
@export var power = 32000

@onready var _sprite = $body
@onready var _particles := $GPUParticles2D


func _process(delta):
	if playing:
		velocity.y += grav * delta
		
		if Input.is_action_just_pressed("button") and can_input:
			$AnimationPlayer.play("jump")
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
		if position.y >= 500:
			velocity.y = 0
		position.y = clampf(position.y, -100, 500)
		

func get_ready(pos):
	position = pos
	can_input = true
	$AnimationPlayer.play("flappy")
	_sprite.set_rotation(0)

func _on_area_entered(area):
	if area.name == "Floor":
		playing = false
		emit_signal("died") # Replace with function body.
	velocity = Vector2.ZERO
	$AnimationPlayer.play('dead')
	can_input = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "jump":
		$AnimationPlayer.play("flappy")
