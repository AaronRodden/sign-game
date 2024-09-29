@tool
extends Camera2D

@export var screenSize = Vector2(1152, 648)
@export var player : CharacterBody2D
var startOffsetPosition : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	startOffsetPosition = global_position

func _physics_process(_delta):
	pass
	#UpdateCamera()

# TODO: Implement zooming in/out camera
func UpdateCamera():
	var currentCell = ((player.global_position - startOffsetPosition) / screenSize).floor()
	global_position = startOffsetPosition + (currentCell * screenSize)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
