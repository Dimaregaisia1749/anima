extends Node2D

@export var main_scene: PackedScene
@export var boss_scene: PackedScene
var death_count = 0
var main_scene_instance
var boss_scene_instance

func _ready():
	main_scene_instance = main_scene.instantiate()
	boss_scene_instance = boss_scene.instantiate()
	
	to_main()

func _process(delta):
	pass

func to_main():
	if has_node('BossRoom'):
		$BossRoom.queue_free()
	call_deferred('add_child', main_scene_instance)
	main_scene_instance = main_scene.instantiate()

func to_boss_room():
	if has_node('Main'):
		$Main.queue_free()
	call_deferred('add_child', boss_scene_instance)
	boss_scene_instance = boss_scene.instantiate()
