extends TileMap

func generate_map():
	for x in range(10):
		for y in range(10):
			# Ваш код генерации тайлов здесь
			var tile_id = randi() % get_tileset_tile_count()
			set_cell(x, y, tile_id)

func _ready():
	generate_map()
