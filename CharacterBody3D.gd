extends CharacterBody3D

@export var speed = 4
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("Forward"):
		direction.x += 1
	if Input.is_action_pressed("Down"):
		direction.x -= 1
	if Input.is_action_pressed("Left"):
		direction.z -= 1
	if Input.is_action_pressed("Right"):
		direction.z += 1
