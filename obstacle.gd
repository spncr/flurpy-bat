extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	constant_linear_velocity = Vector2(-100, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x -= 100 * delta

func _on_screen_exited():
	queue_free()
