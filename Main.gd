extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# centre the fish path
	$FishPath.position = get_viewport().get_visible_rect().get_center()
	# TODO random start position
	$Fish.position = Vector2(10, 10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Fish.set_target_position($FishPath.get_bubble_position())
