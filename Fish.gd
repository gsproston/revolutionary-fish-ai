extends Node2D

enum FISH_STATE {
	IDLE, 
	LOST
}

const BUBBLE_RADIUS_TARGET_CHANGE = 0.1
const BUBBLE_RADIUS_TARGET_MIN = 0.25
const BUBBLE_RADIUS_TARGET_MAX = 0.95
const LENGTH = 5
const LOST_DISTANCE = 50
const SWIM_SPEED_MIN = 20.0
const SWIM_SPEED_MAX = 80.0
const SWIM_SPEED_DECREASE_RATE = 0.95
const SWIM_COOLDOWN_SECONDS = 1.2
const TARGET_ROTATION_TOLERANCE = 0.01
const TURN_SPEED = 5.0
const WIGGLE_ANGLE_MAX = PI / 32.0
const WIGGLE_SPEED = 0.05

var actual_rotation = 0.0
var bubble: Node2D = null
var bubble_radius_target = 0.5
var state = FISH_STATE.IDLE
var swim_speed = SWIM_SPEED_MIN
var swim_timer = SWIM_COOLDOWN_SECONDS
var target_rotation = 0.0
var wiggle_angle = 0.0
var wiggle_right = true


# Called when the node enters the scene tree for the first time.
func _ready():
	# random position
	var viewport_size = get_viewport().get_visible_rect().size
	var fish_start_position = Vector2(
		randi_range(0, viewport_size.x), 
		randi_range(0, viewport_size.y)
	)
	position = fish_start_position
	# random rotation
	rotation = randf_range(0, TAU)
	actual_rotation = rotation
	target_rotation = rotation
	# random bubble radius target
	bubble_radius_target = randf_range(BUBBLE_RADIUS_TARGET_MIN, BUBBLE_RADIUS_TARGET_MAX)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_wiggle_angle(delta)
	_update_state()
	
	# swim if we're facing the right direction
	if (abs(angle_difference(actual_rotation, target_rotation)) < TARGET_ROTATION_TOLERANCE):
		swim_timer += delta
		position += Vector2.from_angle(actual_rotation) * swim_speed * delta
		var next_speed = swim_speed - swim_speed * SWIM_SPEED_DECREASE_RATE * delta
		swim_speed = max(SWIM_SPEED_MIN, next_speed);
	else:
		_rotate_to_target(delta)
	
	if (swim_timer > SWIM_COOLDOWN_SECONDS && state == FISH_STATE.LOST):
		_update_bubble_radius_target()
		_calculate_new_target_rotation()
		# start schwimmin
		swim_timer = 0
		swim_speed = SWIM_SPEED_MAX
	
	
func _draw():
	draw_line(-Vector2(LENGTH, 0), Vector2(LENGTH, 0), Color.CORAL, 1.0, true);
	
	
func _calculate_new_target_rotation():
	var bubble_position = _get_bubble_position()
	var distance_to_bubble = position.distance_to(bubble_position)
	var angle = bubble_position.angle_to_point(position) + acos(LOST_DISTANCE / distance_to_bubble)
	var target_position_a = bubble_position + Vector2.from_angle(angle) * LOST_DISTANCE * bubble_radius_target
	var target_position_b = bubble_position - Vector2.from_angle(angle) * LOST_DISTANCE * bubble_radius_target
	var angle_difference_a = angle_difference(actual_rotation, position.angle_to_point(target_position_a))
	var angle_difference_b = angle_difference(actual_rotation, position.angle_to_point(target_position_b))
	if (
		(angle_difference_a < 0 && angle_difference_b < 0) ||
		(angle_difference_a > 0 && angle_difference_b > 0) ||
		abs(angle_difference_a) > PI / 2.0
	):
		if (abs(angle_difference_a) < abs(angle_difference_b)):
			target_rotation = position.angle_to_point(target_position_a)
		else:
			target_rotation = position.angle_to_point(target_position_b)


func _get_bubble_position() -> Vector2:
	if (bubble == null):
		return Vector2.ZERO
	else:
		return bubble.global_position


func _rotate_to_target(delta: float):
	var angle_to_target = angle_difference(actual_rotation, target_rotation)	
	var angle_change = TURN_SPEED * delta
	# rotate towards the target
	if (abs(angle_to_target) < angle_change):
		actual_rotation = target_rotation
	elif (angle_to_target > 0):
		actual_rotation += angle_change
	elif (angle_to_target < 0):
		actual_rotation -= angle_change


func _update_bubble_radius_target():
	var new_bubble_radius_change = randf_range(
		-BUBBLE_RADIUS_TARGET_CHANGE, 
		BUBBLE_RADIUS_TARGET_CHANGE
	)
	bubble_radius_target = clampf(
		bubble_radius_target + new_bubble_radius_change, 
		BUBBLE_RADIUS_TARGET_MIN, 
		BUBBLE_RADIUS_TARGET_MAX
	)
	
	
func _update_state():
	if (position.distance_to(_get_bubble_position()) > LOST_DISTANCE):
		if (state != FISH_STATE.LOST):
			state = FISH_STATE.LOST
			swim_timer = 0
	else:
		state = FISH_STATE.IDLE
		
	
func _update_wiggle_angle(delta: float):
	if (wiggle_angle < -WIGGLE_ANGLE_MAX):
		wiggle_right = true
	elif (wiggle_angle > WIGGLE_ANGLE_MAX):
		wiggle_right = false
	if (wiggle_right): 
		wiggle_angle += WIGGLE_SPEED * swim_speed * delta
	else:
		wiggle_angle -= WIGGLE_SPEED * swim_speed * delta
	rotation = actual_rotation + wiggle_angle
	
	
func set_target(new_target: Node2D):
	bubble = new_target
