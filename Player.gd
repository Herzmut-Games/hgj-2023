extends CharacterBody2D

@export var ACCELERATION = 0.1
@export var FRICTION = 1
@export var MAX_SPEED = 100

@onready var animated_sprite = $AnimatedSprite2D

enum {
	RUN,
	INTERACT,
}

var direction_vector = Vector2.RIGHT
var targets = []
var direction = Vector2.ZERO

func _ready():
	_play_animation("idle")

func _physics_process(delta):
	run_state(delta)

func run_state(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		direction_vector = input_vector
		velocity = velocity.lerp(direction_vector * MAX_SPEED, ACCELERATION)
		_play_animation("walk")
	else:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION)
		_play_animation("idle")

	move_and_slide()


func animation_finished():
	if !Input.is_action_pressed("action"):
		velocity = Vector2.ZERO

func on_target_hit() -> void:
	for target in targets:
		target.hit()

func _on_Hitbox_body_entered(body):
	targets.append(body)

func _on_Hitbox_body_exited(body):
	targets.erase(body)

func _get_direction_string(angle: float) -> String:
	var angle_deg = round(rad_to_deg(angle))

	if angle_deg > -45.0 and angle_deg < 45.0:
		return "right"
	elif angle_deg >= 45.0 and angle_deg <= 135.0:
		return "down"
	elif angle_deg <= -45.0 and angle_deg >= -135.0:
		return "up"

	return "left"

func _play_animation(animation_type: String) -> void:
	var animation_name = animation_type + "_" + _get_direction_string(direction_vector.angle())
	animated_sprite.play(animation_name)

