extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var lookvector = Vector2.ZERO
var pickaxe_position = Vector2.ZERO

# players velocity 
#var velocity = Vector2()
# forces acted on the player
@export var moveSpeed = 700
@export var gravity = 20
@export var jumpForce = 600
# variables to increase the min jumpheight and acceleration/decceleration
@export var minJump = 300
@export var moveAcceleration = 0.05
@export var moveDecceleration = 0.05
# Buffering stuff
var canJump = false
@export var coyoteTime = 0.1
@export var jumpBuffer = 0.2
var hasPressedJump = false

var player_id

var tilemap
var cell
var tile_data

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func init(player_str: String):
	player_id = player_str

func _ready():
	tilemap = get_parent().get_node("World")
	
func _process(delta):
	# Movemenet / jumping functions
	_checksIfPlayerOnFloor()
	_checkPlayerMovements()
	_checkJump()
	
	# TODO: Don't love how this is done, weird mix of pixel based vs tile coordinate based
	# Use map to local?
	if Input.is_action_pressed(player_id + "_right"):
		$Pointer.position = Vector2(50,0)
		pickaxe_position = position + Vector2(50,0)
	if Input.is_action_pressed(player_id + "_left"):
		$Pointer.position = Vector2(-50,0)
		pickaxe_position = position + Vector2(-50,0)
	if Input.is_action_pressed(player_id + "_up"):
		$Pointer.position = Vector2(0,-50)
		pickaxe_position = position + Vector2(0,-50)
	if Input.is_action_pressed(player_id + "_down"):
		$Pointer.position = Vector2(0,50)
		pickaxe_position = position + Vector2(0,50)
		
	if Input.is_action_pressed(player_id + "_right") and Input.is_action_pressed(player_id + "_down"):
		$Pointer.position = Vector2(50,50)
		pickaxe_position = position + Vector2(50,50)
	if Input.is_action_pressed(player_id + "_left") and Input.is_action_pressed(player_id + "_down"):
		$Pointer.position = Vector2(-50,50)
		pickaxe_position = position + Vector2(-50,50)
	if Input.is_action_pressed(player_id + "_left") and Input.is_action_pressed(player_id + "_up"):
		$Pointer.position = Vector2(-50,-50)
		pickaxe_position = position + Vector2(-50,-50)
	if Input.is_action_pressed(player_id + "_right") and Input.is_action_pressed(player_id + "_up"):
		$Pointer.position = Vector2(50,-50)
		pickaxe_position = position + Vector2(50,-50)
		
	cell = tilemap.local_to_map(pickaxe_position)
	tile_data = tilemap.get_cell_tile_data(0, cell)
	
	## Debug stuff - remember this prints the block you are POINTING at 
	#if tile_data:
		#print(tile_data)
		#var block_type = tile_data.get_custom_data("block_type")
		#if block_type:
			#print(block_type)
		
	## TODO: Players interact with world -> world map manager does stuff
	
	## TODO: Right now this just adds dirt
	if Input.is_action_just_pressed(player_id + "_triangle"):
		tilemap.tile_add(cell)
	
	if Input.is_action_just_pressed(player_id + "_R1"):
		tilemap.tile_hit(cell, tile_data)

func _physics_process(delta):
	velocity.y += gravity
	
	move_and_slide()
	
	### Default movement / jump code 
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed(player_id + "_square") and is_on_floor():
		#velocity.y = JUMP_VELOCITY 
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#
	### TODO: Implement hold button to hold position
	##if not Input.is_action_pressed(player_id + "_cross"):
	#var direction = Input.get_axis(player_id + "_left", player_id + "_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
	
	
func _checksIfPlayerOnFloor():
	if is_on_floor():
		canJump = true
	else:
		if canJump == true:
			await get_tree().create_timer(coyoteTime).timeout
			canJump = false
			
func _checkPlayerMovements():
	var xDir = Input.get_axis(player_id + "_left", player_id + "_right")
	if xDir != 0:
		velocity.x = lerp(velocity.x, xDir * moveSpeed, moveAcceleration)
	elif xDir == 0 and !is_on_floor():
		velocity.x = lerp(velocity.x, 0.0, moveDecceleration/2)
	else:
		velocity.x = lerp(velocity.x, 0.0, moveDecceleration)
		
func _checkJump():
	# checks if the player has pressed jump
	if Input.is_action_just_pressed(player_id + "_square") and hasPressedJump == false:
		hasPressedJump = true
		await get_tree().create_timer(jumpBuffer).timeout
		hasPressedJump = false
	
	# if is on ground and has pressed jump within jump buffer, jump
	if hasPressedJump and canJump:
		velocity.y = -jumpForce
		canJump = false
	
	# jump variatiom
	if Input.is_action_just_released(player_id + "_square") and velocity.y < -minJump:
		velocity.y = -minJump
