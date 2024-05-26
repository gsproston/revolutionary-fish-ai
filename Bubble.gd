extends Node2D


const RADIUS = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_arc(Vector2.ZERO, RADIUS, 0, TAU, 128, Color.LIGHT_SEA_GREEN, 0.5, true)

