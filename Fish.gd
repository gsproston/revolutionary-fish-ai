extends Node2D

enum FISH_STATE {
	IDLE, 
	LOST
}

const BUBBLE_RADIUS_TARGET_CHANGE = 0.1
const LENGTH = 5
const LOST_DISTANCE = 50
const SWIM_SPEED_MIN = 10.0
const SWIM_SPEED_MAX = 100.0
const SWIM_SPEED_DECREASE_RATE = 0.9
const SWIM_COOLDOWN_SECONDS = 2.0
const TARGET_ROTATION_TOLERANCE = 0.01
const TURN_SPEED = 5.0

var bubble_position = Vector2.ZERO
var bubble_radius_target = 0.5
var speed = SWIM_SPEED_MIN
var state = FISH_STATE.IDLE
var swim_timer = SWIM_COOLDOWN_SECONDS
var target_rotation = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# update the state
	if (position.distance_to(bubble_position) > LOST_DISTANCE):
		if (state != FISH_STATE.LOST):
			state = FISH_STATE.LOST
			swim_timer = 0
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
		update_bubble_radius_target()
		# get new target rotation
		var distance_to_bubble = position.distance_to(bubble_position)
		var angle = acos(LOST_DISTANCE / distance_to_bubble)
		var angle_a = bubble_position.angle_to_point(position) + angle
		var angle_b = bubble_position.angle_to_point(position) - angle
		var target_position_a = bubble_position + Vector2.from_angle(angle_a) * LOST_DISTANCE * bubble_radius_target
		var target_position_b = bubble_position + Vector2.from_angle(angle_b) * LOST_DISTANCE * bubble_radius_target
		var angle_difference_a = angle_difference(rotation, position.angle_to_point(target_position_a))
		var angle_difference_b = angle_difference(rotation, position.angle_to_point(target_position_b))
		if (
			(angle_difference_a < 0 && angle_difference_b < 0) ||
			(angle_difference_a > 0 && angle_difference_b > 0)
		):
			if (abs(angle_difference_a) < abs(angle_difference_b)):
				target_rotation = position.angle_to_point(target_position_a)
			else:
				target_rotation = position.angle_to_point(target_position_b)
		
		# start schwimmin
		swim_timer = 0
		speed = SWIM_SPEED_MAX
	
	
func _draw():
	draw_line(-Vector2(LENGTH, 0), Vector2(LENGTH, 0), Color.CORAL, 1.0, true);
	
	
func _rotate_to_target(delta: float):
	var angle_to_target = angle_difference(rotation, target_rotation)	
	var angle_change = TURN_SPEED * delta
	# rotate towards the target
	if (angle_to_target < angle_change):
		rotation = target_rotation
	if (angle_to_target > 0):
		rotation += angle_change
	elif (angle_to_target < 0):
		rotation -= angle_change
		
		
func update_bubble_radius_target():
	var new_bubble_radius_change = randf_range(-BUBBLE_RADIUS_TARGET_CHANGE, BUBBLE_RADIUS_TARGET_CHANGE)
	bubble_radius_target = clampf(bubble_radius_target + new_bubble_radius_change, 0.0, 1.0)
	
	
func set_target_position(new_target_position: Vector2):
	bubble_position = new_target_position
