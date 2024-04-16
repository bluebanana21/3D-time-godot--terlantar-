extends StaticBody3D

@export var weapon_resource : Weapons

@onready var player = $"../../Player"


#Shows text qprompt when in range of Object
func get_prompt():
	var key_name = ""
	for action in InputMap.action_get_events(weapon_resource.Prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.keycode)
	return weapon_resource.Prompt_message + "\n[" + weapon_resource.Prompt_action + "]"
	return 


#Calls when object is interacted by player
func interacted_by_player():
	
	player._on_revolver_object_damage(weapon_resource.damage_num)
	player._on_revolver_object_weapons_name(weapon_resource.Weapon_name)
	print("Shotgun has changed player weapon")
