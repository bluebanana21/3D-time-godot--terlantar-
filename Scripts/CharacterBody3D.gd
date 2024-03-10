extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var SENSITIVITY = 0.03

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Bullets
var bullet = load("res://Scenes/bullet.tscn")
var instance

#camera variables
@onready var head := $Head
@onready var camera := $Head/Camera3D
@onready var gun_barrel = $Head/Camera3D/Rifle


#removes mouse cursor
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


#Camera controls
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * SENSITIVITY
	
	


func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	
	if Input.is_action_pressed("Shoot"):
		instance = bullet.instantiate()
		instance.position = gun_barrel.global_position
		instance.transform.basis = gun_barrel.global_transform.basis
		get_parent().add_child(instance)
	
	move_and_slide()
