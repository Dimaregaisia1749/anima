extends CharacterBody2D

@export var bullet: PackedScene
@export var attack_range = 500
var speed = 100 * 100
var idle_moving_time = 1.5
var health = 3
var attack_moving_time = 3
var can_choot = true
var bullet_speed = 20
var attack_delay = 1
var time_since_attack = 0
var time_to_change_vel = 0.5
var time_since_change_vel = 0
var range_to_player = 200
var move_degree = Vector2(0, 0)
@onready var player = get_parent().get_node("Player")

func _ready():
	pass	
	
func _process(delta):
	if player != null:
		time_since_attack += delta
		time_since_change_vel += delta
		
		look_at(player.position)
		var overlapping_bodies = $AtackRange.get_overlapping_bodies()
		if time_since_attack >= attack_delay and player in overlapping_bodies:
			await shoot()
			time_since_attack = 0
		
		if time_since_change_vel >= time_to_change_vel:
			determine_degree()
			time_since_change_vel = 0
		velocity = move_degree * speed * delta
		move_and_slide()

func determine_degree():
	var overlapping_bodies = $RangeArea.get_overlapping_bodies()
	move_degree = atan2(player.position.y - global_position.y, player.position.x - global_position.x)
	move_degree = Vector2(1, 0).rotated(move_degree + randf_range(-0.5, 0.5))
	if player in overlapping_bodies:
		move_degree *= -1

func shoot():
	var bullet_instance = bullet.instantiate()
	var enemy_position = get_global_position()
	var player_position = player.get_meta("Position")
	var degrees = atan2(player_position.y - enemy_position.y, player_position.x - enemy_position.x)
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	var vel = Vector2(bullet_speed, 0).rotated(degrees) * bullet_speed
	bullet_instance.velocity = vel
	get_tree().get_root().add_child(bullet_instance)

func death():
	queue_free()

func _on_area_2d_area_entered(area):
	if is_instance_valid(player):
		if area.name == "PlayerBulletArea2D":
			area.get_parent().queue_free()
			health -= 0.5
		if health <= 0:
			death()
