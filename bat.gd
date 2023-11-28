extends Area2D

signal died()

var velocity = Vector2.ZERO

@export var grav = 1100
@export var MAX_SPEED = 1200
@export var power = 32000

@onready var sprite = $Sprite2D

func _process(delta):
	velocity.y += grav * delta
	
	if Input.is_action_just_pressed("button"):
		velocity.y -= power * delta

	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	
	var new_rotation:float = 0
	if velocity.y < 0:
		new_rotation = remap(velocity.y, -MAX_SPEED, 0, -PI/4, 0)
	else:
		new_rotation = remap(velocity.y, 0, MAX_SPEED, 0, PI)

	sprite.set_rotation(lerp_angle(sprite.rotation, new_rotation, delta * 30))

	position += velocity * delta
	if position.y >= 520:
		velocity.y = 0
	position.y = clampf(position.y, -100, 520)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_area_entered(area):
	emit_signal("died") # Replace with function body.
