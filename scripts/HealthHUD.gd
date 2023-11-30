extends CanvasLayer
@onready var player = get_parent()
var health = 6
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health > player.health:
		health = player.health
		var heart_node = get_node("ItemList/MarginContainer/HBoxContainer/Heart" + str(health + 1))
		var tween = create_tween()
		tween.tween_property(heart_node, "rotation_degrees", 90, 0.5).set_trans(Tween.TRANS_BACK)
		tween.tween_property(heart_node, "position", heart_node.position + Vector2.DOWN * 200, 1).set_trans(Tween.TRANS_BACK)
		

