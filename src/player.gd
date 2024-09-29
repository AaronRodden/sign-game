extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var lookvector = Vector2.ZERO
var pickaxe_position = Vector2.ZERO

var player_id

var tilemap
var cell
var tile_id

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
		
	cell = tilemap.local_to_map(pickaxe_position)
	tile_id = tilemap.get_cell_tile_data(0, cell)
	
	if Input.is_action_just_pressed(player_id + "_R1"):
		tilemap.erase_cell(0, cell)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed(player_id + "_square") and is_on_floor():
		velocity.y = JUMP_VELOCITY 

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis(player_id + "_left", player_id + "_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
