extends CharacterBody3D

@onready var revolver_sprite = $UI/Revolver/AnimatedSprite2D
@onready var revolver_audio = $UI/Revolver/AudioStreamPlayer3D
@onready var shotgun_sprite = $UI/Shotgun/AnimatedSprite2D
@onready var death_screen = $UI/DeathScreen
@onready var ray_cast_3d = $GunRayCast
@onready var interact_ray = $InteractRay
@onready var melee_ray = $MeleeRay


@export var damage_power = 25
@export var melee_damage = 20

const SPEED = 5.0
const MOUSE_SENS = 0.2

var can_shoot = true
var dead = false
var health = 100
var current_weapon = "revolver"
#@onready var melee_script = $RayCast3D
#var current_weapon = "shotgun"

signal damage(damage_power)
signal melee(melee_damage)


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#revolver_sprite.animation_finished.connect(shoot_anim_done)
	if current_weapon == "revolver":
		revolver_sprite.animation_finished.connect(shoot_anim_done_revolver)
	if current_weapon == "shotgun":
		shotgun_sprite.animation_finished.connect(shoot_anim_done_shotgun)
	$UI/DeathScreen/Panel/Button.button_up.connect(restart)


func _input(event):
	if dead:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_SENS
	if dead:
		return
	if Input.is_action_just_pressed("Shoot"):
		if current_weapon == "shotgun":
			$UI/Shotgun/Timer.start()
			shoot()
		else :
			revolver_audio.play()
			shoot()
	if Input.is_action_just_pressed("show_health"):
		show_health()
	if Input.is_action_just_pressed("Melee attack"):
		meleeAttack()
		#melee_script.meleeAttack()


func _process(delta):
	if Input.is_action_just_pressed("restart"):
		restart()
		#health -= 100
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


func meleeAttack():
	#melee_anim.play("attack")
	if melee_ray.is_colliding() and melee_ray.get_collider().has_method("_on_player_melee"):
		emit_signal("melee", melee_damage)
		melee_ray.get_collider().kill()


func shoot():
	if !can_shoot:
		return
	can_shoot = false
	if current_weapon == "revolver":
		revolver_sprite.play("shoot")
	elif current_weapon == "shotgun":
		shotgun_sprite.play("shoot")
		
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
func shoot_anim_done_revolver():
	can_shoot = true

func shoot_anim_done_shotgun():
	can_shoot = true

#Dies when health reaches zero
func kill():
	if health <= 0:
		#print("dead")
		dead = true
		death_screen.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


#Shows health in console
func show_health():
	print(health)
	print(current_weapon)
	print(damage_power)
	print(can_shoot)


####################
# Signal Functions #
####################

#Takes damage when colliding with enemy
func _on_enemy_damage(damage_power):
	health -= damage_power


#Heals when interacting with medkit
func _on_med_kit_heal(heal_amount):
	health += heal_amount

#Changes gun damage when interacting with shotgun pic
func _on_shotgun_object_damage(damage_num):
	damage_power = damage_num


func _on_shotgun_object_weapons_name(weapon_name):
	current_weapon = weapon_name


func _on_sniper_object_damage(damage_num):
	damage_power = damage_num


func _on_sniper_object_weapons_name(weapon_name):
	current_weapon = weapon_name


func _on_timer_timeout():
	can_shoot = true
