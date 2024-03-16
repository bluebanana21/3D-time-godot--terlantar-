extends CharacterBody3D

@onready var revolver_sprite = $UI/Revolver/AnimatedSprite2D
@onready var shotgun_sprite = $UI/Shotgun/AnimatedSprite2D
@onready var ray_cast_3d = $GunRayCast
@onready var death_screen = $CanvasLayer/DeathScreen
@onready var interact_ray = $InteractRay

@export var damage_power = 50

const SPEED = 5.0
const MOUSE_SENS = 0.5

var can_shoot = true
var dead = false

var health = 100
var current_weapon = "revolver"
#var current_weapon = "shotgun"

signal damage(damage_power)


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	revolver_sprite.animation_finished.connect(shoot_anim_done)
	$UI/DeathScreen/Panel/Button.button_up.connect(restart)


func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENS
	
	if dead:
		return
	if Input.is_action_just_pressed("Shoot"):
		$AudioStreamPlayer3D.play()
		shoot()
	if Input.is_action_just_pressed("show_health"):
		show_health()
	if Input.is_action_just_pressed("switch_primary"):
		print("switched to primary")
		damage_power = 25


func _process(delta):
	if Input.is_action_just_pressed("restart"):
		restart()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	gun_switch()


func _physics_process(delta):
	if dead:
		return
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()


#restarts scene
func restart():
	get_tree().reload_current_scene()


func shoot():
	if !can_shoot:
		return
	can_shoot = false
	revolver_sprite.play("shoot")
	#if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("kill"):
		#ray_cast_3d.get_collider().kill()
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("_on_player_damage"):
		emit_signal("damage", damage_power)
		ray_cast_3d.get_collider().kill()


func gun_switch():
	if current_weapon == "revolver":
		revolver_sprite.show()
		shotgun_sprite.hide()
	
	if current_weapon == "shotgun":
		revolver_sprite.hide()
		shotgun_sprite.show()


#Allows shooting after animation is done
func shoot_anim_done():
	can_shoot = true

#Dies when health reaches zero
func kill():
	#health -= 1
	if health <= 0:
		dead = true
		death_screen.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


#Shows health in console
func show_health():
	print(health)


#Signal Functions
#Takes damage when colliding with enemy
func _on_enemy_damage(damage_power):
	health -= damage_power

#Heals when interacting with the gun Box
func _on_gun_box_heal(heal_amount):
	health += heal_amount

#Heals when interacting with medkit
func _on_med_kit_heal(heal_amount):
	health += heal_amount

#Changes gun damage when interacting with shotgun pic
func _on_gun_box_damage(damage_num):
	damage_power = damage_num


func _on_shotgun_object_weapons_name(weapon_name):
	current_weapon = weapon_name
