extends CharacterBody2D

@onready var weapon: Area2D = get_node("Weapon")
@onready var test = get_node("Weapon/CollisionShape2D/Sprite2D")
@onready var player = get_parent().get_node("Player")
@export var attack_range = 400
var damage: int = 1
var health = 5
var idle_moving_time = 0.7
var attack_delay = 1.5
var hitbox_cooldown = 0.5
var time_since_attack = 0
var speed = 10
var rand_degree
var is_degree_determined = false

func _ready():
	weapon.set_process(false)
	test.visible = false
	rand_degree = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _process(delta):	
	time_since_attack += delta
	if is_instance_valid(player):
		var player_pos = player.get_meta("Position")
		var overlapping_bodies = $AtackRange.get_overlapping_bodies()
		if time_since_attack >= attack_delay and player in overlapping_bodies:
			time_since_attack = 0
			await attack(damage)
	
		if not is_degree_determined:
			await determine_random_degree()
		
		if self.global_position.distance_to(player_pos) >= attack_range:
			await idle_moving()	
		else:
			await attack_moving()
		move_and_slide()
	
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
	velocity = rand_degree * speed * 10


func determine_random_degree():
	is_degree_determined = true
	rand_degree = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	await get_tree().create_timer(idle_moving_time).timeout
	is_degree_determined = false
	
func attack_moving():
	var player_position = player.get_meta("Position")
	var degrees = atan2(player_position.y - global_position.y, player_position.x - global_position.x)
	velocity = Vector2(speed, 0).rotated(degrees) * speed

func death():
	queue_free()

func _on_atack_range_area_entered(area):
	if is_instance_valid(player):
		time_since_attack = 0
		if area.name == "PlayerBulletArea2D":
			health -= 0.5
		if health <= 0:
			death()
