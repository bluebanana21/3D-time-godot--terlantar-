extends RayCast3D

@onready var prompt = $Prompt

# Called when the node enters the scene tree for the first time.
func _ready():
	add_exception(owner)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	prompt.text = ""
	if is_colliding():
		var detected = get_collider()
		#if Input.is_action_just_pressed("interact"):
			#print("youve interacted")
		if detected is interactable:
			prompt.text = detected.get_prompt()


func _input(event):
	if Input.is_action_just_pressed("interact"):
		interact_with_obj()


func interact_with_obj():
	if is_colliding() and get_collider().has_method("interacted_by_player"):
		get_collider().interacted_by_player()
