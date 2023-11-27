extends Node

func _ready():
	$Timer.start(3)

func _on_timer_timeout():
	queue_free()
