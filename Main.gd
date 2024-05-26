extends Node


@export var fish_scene: PackedScene


const NUM_FISH = 16


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in NUM_FISH:
		var fish = fish_scene.instantiate()
		fish.set_target($FishPath.get_bubble())
		add_child(fish)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
