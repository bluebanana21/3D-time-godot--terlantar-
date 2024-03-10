extends CharacterBody3D
#
#@onready var animated_sprite_3d = $AnimatedSprite3D
#
#@export var move_speed = 2.0
#@export var attack_range = 2.0
##@export var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
#
#func _physics_process(delta):
	#var dir = player.global_position - global_position
	#dir.y = 0.0
	#dir = dir.normalized()
	#
	#velocity = dir * move_speed
	#move_and_slide()
