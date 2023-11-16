extends CharacterBody2D

@export var gravity = 1100
@export var MAX_SPEED = 1200
@export var power = 32000

@onready var sprite = $Sprite2D

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("button"):
		velocity.y -= power * delta
		sprite.set_rotation_degrees(-20)
	
	if sprite.rotation_degrees != 0:
		print(sprite.rotation_degrees)
		var new_angle = lerp(sprite.rotation_degrees, 0.0, delta )
		sprite.set_rotation_degrees(new_angle)

	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	move_and_slide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	

