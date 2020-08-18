extends KinematicBody2D

export(int) var GRAVITY = 10
export(int) var MASS = 3
export(int) var ACCELERATION = 1000
export(int) var MAX_SPEED = 100
export(int) var FRICTION = 900
export(int) var JUMP_POWER = -700
export(int) var ATTACK_POWER = 600
export(int) var SOFT_COLLISIONS = 500
	
const FLOOR = Vector2(0, -1)
const die_effect = preload("res://Effect/DieEffect.tscn")
const ghost_sprite = preload("res://Effect/GhostSprite.tscn")
enum {
	WANDER,
	IDLE,
	CHASE,
	INVINCIBLE,
	ATTACK
}

var state = IDLE
var velocity = Vector2.ZERO
var player = null
var num = 0
var turn = false

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var stats = $Stats
onready var hurt_box = $HurtBox
onready var hurt_box_collision = $HurtBox/CollisionShape2D
onready var attack_timer = $AttackTimer
onready var ghost_timer = $GhostTimer
onready var running_particle = $Particle
onready var wander_controller = $WanderController
onready var soft_collision = $SoftCollision
onready var soft_collision_shape = $SoftCollision/CollisionShape2D
onready var hitbox_pivot = $HitboxPivot
onready var hitbox_pivot_collision = $HitboxPivot/HitBox/CollisionShape2D
onready var attack_detection_pivot = $AttackDetectionPivot
onready var player_detection_zone = $PlayerDetectionZone

signal on_wall
signal enemie_died

func make_particle_effect():
	running_particle.set_emitting(true)

	if not sprite.flip_h:
		running_particle.get_process_material().initial_velocity = -50
		running_particle.position.x = -2
	else:
		running_particle.get_process_material().initial_velocity = 50
		running_particle.position.x = 2
		
func die():
	emit_signal("enemie_died")
	var die_effect_instance = die_effect.instance()
	get_parent().add_child(die_effect_instance)
	die_effect_instance.flip_h = sprite.flip_h
	die_effect_instance.position = self.position + Vector2(0, -16)
	queue_free()
	
func needs_to_flip():
	sprite.flip_h = velocity.x < 0
	hitbox_pivot.rotation_degrees = 90 if sprite.flip_h else 270
	attack_detection_pivot.rotation_degrees = 90 if sprite.flip_h else 270
	
func attack():
	if state != ATTACK and state != INVINCIBLE:
		state = ATTACK
		ghost_timer.start()
		attack_timer.start()
		animation_player.play("Attack")
		soft_collision_shape.set_deferred("disabled", true)
		hurt_box_collision.set_deferred("disabled", true)
		velocity.x = -ATTACK_POWER if sprite.flip_h else ATTACK_POWER

func move(delta, x):
	animation_player.play("Run")
	velocity = velocity.move_toward(Vector2(x, 0) * MAX_SPEED, ACCELERATION * delta)
	if is_on_wall(): emit_signal("on_wall")
	needs_to_flip()
	if is_on_floor(): make_particle_effect()
	
func seek_player():
	if player_detection_zone.can_see_player(): state = CHASE
	
func wander_state_controller(delta):
	move(delta, num)
	
func idle_state_controller(delta):
	animation_player.play("Idle")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
func chase_state_controller(delta):
	var direction = global_position.direction_to(player.global_position).normalized()
	direction.x = -1 if direction.x < 0 else 1
	move(delta, direction.x)
	if soft_collision.is_colliding(): velocity.x += soft_collision.get_push_vector().x * delta * SOFT_COLLISIONS
	
func _ready():
	hitbox_pivot_collision.disabled = true
	
func _physics_process(delta):
	
	match state:
		IDLE: idle_state_controller(delta)
		WANDER: wander_state_controller(delta)
		CHASE: chase_state_controller(delta)
	
	velocity.y += GRAVITY * MASS
	velocity = move_and_slide(velocity, FLOOR)
	
func _on_Stats_out_of_health():
	die()
	
func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	hurt_box.start_invencibility(0.5)
	
func _on_HurtBox_invencibility_started():
	animation_player.play("Hit")
	velocity.x = 0
	state = INVINCIBLE
	
func _on_HurtBox_invincibility_ended():
	state = CHASE if player else IDLE
	
func _on_WanderController_wait_to_wander_timer_ended():
	if state != CHASE and state != ATTACK:
		state = WANDER
		turn = false
		wander_controller.wander_timer.start(rand_range(0.4, 0.8))
		num = wander_controller.num
	
func _on_WanderController_wander_timer_ended():
	if state != CHASE and state != ATTACK:
		if soft_collision.is_colliding():
			wander_controller.reestart_wait_timer_cause_need_to_do_something()
			state = WANDER
			turn = false
		else:
			state = IDLE
			wander_controller.wait_to_wander_timer.start(rand_range(5, 10))
	
func _on_Enemy_on_wall():
	if state == CHASE: 
		if is_on_floor(): velocity.y = JUMP_POWER
			
	elif state == WANDER and not turn: 
		wander_controller.reestart_wait_timer_cause_need_to_do_something()
		num = -num
		turn = true
	
func _on_PlayerDetectionZone_body_entered(body):
	state = CHASE
	player = body
	
func _on_PlayerDetectionZone_body_exited(_body):
	state = IDLE
	player = null

func _on_HitBox_area_entered(_area):
	pass
	
func _on_AttackDetection_area_entered(_area):
	attack()

func attack_animation_finished():
	state = CHASE if player else IDLE
	soft_collision_shape.disabled = false
	hurt_box_collision.disabled = false
	ghost_timer.stop()

func _on_AttackTimer_timeout():
	velocity.x = 0

func _on_SoftCollision_area_entered(_area):
	pass # Replace with function body.

func _on_GhostTimer_timeout():
	var ghost_sprite_instance = ghost_sprite.instance()
	get_parent().add_child(ghost_sprite_instance)
	ghost_sprite_instance.texture = sprite.texture
	ghost_sprite_instance.hframes = 44
	ghost_sprite_instance.frame = sprite.frame
	ghost_sprite_instance.flip_h = sprite.flip_h
	ghost_sprite_instance.position = self.position + Vector2(0, -16)
