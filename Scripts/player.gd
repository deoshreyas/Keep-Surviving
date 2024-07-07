extends CharacterBody2D

@export var SPEED = 30
@export var HP = 80
var last_movement = Vector2.UP

# Attacks
var weapon1 = preload("res://Scenes/weapon_1.tscn")
var weapon2 = preload("res://Scenes/weapon_2.tscn")
var weapon3 = preload("res://Scenes/weapon_3.tscn")

# Attack Nodes 
@onready var weapon1_timer = get_node("%Weapon1Timer")
@onready var weapon1_attack_timer = get_node("%Weapon1AttackTimer")
@onready var weapon2_timer = get_node("%Weapon2Timer")
@onready var weapon2_attack_timer = get_node("%Weapon2AttackTimer")

# Weapon 1 
var weapon1_ammo = 0 
var weapon1_base_ammo = 1
var weapon1_attack_speed = 1.5
var weapon1_level = 0

# Weapon 2
var weapon2_ammo = 0 
var weapon2_base_ammo = 1
var weapon2_attack_speed = 3
var weapon2_level = 0

# Weapon 3 
var weapon3_ammo = 1
var weapon3_level = 1

# Enemy 
var enemy_close = []

func _ready():
	attack()

func _physics_process(delta):
	movement(delta)

func _on_hurtbox_hurt(damage, _angle, _knockback):
	HP -= damage
	print(HP)

func movement(delta):
	var input_axis_x = Input.get_axis("btn_left", "btn_right")
	var input_axis_y = Input.get_axis("btn_up", "btn_down")
	velocity = SPEED * Vector2(input_axis_x, input_axis_y).normalized()
	var mov = Vector2(input_axis_x, input_axis_y)
	if mov!=Vector2.ZERO:
		last_movement = mov
	move_and_collide(velocity * delta)
	
func attack():
	if weapon1_level>0:
		weapon1_timer.wait_time = weapon1_attack_speed
		if weapon1_timer.is_stopped():
			weapon1_timer.start()
	if weapon2_level>0:
		weapon2_timer.wait_time = weapon2_attack_speed
		if weapon2_timer.is_stopped():
			weapon2_timer.start()
	if weapon3_level>0:
		spawn_weapon3()

func _on_weapon_1_timer_timeout():
	weapon1_ammo += weapon1_base_ammo
	weapon1_attack_timer.start()
	
func _on_weapon_1_attack_timer_timeout():
	if weapon1_ammo>0:
		var weapon1_attack = weapon1.instantiate()
		weapon1_attack.position = position 
		weapon1_attack.target = get_random_target()
		weapon1_attack.level = weapon1_level
		add_child(weapon1_attack)
		weapon1_ammo -= 1
		if weapon1_ammo > 0:
			weapon1_attack_timer.start()
		else:
			weapon1_attack_timer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)

func _on_weapon_2_timer_timeout():
	weapon2_ammo += weapon2_base_ammo
	weapon2_attack_timer.start()

func _on_weapon_2_attack_timer_timeout():
	if weapon2_ammo>0:
		var weapon2_attack = weapon2.instantiate()
		weapon2_attack.position = position 
		weapon2_attack.last_movement = last_movement
		weapon2_attack.level = weapon2_level
		add_child(weapon2_attack)
		weapon2_ammo -= 1
		if weapon2_ammo > 0:
			weapon2_attack_timer.start()
		else:
			weapon2_attack_timer.stop()

func spawn_weapon3():
	var get_weapon3_total = weapon3.get_child_count()
	var count_spawns = weapon3_ammo - get_weapon3_total
	while count_spawns>0:
		var weapon3_spawn = weapon3.instantiate()
		weapon3_spawn.global_position = global_position
		$Attack/Weapon3Base.add_child(weapon3_spawn)
		count_spawns -= 1 
