extends Node2D

enum FISH_STATE {
	IDLE, 
	LOST
}

const LENGTH = 5
const LOST_DISTANCE = 50
const SWIM_SPEED_MIN = 10.0
const SWIM_SPEED_MAX = 100.0
const SWIM_SPEED_DECREASE_RATE = 0.9
const SWIM_COOLDOWN_SECONDS = 2.0
const TARGET_ROTATION_TOLERANCE = 0.01
const TURN_SPEED = 5.0

var speed = SWIM_SPEED_MIN
var state = FISH_STATE.IDLE
var swim_timer = SWIM_COOLDOWN_SECONDS
var target_position = Vector2.ZERO
var target_rotation = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# update the state
	if (position.distance_to(target_position) > LOST_DISTANCE):
		state = FISH_STATE.LOST
	else:
		state = FISH_STATE.IDLE
	
	# swim if we're facing the right direction
	if (abs(rotation - target_rotation) < TARGET_ROTATION_TOLERANCE):
		swim_timer += delta
		position += Vector2.from_angle(rotation) * speed * delta
		var next_speed = speed - speed * SWIM_SPEED_DECREASE_RATE * delta
		speed = max(SWIM_SPEED_MIN, next_speed);
	else:
		_rotate_to_target(delta)
	
	if (swim_timer > SWIM_COOLDOWN_SECONDS && state == FISH_STATE.LOST):
		target_rotation = position.angle_to_point(target_position)
		swim_timer = 0
		# move towards the bubble
		var direction = target_position - position
		speed = SWIM_SPEED_MAX
	
	
func _draw():
	draw_line(-Vector2(LENGTH, 0), Vector2(LENGTH, 0), Color.CORAL, 1.0, true);
	
	
func _rotate_to_target(delta: float):
	# standardise target
	while (target_rotation < rotation - PI):
		target_rotation += TAU
	while (target_rotation > rotation + PI):
		target_rotation += TAU
	
	# rotate towards the target
	if (rotation > target_rotation):
		rotation = max(rotation - TURN_SPEED * delta, target_rotation)
	elif (rotation < target_rotation):
		rotation = min(rotation + TURN_SPEED * delta, target_rotation)
	
	
func set_target_position(new_target_position: Vector2):
	target_position = new_target_position
