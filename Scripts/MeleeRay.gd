extends RayCast3D
#
##@export attack-range = 2
#@export var melee_damage = 20
#
#@onready var melee_raycast= $"."
#@onready var melee_anim = $MeleeAnim
#
#signal melee(melee_damage)
#
#func _ready():
	#pass
	##add_exception(owner)
	##melee_anim.hide()
#
#func _process(delta):
	#if is_colliding():
		#var detected = get_collider()
		#if detected is enemy:
			#pass
#
#func _input(event):
	#if Input.is_action_just_pressed("Melee attack"):
		##melee_anim.show()
		#print("melee")
		#melee_anim.play("attack")
		#meleeAttack()
	#else:
		#pass
#
#
#func meleeAttack():
	##melee_anim.play("attack")
	#if melee_raycast.is_colliding() and melee_raycast.get_collider().has_method("_on_ray_cast_3d_melee"):
		#emit_signal("melee", melee_damage)
		#melee_raycast.get_collider().kill()
