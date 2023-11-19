extends Node

@onready var room_templates = [preload("res://scenes/RoomsPrefabs/Prefab1.tscn"), preload("res://scenes/RoomsPrefabs/Prefab2.tscn")]
@onready var lava = preload("res://scenes/RoomsPrefabs/Lava.tscn")
var tilemap : TileMap


func _ready():
	generate_map()

func generate_map():
	var map=[]
	for x in range(12):
		map.append([])
		for y in range(12):
			map[x].append([])
			map[x][y]=0
			if x == 6 and y == 6:
				map[x][y]=1
	
	var rooms_remain=20
	while rooms_remain>0:
		var rand_x = randi_range(2, 10)
		var rand_y = randi_range(2, 10)
		if map[rand_x][rand_y] != 0:
			var adding_room_x_delta = randi_range(-1, 1)
			var adding_room_y_delta = randi_range(-1, 1)
			if abs(adding_room_x_delta) + abs(adding_room_y_delta) == 1 and map[rand_x + adding_room_x_delta][rand_y + adding_room_y_delta] == 0:
				var is_filled = randi() % map[rand_x][rand_y] + 1
				if is_filled != 0:
					map[rand_x + adding_room_x_delta][rand_y + adding_room_y_delta] = is_filled*2
					rooms_remain -= 1
	
	for x in range(12):
		for y in range(12):
			if map[x][y]!=0:
				place_random_room(x, y)
			else:
				place_lava(x, y)

func place_random_room(x, y):
	var template_index = randi() % len(room_templates)
	var room_instance = room_templates[template_index].instantiate()
	room_instance.z_index = -1 
	room_instance.position = Vector2(x * 1536 - 6 * 1536, y * 1536 - 6 * 1536)
	add_child(room_instance)
	
func place_lava(x, y):
	var room_instance = lava.instantiate()
	room_instance.z_index = -1 
	room_instance.position = Vector2(x * 1536 - 6 * 1536, y * 1536 - 6 * 1536)
	add_child(room_instance)
