extends CharacterBody2D

@onready var weapon: Area2D = get_node("Weapon")
@onready var weapon_sprite = get_node("Weapon/AnimatedSprite2D")
@onready var weapon_collision_shape = get_node("Weapon/CollisionShape2D")
@onready var player = get_parent().get_node("Player")
@onready var original_collision_layer = weapon.collision_layer
@onready var original_collision_mask = weapon.collision_mask
@export var attack_range = 400
@onready var animation = get_node("Weapon/AnimationPlayer")
@onready var singletone_node = get_tree().get_root().get_child(0)
var death_score: int = 100
var damage: int = 1
var health = 5
var idle_moving_time = 0.7
var attack_delay = 1.5
var hitbox_cooldown = 0.5
var time_since_attack = 0
var speed = 80 * 100
var rand_degree
var attack_prepare_delay = 0.5
var is_degree_determined = false
var is_attacking = false


func _ready():
	disableCollider()
	weapon.set_process(false)
	weapon_sprite.visible = false
	rand_degree = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _process(delta):
	time_since_attack += delta
	if is_instance_valid(player):
		var player_pos = player.get_meta("Position")
		var overlapping_bodies = $AtackRange.get_overlapping_bodies()
		if time_since_attack >= attack_delay and player in overlapping_bodies and not is_attacking:
			await attack()
			time_since_attack = 0
	
		if not is_degree_determined:
			await determine_random_degree()
		
		if self.global_position.distance_to(player_pos) >= attack_range:
			await idle_moving(delta)	
		else:
			await attack_moving(delta)
		move_and_slide()
	
func attack():
	is_attacking = true
	var degrees = atan2(player.position.y - global_position.y, player.position.x - global_position.x)
	weapon.look_at(player.position)
	await get_tree().create_timer(attack_prepare_delay).timeout
	weapon_sprite.visible = true
	animation.play("attack")
	enableCollider()
	await get_tree().create_timer(hitbox_cooldown).timeout
	disableCollider()
	weapon_sprite.visible = false
	is_attacking = false

func disableCollider():
	original_collision_layer = weapon.collision_layer
	original_collision_mask = weapon.collision_mask
	weapon.collision_layer = 0
	weapon.collision_mask = 0

func enableCollider():
	weapon.collision_layer = original_collision_layer
	weapon.collision_mask = original_collision_mask

func idle_moving(delta):
	velocity = rand_degree * speed * delta

func determine_random_degree():
	is_degree_determined = true
	rand_degree = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	await get_tree().create_timer(idle_moving_time).timeout
	is_degree_determined = false
	
func attack_moving(delta):
	if player != null:
		var player_position = player.get_meta("Position")
		var degrees = atan2(player.position.y - global_position.y, player.position.x - global_position.x)
		velocity = Vector2(1, 0).rotated(degrees) * speed * delta

func death():
	singletone_node.score += death_score
	queue_free()

func _on_hitbox_area_entered(area):
	if is_instance_valid(player):
		if area.name == "Player":
			time_since_attack = 0
		if area.name == "PlayerBulletArea2D":
			area.get_parent().queue_free()
			health -= 0.5
		if health <= 0:
			death()
