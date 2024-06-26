extends Node2D


const BUBBLE_ANGLE_FACTOR = 1.0 / 10
const RAIDUS = 250

var bubble_angle = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_viewport().get_visible_rect().get_center()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bubble_angle += BUBBLE_ANGLE_FACTOR * delta
	while (bubble_angle > TAU):
		bubble_angle -= TAU
	$Bubble.position = Vector2(RAIDUS, 0).rotated(bubble_angle)


func _draw():
	draw_arc(Vector2.ZERO, RAIDUS, 0, TAU, 128, Color.LIGHT_SEA_GREEN, 0.5, true)
	
	
func get_bubble() -> Node2D:
	return $Bubble
