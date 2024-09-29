extends Node

var player_nodes = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_player("p1")
	spawn_player("p2")


func spawn_player(player: String):	
	if player == "p1":
		var player_scene = preload("res://src/blue_mage.tscn")
		var player_node = player_scene.instantiate()
		player_node.init(player)
		add_child(player_node)
		player_node.position = Vector2(66, 102)
		
	if player == "p2":
		var player_scene = preload("res://src/red_mage.tscn")
		var player_node = player_scene.instantiate()
		player_node.init(player)
		add_child(player_node)
		player_node.position = Vector2(566, 102)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
