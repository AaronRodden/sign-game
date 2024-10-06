extends Control

var bronze_count = 0
var gold_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_bronze_count():
	bronze_count += 1
	$"Bronze Label".text = "Bronze: " + str(bronze_count)
	
func update_gold_count():
	gold_count += 1
	$"Gold Label".text = "Gold: " + str(gold_count)
