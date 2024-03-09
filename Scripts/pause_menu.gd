extends Control

@onready var main = $"../../"


#Resumes the game
func _on_resume_pressed():
	main.pauseMenu()
	#Recaptures the cursor after resuming
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


#Quits the game
func _on_quit_pressed():
	get_tree().quit()
