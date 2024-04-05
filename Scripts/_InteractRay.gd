extends RayCast3D

@onready var prompt = $PromptFront

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
		if detected is HealthInteractable:
			prompt.text = detected.get_prompt()
		if detected is GunInteractable:
			prompt.text = detected.get_prompt()

#Interacting with "interact" button
func _input(event):
	if Input.is_action_just_pressed("interact"):
		interact_with_obj()


#Code that allows object interaction
func interact_with_obj():
	if is_colliding() and get_collider().has_method("interacted_by_player"):
		get_collider().interacted_by_player()
