extends CenterContainer

@export var DOT_radius : float = 1.0
@export var DOT_clor : Color = Color.WHITE

func _ready():
	queue_redraw()


func _process(delta):
	pass


func _draw():
	
	draw_circle(Vector2(0,0), DOT_radius,DOT_clor)
