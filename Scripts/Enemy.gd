class_name enemy
extends CharacterBody3D

@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var nav_agent = $NavigationAgent3D
@onready var timer = $Timer


@export var move_speed = 2.0
@export var attack_range = 2.0
@export var damage_power = 10
@export var enemy_health = 100

@onready var player = $"../Player"

signal damage(damage_power)

var can_attack = true
var dead = false


func _ready():
	#animated_sprite_3d.animation_finished.connect(attack_anim_done)
	pass


func _physics_process(delta):
	if dead:
		return
	if player == null:
		#print("player is null")
		return
	
	#var dir = player.global_position - global_position
	#dir.y = 0.0
	#dir = dir.normalized()
	
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * move_speed
	
	nav_agent.set_velocity_forced(new_velocity)
	
	animated_sprite_3d.play("idle")
	
	velocity = new_velocity
	#velocity = dir * move_speed
	#move_and_slide()
	attempt_to_kill_player()


func update_target_location(target_location):
	nav_agent.target_position = target_location

func attempt_to_kill_player():
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		return
	
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position+eye_line, player.global_position+eye_line, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	#If enemy is colliding with player
	if !can_attack:
		return
	can_attack = false
	timer.start()
	if result.is_empty():
		print("colliding")
		emit_signal("damage",damage_power)
		#animated_sprite_3d.play("attack")
		player.kill()


#Calls when enemy health reaches zero
func kill():
	if enemy_health <= 0:
		dead = true
		$AudioStreamPlayer3D.play()
		animated_sprite_3d.play("death")
		$CollisionShape3D.disabled = true


####################
# SIGNAL FUNCTIONS #
####################
#func attack_anim_done():
	#can_attack = true


func _on_player_damage(damage_power):
	enemy_health -= damage_power


func _on_player_melee(melee_damage):
	enemy_health -= melee_damage


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()


func _on_timer_timeout():
	can_attack = true
