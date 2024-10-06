extends TileMap

const DIRT_BLOCK_ATLAS_COORDS = Vector2i(0,0)
const BREAKING_BLOCK_ATLAS_COORDS = Vector2i(16, 9)

signal collect_bronze
signal collect_gold

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
## TODO: Right now this just adds dirt
func tile_add(cell):
	self.set_cell(0, cell, 0, DIRT_BLOCK_ATLAS_COORDS)

func tile_hit(cell, tile_data):
	if tile_data == null:
		return
	var block_type = tile_data.get_custom_data("block_type")
	if block_type == "dirt":
		self.erase_cell(0, cell)
	elif block_type == "breaking_block":
		self.erase_cell(0, cell)
	elif block_type == "stone":
		self.set_cell(0, cell, 0, BREAKING_BLOCK_ATLAS_COORDS)
	elif block_type == "bronze":
		self.erase_cell(0, cell)
		collect_bronze.emit()
	elif block_type == "gold":
		self.erase_cell(0, cell)
		collect_gold.emit()
