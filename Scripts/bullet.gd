extends Node3D

@onready var sprite = $Sprite3D
@onready var collision_shape = $CollisionShape3D


@export var speed = 4.0

func _ready():
	pass


func _process(delta):
	position += transform.basis * Vector3(0, 0, -speed) * delta
