extends Resource
class_name Weapons

@export var Weapon_name : String
@export var Prompt_action: String
@export var Prompt_message: String
@export var damage_num : int
@export var projectile : bool
#func get_prompt():
	#var key_name = ""
	#for action in InputMap.action_get_events(Prompt_action):
		#if action is InputEventKey:
			#key_name = OS.get_keycode_string(action.keycode)
	#return Prompt_message + "\n[" + Prompt_action + "]"
#func interacted_by_player(name):
	#current_weapon = name

#func get_prompt():
	#var key_name = ""
	#for action in InputMap.action_get_events(prompt_action):
		#if action is InputEventKey:
			#key_name = OS.get_keycode_string(action.keycode)
	#return prompt_message + "\n[" + prompt_action + "]"
