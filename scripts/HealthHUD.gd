extends CanvasLayer
@onready var player = get_parent()
@onready var singletone_node = get_tree().get_root().get_child(0)
var health = 6

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ScoreText.text = 'score: ' + str(singletone_node.score)
	if health > player.health:
		health = player.health
		var heart_node = get_node("ItemList/MarginContainer/HBoxContainer/Heart" + str(health + 1))
		var tween = create_tween()
		tween.tween_property(heart_node, "rotation_degrees", 90, 0.5).set_trans(Tween.TRANS_BACK)
		tween.tween_property(heart_node, "position", heart_node.position + Vector2.DOWN * 200, 1).set_trans(Tween.TRANS_BACK)
