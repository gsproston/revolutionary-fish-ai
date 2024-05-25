extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# centre the fish path
	$FishPath.position = get_viewport().get_visible_rect().get_center()
	var viewport_size = get_viewport().get_visible_rect().size
	$Fish.position = Vector2(
		randi_range(0, viewport_size.x), 
		randi_range(0, viewport_size.y)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Fish.set_target_position($FishPath.get_bubble_position())
