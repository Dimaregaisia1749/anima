extends CharacterBody2D

@onready var weapon: Area2D = get_node("Weapon")
@onready var test = get_node("Weapon/CollisionShape2D/Sprite2D")
@onready var player = get_parent().get_node("Player")
var damage: int = 1
var damage_delay = 1.5
var hitbox_cooldown = 0.2
var time_since_attack = 0

func _ready():
	weapon.set_process(false)
	test.visible = false

func _process(delta):
	time_since_attack += delta
	if time_since_attack >= damage_delay:
		time_since_attack = 0
		await attack(damage)
	
func attack(damage):
	var player_position = player.get_meta("Position")
	var degrees = atan2(player_position.y - global_position.y, player_position.x - global_position.x)
	weapon.look_at(player_position)
	test.look_at(player_position)
	test.visible = true
	weapon.set_process(true)
	await get_tree().create_timer(hitbox_cooldown).timeout
	test.visible = false
	weapon.set_process(false)
