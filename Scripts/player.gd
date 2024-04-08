extends CharacterBody3D

@onready var revolver_sprite = $UI/Revolver/AnimatedSprite2D
@onready var revolver_audio = $Camera3D/RevolverAudio
@onready var shotgun_sprite = $UI/Shotgun/AnimatedSprite2D
@onready var shotgun_audio = $Camera3D/ShotgunAudio

@onready var sniper_sprite = $UI/Sniper/AnimatedSprite2D
@onready var sniper_audio = $Camera3D/SniperAudio

@onready var melee_anim = $MeleeRay/MeleeAnim
@onready var death_screen = $UI/DeathScreen
@onready var ray_cast_3d = $GunRayCast
@onready var interact_ray = $InteractRay
@onready var melee_ray = $MeleeRay
@onready var hud_weapon_sprite = $UI/Bottom/WeaponLabel/WeaponHUD
@onready var blood_particles = $MeleeRay/BloodParticles
@onready var melee_timer = $MeleeRay/MeleeTimer
@onready var animation_player = $AnimationPlayer
@onready var melee_audio = $MeleeRay/MeleeAudioPlayer

@export var damage_power_P = 25
@export var melee_damage = 20

const SPEED = 5.0
const MOUSE_SENS = 0.2

var can_shoot = true
var can_punch = true
var dead = false
var health = 100
var current_weapon = "revolver"

signal damage(damage_power_P)
signal melee(melee_damage)


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
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
			shotgun_audio.play()
			shoot()
		else :
			revolver_audio.play()
			shoot()
	if Input.is_action_just_pressed("show_health"):
		show_health()
	if Input.is_action_just_pressed("Melee attack"):
		meleeAttack()
	else:
		melee_anim.hide()


func _process(delta):
	if dead:
		$UI/Bottom/HealthCounter.text = str(0)
	if Input.is_action_just_pressed("restart"):
		restart()
		#health -= 100
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	gun_switch()


#Movement code
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
		
	#_on_melee_timer_timeout()
	update_ammo_label()
	update_health_label()
	move_and_slide()


#restarts scene
func restart():
	get_tree().reload_current_scene()


func meleeAttack():
	if !can_punch:
		return
	can_punch = false
	melee_timer.start()
	melee_anim.show()
	melee_anim.play("attack")
	melee_audio.play()
	if melee_ray.is_colliding() and melee_ray.get_collider().has_method("_on_player_melee"):
		emit_signal("melee", melee_damage)
		blood_particles.emitting = true
		melee_ray.get_collider().kill()
		


func shoot():
	if !can_shoot:
		return
	can_shoot = false
	if current_weapon == "revolver":
		revolver_sprite.play("revolver shoot")
	if current_weapon == "shotgun":
		shotgun_sprite.play("shoot")
		
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("_on_player_damage"):
		emit_signal("damage", damage_power_P)
		ray_cast_3d.get_collider().kill()


func update_ammo_label():
	pass
	

#Updates health counter
func update_health_label():
	if dead:
		pass
		#$UI/Bottom/HealthCounter.text = str(0)
	$UI/Bottom/HealthCounter.text = str(health)


func gun_switch():
	if current_weapon == "revolver":
		revolver_sprite.show()
		shotgun_sprite.hide()
		sniper_sprite.hide()
		hud_weapon_sprite.play("Revolver")
	
	if current_weapon == "shotgun":
		shotgun_sprite.show()
		revolver_sprite.hide()
		sniper_sprite.hide()
		hud_weapon_sprite.play("Shotgun")
	
	if current_weapon == "sniper":
		sniper_sprite.show()
		revolver_sprite.hide()
		shotgun_sprite.hide()
		hud_weapon_sprite.play("Sniper")


#Allows shooting after animation is done
func shoot_anim_done_revolver():
	can_shoot = true

func shoot_anim_done_shotgun():
	can_shoot = true


#Dies when health reaches zero
func kill():
	if health <= 0:
		dead = true
		death_screen.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


#Shows health in console
func show_health():
	print(health)
	print(current_weapon)
	print(damage_power_P)
	print(can_shoot)


####################
# Signal Functions #
####################

func Hit_Succesfull(projectile_damage):
	#print("Projectilel")
	if dead:
		return
	health -= projectile_damage

#Takes damage when colliding with enemy
func _on_enemy_damage(damage_power):
	if dead:
		return
	health -= damage_power
	animation_player.play("pain")


#Heals when interacting with medkit
func _on_med_kit_heal(heal_amount):
	health += heal_amount


#Changes gun damage when interacting with shotgun Object
func _on_shotgun_object_damage(damage_num):
	damage_power_P = damage_num


#Cahnges the current weapon to shotgun
func _on_shotgun_object_weapons_name(weapon_name):
	current_weapon = weapon_name


#Changes gun damage when interacting with Sniper Object
func _on_sniper_object_damage(damage_num):
	damage_power_P = damage_num


#Cahnges the current weapon to sniper
func _on_sniper_object_weapons_name(weapon_name):
	current_weapon = weapon_name


#Changes the "can shoot var to true when using shotgun
func _on_timer_timeout():
	can_shoot = true


func _on_melee_timer_timeout():
	can_punch = true


func _on_revolver_object_damage(damage_num):
	damage_power_P = damage_num


func _on_revolver_object_weapons_name(weapon_name):
	current_weapon = weapon_name

