extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# centre the fish path
	$FishPath.position = get_viewport().get_visible_rect().get_center()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
