#extends GunInteractable
#extends StaticBody3D
extends GunInteractable

#@export var prompt_message = "interact"
#@export var prompt_action = "interact"
#@export var heal_amount = 10
#@export var damage_num = 50
#
#signal heal(heal_amount)
#signal damage(damage_num)
#signal weapons_name(weapon_name)


func get_prompt():
	var key_name = ""
	for action in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.keycode)
	return prompt_message + "\n[" + prompt_action + "]"
	#return 


func interacted_by_player():
	#emit_signal("heal", heal_amount)
	emit_signal("damage", damage_num)
	emit_signal("weapons_name", weapon_name)
	#health += 1
	print("sniper has changed player weapon")
