extends CharacterBody2D

signal died()

@export var gravity = 1100
@export var MAX_SPEED = 1200
@export var power = 32000

@onready var sprite = $Sprite2D

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("button"):
		velocity.y -= power * delta
#		sprite.set_rotation_degrees(-20)
#
#	if sprite.rotation_degrees != 0:
#		print(sprite.rotation_degrees)
#		var new_angle = lerp(sprite.rotation_degrees, 0.0, delta )
#		sprite.set_rotation_degrees(new_angle)

	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	
	var new_rotation:float = 0
	if velocity.y < 0:
		new_rotation = remap(velocity.y, -MAX_SPEED, 0, -PI/4, 0)
	else:
		new_rotation = remap(velocity.y, 0, MAX_SPEED, 0, PI)
	sprite.set_rotation(lerp_angle(sprite.rotation, new_rotation, delta * 30))
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		emit_signal("died")

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	

