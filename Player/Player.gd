extends KinematicBody

const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 5
const JUMP_SPEED = 9
const ACCEL = 20

var dir = Vector3()
var just_jumped = false

const DEACCEL = 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper

var MOUSE_SENSITIVITY = 0.05

var rng = RandomNumberGenerator.new()
var shake_intensity = 0
var has_office_key := false
var has_control_panel_key := false
var input_disabled = true

func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta):
	_handle_screen_shake()


func _physics_process(delta):
	if !input_disabled:
		process_input(delta)
	process_movement(delta)


func process_input(_delta):
	dir = Vector3()
	
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()
	
	if Input.is_action_pressed("player_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("player_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("player_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("player_right"):
		input_movement_vector.x += 1
		
	input_movement_vector = input_movement_vector.normalized()
	
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	
	if is_on_floor():
		if Input.is_action_just_pressed("player_jump"):
			vel.y = JUMP_SPEED
			just_jumped = true
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	
	vel.y += delta * GRAVITY
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	target *= MAX_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
		
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	
	# nightmare nightmare nightmare nightmare nightmare nightmare nightmare
	if !is_on_floor() or dir != Vector3(0,0,0) or just_jumped == true:
		vel = move_and_slide(vel, Vector3(0, 1, 0), true, 4, deg2rad(MAX_SLOPE_ANGLE))
		just_jumped = false
	


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and !input_disabled:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot


func _handle_screen_shake():
	if shake_intensity != 0:
		camera.set_v_offset(shake_intensity / 100.0 * rng.randf_range(-1, 1))
		camera.set_h_offset(shake_intensity / 100.0 * rng.randf_range(-1, 1))
	else:
		camera.set_v_offset(0)
		camera.set_h_offset(0)


func start_screen_shake(intensity = 1):
	shake_intensity = intensity


func stop_screen_shake():
	shake_intensity = 0
