extends CharacterBody2D

@export var speed = 300
@export var bullet: PackedScene
@export var attack_range = 500
var idle_moving_time = 1.5
var health = 3
var attack_moving_time = 3
var can_choot = true
var bullet_speed = 20
var shoot_delay = 1
var time_since_shoot = 0
@onready var player = get_parent().get_node("Player")

func _ready():
	pass	
	
func _process(delta):
	pass

func _physics_process(delta):
	if is_instance_valid(player):
		time_since_shoot += delta
		if (time_since_shoot >= shoot_delay):
			time_since_shoot = 0
			await shoot()

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
			health -= 0.5
		if health <= 0:
			death()
