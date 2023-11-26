extends CharacterBody2D

@export var hp = 100
@export var bullet: PackedScene
@onready var player = get_parent().get_node("Player")
var can_choot = true
var bullet_speed = 100
var attack_delay = 3
var time_since_attack = 0

func _ready():
	pass

func _process(delta):
	if player != null:
		time_since_attack += delta
		print(player.position.x)
		look_at(player.position)

		if time_since_attack >= attack_delay:
			await shoot()
			time_since_attack = 0

func shoot():
	var bullet_instance = bullet.instantiate()
	var boss_position = get_global_position()
	var player_position = player.get_meta("Position")
	var degrees = atan2(player_position.y - boss_position.y, player_position.x - boss_position.x)
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	var vel = Vector2(bullet_speed, 0).rotated(degrees) * bullet_speed
	bullet_instance.velocity = vel
	get_tree().get_root().add_child(bullet_instance)

func _on_hitbox_area_entered(area):
	if is_instance_valid(player):
		if area.name == 'PlayerBulletArea2D':
			if hp > 0:
				area.get_parent().queue_free()
				hp -= 1
			else:
				death()
			
func death():
	queue_free()

