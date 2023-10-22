extends CharacterBody2D

@export var speed = 300
@export var bullet: PackedScene
@onready var animation = $AnimatedSprite2D
var can_choot = true
var bullet_speed = 20
var shoot_delay = 0.2
var time_since_shoot = 0
var health = 3

func _ready():
	set_meta("Health", health)

func _process(delta):
	self.set_meta("Position", get_global_position())
	#print(health)

func _physics_process(delta):
	time_since_shoot += delta
	if Input.is_action_pressed("shoot") and (time_since_shoot >= shoot_delay):
		time_since_shoot = 0
		await shoot()
	
	var input_direction  = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction  * speed * delta * 100
	move_and_slide()
	
	if Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		animation.scale.x = 1
		animation.play("run")
	elif Input.is_action_pressed("left"):
		animation.scale.x = -1
		animation.play("run")
	else:
		animation.play("idle")
	
func shoot():
	var bullet_instance = bullet.instantiate()
	var player_position = global_position
	var mouse_position = get_global_mouse_position()
	var degrees = atan2(mouse_position.y - player_position.y, mouse_position.x - player_position.x)
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	var vel = Vector2(bullet_speed, 0).rotated(degrees) * bullet_speed
	bullet_instance.velocity = vel
	get_tree().get_root().add_child(bullet_instance)

func death():
	queue_free()
	

func _on_area_2d_area_entered(area):
	if is_instance_valid(area):
		if area.name == "EnemyBulletArea2D" or area.name == "Weapon":
			print(health)
			health -= 0.5
		if health <= 0:
			death()
