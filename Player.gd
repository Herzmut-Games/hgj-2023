extends CharacterBody2D

@export var ACCELERATION = 0.1
@export var FRICTION = 1
@export var MAX_SPEED = 100

@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionBox/CollisionShape2D

@onready var rain = $Camera2D/CanvasLayer/RainRect
@onready var rain_filter = $Camera2D/CanvasLayer/RainFilter
@onready var notify_label = $Camera2D/CanvasLayer/PanelContainer
@onready var notify_rtl = $Camera2D/CanvasLayer/PanelContainer/MarginContainer/RichTextLabel
@onready var notify_timer = $NotifyTimer
@onready var thunderstorm_player = $ThunderstormPlayer
@onready var footstep_player = $FootstepPlayer

enum {
	RUN,
	INTERACT,
}

var direction_vector = Vector2.RIGHT
var targets = []
var direction = Vector2.ZERO
var state = RUN

func _ready():
	Game.season_changed.connect(season_changed)
	Game.notify.connect(notify)
	_play_animation("idle")

	Game.send_notify("Hä, wo bin ich und was hat das mit überleben, Pfeil- und Leertasten zu tun??")

func _physics_process(delta):
	run_state(delta)

func run_state(_delta):
	if state == RUN:
		calc_interaction()

		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()

		if input_vector != Vector2.ZERO:
			direction_vector = input_vector
			velocity = velocity.lerp(direction_vector * MAX_SPEED, ACCELERATION)
			_play_animation("walk")
			if !footstep_player.playing:
				footstep_player.play()
		else:
			velocity = velocity.lerp(Vector2.ZERO, FRICTION)
			_play_animation("idle")
		if Input.is_action_just_pressed("action"):
			state = INTERACT
			animated_sprite.offset.y = 8
			interaction_area.disabled = false 
			_play_animation("action")


		move_and_slide()
	elif state == INTERACT:
		pass

func calc_interaction():
	var direction = _get_direction_string(direction_vector.angle())
	if direction == "left":
		interaction_area.position.x = -13
		interaction_area.position.y = 9
		interaction_area.rotation_degrees = 90
	elif direction == "right":
		interaction_area.position.x = 13
		interaction_area.position.y = 9
		interaction_area.rotation_degrees = 90
	elif direction == "up":
		interaction_area.position.x = 0
		interaction_area.position.y = -7
		interaction_area.rotation_degrees = 0
	elif direction == "down":
		interaction_area.position.x = 0
		interaction_area.position.y = 19
		interaction_area.rotation_degrees = 0

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



func _on_animated_sprite_2d_animation_finished():
	if state == INTERACT:
		animated_sprite.offset.y = 0
		interaction_area.disabled = true
		state = RUN

func season_changed(_season):
	if Game.thunderstorm:
		rain.visible = true
		rain_filter.visible = true
		thunderstorm_player.play()
	else:
		rain.visible = false
		rain_filter.visible = false
		thunderstorm_player.stop()

func interact(_area):
	pass

func notify(text):
	notify_label.visible = true
	notify_rtl.clear()
	notify_rtl.add_text(text)
	notify_timer.start()


func _on_notify_timer_timeout():
	notify_label.visible = false
