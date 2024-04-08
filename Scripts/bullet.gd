extends RigidBody3D

@onready var sprite = $Sprite3D
@onready var collision_shape = $CollisionShape3D
@onready var bullet = $"."

@export var projectile_damage = 20
@export var speed = 4.0


func _process(delta):
	position += transform.basis * Vector3(0, 0, -speed) * delta
	#pass


func _on_body_entered(body):
	if body.is_in_group("target") and body.has_method("Hit_Succesfull"):
		print("has collided")
		body.Hit_Succesfull(projectile_damage)
		queue_free()


func _on_timer_timeout():
	queue_free()
