extends KinematicBody2D

export(int) var ACCELERATION = 1000
export(int) var MAX_SPEED = 150
export(int) var FRICTION = 900
export(int) var GRAVITY = 10
export(int) var JUMP_HEIGHT = -700
export(int) var PLAYER_MASS = 3
export(int) var ATTACK_POWER = 650
const ghost_sprite = preload("res://Effect/GhostSprite.tscn")
const FLOOR = Vector2(0, -1)
enum { 
	RUN, 
	IDLE,
	JUMP,
	ATTACK,
	DIYING
}

var velocity = Vector2.ZERO
var velocity_before = Vector2.ZERO
var input_velocity = Vector2.ZERO
var state = IDLE
var attack_loop = false
var invincible  = false

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var dash_timer = $DashTimer
onready var ghost_timer = $GhostTimer
onready var hitbox_pivot = $HitboxPivot
onready var running_particle = $Particle
onready var hitbox_pivot_collision = $HitboxPivot/HitBox/CollisionShape2D
onready var player_hurtbox_collision_shape = $HurtBox/CollisionShape2D
onready var player_hurtbox = $HurtBox
onready var blink = $BlinkHitEffect

signal player_died

func make_particle_effect():
	running_particle.set_emitting(true)

	if not sprite.flip_h:
		running_particle.get_process_material().initial_velocity = -50
		running_particle.position.x = -2
	else:
		running_particle.get_process_material().initial_velocity = 50
		running_particle.position.x = 2

func take_hit(area):
	PlayerStats.health -= area.damage
	$Camera2D/ScreenShake.start()
	$HitSound.pitch_scale = 1.5
	$HitSound.play()
	
func die():
	velocity = Vector2.ZERO
	state = DIYING
	blink.play("End")
	animation_player.play("Die")
	player_hurtbox.set_deferred("disabled", true)

func die_animation_finished():
	emit_signal("player_died")
	
func attack_animation_finished():
	hitbox_pivot_collision.set_deferred("disabled", true)
	if not invincible: player_hurtbox_collision_shape.set_deferred("disabled", false)
	state = RUN if is_on_floor() else JUMP
	
func needs_to_flip(flip):
	sprite.flip_h = flip
	hitbox_pivot.rotation_degrees = 180 if sprite.flip_h else 0

func dash():
	velocity.x = -ATTACK_POWER if sprite.flip_h else ATTACK_POWER
	
func jump():
	$JumpSound.play()
	velocity.y = JUMP_HEIGHT
	if state != ATTACK: animation_player.play("Jump")
	state = JUMP
	
func attack():
	dash()
	$SwordSound.play()
	ghost_timer.start()
	dash_timer.start()
	player_hurtbox_collision_shape.disabled = true
	state = ATTACK
	if attack_loop: animation_player.play("Attack02")
	else: animation_player.play("Attack01")
	attack_loop = not attack_loop
	
func construct_input_velocity():
	input_velocity = Vector2.ZERO
	input_velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_velocity = input_velocity.normalized()

func move_player(delta):
	if input_velocity: velocity = velocity.move_toward(input_velocity * MAX_SPEED, ACCELERATION * delta)
	elif not velocity: state = IDLE
	else: velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
func idle_state_controller():
	animation_player.play("Idle")

func jump_state_controller(delta):
	construct_input_velocity()
	move_player(delta)
	if is_on_floor() and velocity.y >= 0: state = RUN
	
func run_state_controller(delta):
	animation_player.play("Run")
	if is_on_floor(): make_particle_effect()
	construct_input_velocity()
	move_player(delta)
	
func _ready():
	hitbox_pivot_collision.disabled = true
	var _connected = PlayerStats.connect("out_of_health", self, "die")

func _input(event):
	if state != DIYING:
		if is_on_floor():
			if event.is_action_pressed("jump"): jump()
			elif (event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right")): state = RUN if (state != ATTACK and state != JUMP) else state
		
		if event is InputEventMouseMotion: needs_to_flip(get_local_mouse_position().x < 0)
		if event.is_action_pressed("attack"): attack()

func _physics_process(delta):
	
	match state:
		IDLE: idle_state_controller()
		JUMP: jump_state_controller(delta)
		RUN: run_state_controller(delta)
	
	velocity.y += GRAVITY * PLAYER_MASS
	velocity = move_and_slide(velocity, FLOOR)

func _on_DashTimer_timeout():
	velocity.x = 0
	ghost_timer.stop()

func _on_HitBox_area_entered(_area):
	$Camera2D/ScreenShake.start()
	$HitSound.pitch_scale = 1
	$HitSound.play()

func _on_HurtBox_area_entered(area):
	if area.damage:
		take_hit(area)
		$SlowMotion.start()
		player_hurtbox.start_invencibility(1.5)

func _on_HurtBox_invencibility_started():
	blink.play("Start")
	invincible = true

func _on_HurtBox_invincibility_ended():
	blink.play("End")
	invincible = false

func _on_GhostTimer_timeout():
	var ghost_sprite_instance = ghost_sprite.instance()
	get_parent().add_child(ghost_sprite_instance)
	ghost_sprite_instance.texture = sprite.texture
	ghost_sprite_instance.hframes = 89
	ghost_sprite_instance.frame = sprite.frame
	ghost_sprite_instance.flip_h = sprite.flip_h
	ghost_sprite_instance.position = self.position + Vector2(0, -16)

func _on_BoundriesBox_area_entered(area):
	take_hit(area)
