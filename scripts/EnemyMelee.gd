extends CharacterBody2D

@onready var weapon: Area2D = get_node("Weapon")
@onready var test = get_node("Weapon/CollisionShape2D/Sprite2D")
@onready var player = get_parent().get_node("Player")
@export var attack_range = 1000
var damage: int = 1
var idle_moving_time = 1.5
var attack_moving_time = 3
var damage_delay = 1.5
var hitbox_cooldown = 0.2
var time_since_attack = 0 #c================3

func _ready():
	weapon.set_process(false)
	test.visible = false

func _process(delta):	
	time_since_attack += delta
	if time_since_attack >= damage_delay:
		time_since_attack = 0
		await attack(damage)
	var pos = player.get_meta("Position")
	if (pos.x**2 + pos.y**2)**0.5 >= attack_range:
		await idle_moving()
	else:
		await attack_moving()
	
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

func idle_moving():
	var veloc = Vector2(randf_range(-1000, 1000), randf_range(-1000, 1000))
	velocity = veloc
	move_and_slide()
	await get_tree().create_timer(idle_moving_time).timeout
	velocity = Vector2(0, 0)
	
	
func attack_moving():
	var veloc = player.get_meta("Position")
	velocity = veloc
	move_and_slide()
	print("1")
	await get_tree().create_timer(attack_moving_time).timeout
	print("2")
	idle_moving()
