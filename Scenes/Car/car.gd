extends CharacterBody2D

var wheelBase = 60
var steerDirection = 0
var acceleration = Vector2.ZERO

@export var steerAngle = 15 # Fixed steering Angle because Keyboard Movement
@export var enginePower = 400
@export var brakePower = -200
@export var friction = -0.25
@export var drag = -0.001
@export var maxReverseSpeed = 300
@export var slideSpeed = 250
@export var tractionFast = 0.05
@export var tractionSlow = 0.7


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	steering_calc(delta)
	
	velocity += acceleration * delta
	move_and_slide()


func get_input():
	var turn = 0
	if Input.is_action_pressed("left_turn"):
		turn -= 1
	if Input.is_action_pressed("right_turn"):
		turn += 1
	steerDirection = turn * deg_to_rad(steerAngle)
	
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * enginePower
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * brakePower


func steering_calc(delta):
	var rearWheel = position - transform.x * wheelBase/2
	var frontWheel = position + transform.x * wheelBase/2
	
	rearWheel += velocity * delta
	frontWheel += velocity.rotated(steerDirection) * delta
	
	var newHeading = (frontWheel - rearWheel).normalized()
	var traction = tractionSlow
	if velocity.length() > slideSpeed:
		traction = tractionFast
	
	var d = newHeading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.lerp(newHeading * velocity.length(), traction)
	if d < 0:
		velocity = -newHeading * min(velocity.length(), maxReverseSpeed)
	rotation = newHeading.angle()


func apply_friction():
	if velocity.length() < 2:
		velocity = Vector2.ZERO
	
	var frictionForce = velocity * friction
	var dragForce = velocity * velocity.length() * drag
	acceleration += frictionForce + dragForce
