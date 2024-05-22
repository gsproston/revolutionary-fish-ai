extends Node2D

const LENGTH = 5
const TOP_SPEED = 100
const SWIM_COOLDOWN_SECONDS = 2
const TARGET_ROTATION_TOLERANCE = 0.01
const TURN_SPEED = 5

var speed = 0
var swim_timer = 0
var target_position = Vector2.ZERO
var target_rotation = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# swim if we're facing the right direction
	if (abs(rotation - target_rotation) < TARGET_ROTATION_TOLERANCE):
		swim_timer += delta
		position += Vector2.from_angle(rotation) * speed * delta
		speed *= 0.99
	
	while (target_rotation < rotation - PI):
		target_rotation += TAU
	while (target_rotation > rotation + PI):
		target_rotation += TAU
	
	# rotate towards the target
	if (rotation > target_rotation):
		rotation = max(rotation - TURN_SPEED * delta, target_rotation)
	elif (rotation < target_rotation):
		rotation = min(rotation + TURN_SPEED * delta, target_rotation)
	
	if (swim_timer > SWIM_COOLDOWN_SECONDS):
		target_rotation = position.angle_to_point(target_position)
		swim_timer = 0
		# move towards the bubble
		var direction = target_position - position
		speed = TOP_SPEED
	
	
func _draw():
	draw_line(-Vector2(LENGTH, 0), Vector2(LENGTH, 0), Color.CORAL, 1.0, true);
	
	
func set_target_position(new_target_position: Vector2):
	target_position = new_target_position
