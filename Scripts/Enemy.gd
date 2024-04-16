extends CharacterBody3D

@export var enemy_resource : Enemy

@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var nav_agent = $NavigationAgent3D
@onready var attack_timer = $AttackTimer
@onready var shoot_timer = $ShootTimer
@onready var gun_ray_cast = $GunRayCast
@onready var death_audio = $DeathAudio

@onready var player = $"../../Player"

#@export var move_speed = 2.0
#@export var attack_range = 2.0
#@export var damage_power = 10
#@export var enemy_health = 100


signal damage(damage_power)

#var other_player = null
var can_shoot = true
var can_attack = true
var dead = false
var bullet = preload("res://Scenes/bullet.tscn")
var weapon = preload("res://Scenes/shotgun.tscn")
var instance


func _ready():
	pass


func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	
	
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * enemy_resource.move_speed
	
	nav_agent.set_velocity_forced(new_velocity)
	
	animated_sprite_3d.play("idle")
	
	velocity = new_velocity
	shoot()
	attempt_to_kill_player()
	player.kill()
	move_and_slide()


func update_target_location(target_location):
	nav_agent.target_position = target_location


func attempt_to_kill_player():
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > enemy_resource.attack_range:
		return
	
	var eye_line = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position+eye_line, player.global_position+eye_line, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	#If enemy is colliding with player
	if !can_attack:
		return
	can_attack = false
	attack_timer.start()
	if result.is_empty():
		print("colliding")
		player._on_enemy_damage(enemy_resource.damage_power)


func shoot():
	look_at(Vector3(player.global_position.x,  global_position.y, player.global_position.z), Vector3.UP)
	
	if !can_shoot:
		return
	if can_shoot:
		instance = bullet.instantiate()
		instance.position = gun_ray_cast.global_position
		instance.transform.basis = gun_ray_cast.global_transform.basis
		get_parent().add_child(instance)
	can_shoot = false
	shoot_timer.start()

#Calls when enemy health reaches zero
func kill():
	if enemy_resource.enemy_health <= 0:
		#queue_free()
		dead = true
		$DeathAudio.play()
		animated_sprite_3d.play("death")
		$CollisionShape3D.disabled = true
		instance = weapon.instantiate()
		get_parent().add_child(instance)
		instance.position = $".".global_position

#func take_damage(damage_power_p):
	#enemy_resource.enemy_health -= damage_power_P
####################
# SIGNAL FUNCTIONS #
####################
func _on_player_damage(damage_power_P):
	enemy_resource.enemy_health -= damage_power_P


func _on_player_melee(melee_damage):
	enemy_resource.enemy_health -= melee_damage


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()


func _on_shoot_timer_timeout():
	can_shoot = true
	#shoot()


func _on_attack_timer_timeout():
	can_attack = true
