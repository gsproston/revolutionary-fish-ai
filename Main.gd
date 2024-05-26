extends Node


@export var fish_scene: PackedScene


const NUM_FISH = 16


# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_size = get_viewport().get_visible_rect().size
	for i in NUM_FISH:
		var fish = fish_scene.instantiate()
		# random start position
		var fish_start_position = Vector2(
			randi_range(0, viewport_size.x), 
			randi_range(0, viewport_size.y)
		)
		fish.position = fish_start_position
		fish.set_target($FishPath.get_bubble())
		add_child(fish)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
