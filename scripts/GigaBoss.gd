extends CharacterBody2D

@export var hp = 50
@export var bullet: PackedScene
@onready var animation = $AnimatedSprite2D
@onready var player = get_parent().get_node("Player")
@onready var singletone_node = get_tree().get_root().get_child(0)
@onready var this_scene = get_parent()
var upgrade_num = 1.2
var can_choot = true
var bullet_speed = 30
var attack_delay = 3
var time_since_attack = 0

func _ready():
	animation.play("idle")
	if singletone_node.death_count-1 > 0:
		hp = hp * (singletone_node.death_count-1) * upgrade_num
		bullet_speed = bullet_speed * (singletone_node.death_count-1) * upgrade_num
		attack_delay = attack_delay / ((singletone_node.death_count-1) * upgrade_num)
	print(hp, ' ', bullet_speed, ' ', attack_delay)

func _process(delta):
	if player != null:
		time_since_attack += delta

		look_at(player.position)

		if time_since_attack >= attack_delay:
			await shoot()
			time_since_attack = 0

func shoot():
	#rotation_degrees += 180
	#animation.play('shoot')
	var bullet_instance = bullet.instantiate()
	var boss_position = get_global_position()
	var player_position = player.get_meta("Position")
	var degrees = atan2(player_position.y - boss_position.y, player_position.x - boss_position.x)
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	var vel = Vector2(bullet_speed, 0).rotated(degrees) * bullet_speed
	bullet_instance.velocity = vel
	this_scene.call_deferred("add_child", bullet_instance)

func _on_hitbox_area_entered(area):
	if is_instance_valid(player):
		if area.name == 'PlayerBulletArea2D':
			if hp > 0:
				area.get_parent().queue_free()
				hp -= 1
			else:
				death()
				respawn()
			
func death():
	queue_free()

func respawn():
	print('yipeeeee')
	singletone_node.to_main()
