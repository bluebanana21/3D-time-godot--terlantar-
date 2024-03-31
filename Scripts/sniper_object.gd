extends GunInteractable


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
	#emit_signal("heal", heal_amount)
	emit_signal("damage", damage_num)
	emit_signal("weapons_name", weapon_name)
	#health += 1
	print("sniper has changed player weapon")
