extends CharacterBody2D
class_name Player
signal died

enum State{ # 角色状态
	STAND,
	RUN,
	JUMP,
	CLIMB,
	HURT
}

var g = ProjectSettings.get_setting("physics/2d/default_gravity")
var state : State = State.STAND

@export var speed : int = 250
@export var jump_speed : int = 350

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_flash : Node = $HitFlash
func _process(delta: float) -> void:
	play_animation()

func _physics_process(delta: float) -> void:
	if state == State.HURT:
		return
	velocity.y += g * delta
	moving_input()
	move_and_slide()
	
	if is_on_floor():
		if state == State.JUMP or velocity.x == 0:
			state = State.STAND
		elif state != State.HURT or velocity.x != 0:
			state = State.RUN

func hurt():
	state = State.HURT
	var tween = create_tween()
	tween.set_loops(1)
	tween.tween_callback(hit_flash.flash)
	tween.tween_interval(1)
	await get_tree().create_timer(1).timeout
	queue_free()
	died.emit()

func moving_input():
	if is_on_floor():
		velocity.x = 0
	if not Input.is_anything_pressed() and is_on_floor() and state != State.HURT:
		state = State.STAND
		velocity.x = 0
		return
	if Input.is_action_pressed("move_left"):
		if is_on_floor():
			state = State.RUN
		velocity.x = -speed
		sprite.flip_h = true
	if Input.is_action_pressed("move_right"):
		if is_on_floor():
			state = State.RUN
		velocity.x = speed
		sprite.flip_h = false
	if Input.is_action_just_pressed("jump"):
		if not is_on_floor() and (state == State.JUMP or velocity.y < 0):
			return
		state = State.JUMP
		velocity.y = -jump_speed
		return

func play_animation():
	if not is_on_floor() and state != State.HURT:
		if velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("fall")
	match state:
		State.STAND:
			sprite.play("stand")
		State.RUN:
			sprite.play("run")
		State.HURT:
			sprite.play("hurt")
