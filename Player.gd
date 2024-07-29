extends Area2D

@export var speed = 400
var screen_size
var _target_angle
@onready var tween = get_tree().create_tween()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	var input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	
	var velocity
	
	if input.length_squared() > 0:
		rotation = input.angle()
		velocity = input.normalized() * speed
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.stop()
		velocity = Vector2.ZERO
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
