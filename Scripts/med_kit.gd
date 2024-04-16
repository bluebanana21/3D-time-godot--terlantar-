class_name  HealthInteractable
extends StaticBody3D

@export var prompt_message = "interact"
@export var prompt_action = "interact"
@export var heal_amount = 10

signal heal(heal_amount)


#Shows text prompt when in range of Object
func get_prompt():
	var key_name = ""
	for action in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.keycode)
	return prompt_message + "\n[" + prompt_action + "]"
	#return 


#Calls when object is interacted by player
func interacted_by_player():
	emit_signal("heal", heal_amount)
	#health += 1
	print("Medkit has healed player")
