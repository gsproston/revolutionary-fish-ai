extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_size = get_viewport().get_visible_rect().size
	var fish_start_position = Vector2(
		randi_range(0, viewport_size.x), 
		randi_range(0, viewport_size.y)
	)
	$Fish.position = fish_start_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Fish.set_target_position($FishPath.get_bubble_position())
