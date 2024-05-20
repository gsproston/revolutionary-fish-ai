extends Node2D

const LENGTH = 5;
const SPEED = 50;

var target_position: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (target_position != Vector2.ZERO):
		# rotate towards the bubble
		rotation = position.angle_to_point(target_position)
		print(rad_to_deg(rotation))
		# move towards the bubble
		var direction = target_position - position
		position += direction.normalized() * SPEED * delta
	
	
func _draw():
	draw_line(-Vector2(LENGTH, 0), Vector2(LENGTH, 0), Color.CORAL, 1.0, true);
	
	
func set_target_position(new_target_position: Vector2):
	target_position = new_target_position
