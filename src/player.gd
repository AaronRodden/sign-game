extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var lookvector = Vector2.ZERO
var pickaxe_position = Vector2.ZERO

var player_id

var tilemap
var cell
var tile_data

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func init(player_str: String):
	player_id = player_str

func _ready():
	tilemap = get_parent().get_node("World")
	
func _process(delta):
	
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
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed(player_id + "_square") and is_on_floor():
		velocity.y = JUMP_VELOCITY 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	## TODO: Implement hold button to hold position
	#if not Input.is_action_pressed(player_id + "_cross"):
	var direction = Input.get_axis(player_id + "_left", player_id + "_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
