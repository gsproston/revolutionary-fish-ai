extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_arc(Vector2.ZERO, 250, 0, TAU, 128, Color.BLACK, 1.0, true)
