extends Node2D

@export var main_scene: PackedScene
@export var boss_scene: PackedScene
var scene = PackedScene.new()
var node_to_save: Node2D
var death_count = 0
var score: int = 0
var main_scene_instance
var boss_scene_instance

func _ready():
	main_scene_instance = main_scene.instantiate()
	boss_scene_instance = boss_scene.instantiate()
	
	to_main()
	
	#node_to_save = $Main

func _process(delta):
	pass

func to_main():
	if has_node('BossRoom'):
		$BossRoom.queue_free()
		#main_scene_instance = scene.instantiate()
	call_deferred('add_child', main_scene_instance)
	main_scene_instance = main_scene.instantiate()
	main_scene_instance.get_node("Player").position = Vector2(0, 0)

func to_boss_room():
	if has_node('Main'):
		#scene.pack(node_to_save)
		$Main.queue_free()
	call_deferred('add_child', boss_scene_instance)
	boss_scene_instance = boss_scene.instantiate()
