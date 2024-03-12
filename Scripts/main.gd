extends Node3D

#@onready var pause_menu = $CanvasLayer/PauseMenu
#var paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if Input.is_action_just_pressed("Pause"):
		#pauseMenu()
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#
##Pause menu config
#func pauseMenu():
	#if paused:
		#pause_menu.hide()
		#Engine.time_scale = 1
		#get_tree().paused
	#else:
		#pause_menu.show()
		#Engine.time_scale = 0
	#
	#paused = not paused
