extends CharacterBody2D

@export var SPEED = 30
@export var HP = 80
var last_movement = Vector2.UP

# HUD
@onready var level_label = $HUD/Control/LevelLabel
@onready var exp_bar = $HUD/Control/Exp

var experience = 0 
var exp_level:
	get:
		return exp_level 
	set(value):
		exp_level = value
		level_label.text = "Level: " + str(exp_level) 
		
var collected_exp = 0

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
var weapon3_ammo = 2
var weapon3_level = 1

# Level up 
@onready var level_up_panel = get_node("%LevelUpPanel")
@onready var upgrades = get_node("%Upgrades")
@onready var upgrade_button = preload("res://Scenes/upgrade_button.tscn")

# Enemy 
var enemy_close = []

func _ready():
	attack()
	exp_level = 1

func _physics_process(delta):
	movement(delta)
	update_exp_bar()

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
	var get_weapon3_total = $Attack/Weapon3Base.get_child_count()
	var count_spawns = weapon3_ammo - get_weapon3_total
	while count_spawns>0:
		var weapon3_spawn = weapon3.instantiate()
		weapon3_spawn.global_position = global_position
		$Attack/Weapon3Base.add_child(weapon3_spawn)
		count_spawns -= 1 

func _on_grab_area_area_entered(area):
	if area is Gem:
		area.target = self 

func _on_collect_area_area_entered(area):
	if area is Gem:
		var gem_experience = area.collect()
		calculate_experience(gem_experience)

func calculate_experience(gem_exp):
	var exp_required = calculate_experience_cap()
	collected_exp += gem_exp
	if experience + collected_exp > exp_required:
		collected_exp -= exp_required - experience 
		exp_level += 1
		experience = 0
		exp_required = calculate_experience_cap()
		print("Level: ", exp_level)
		level_up()
		calculate_experience(0)
	else:
		experience += collected_exp
		collected_exp = 0 
	
func calculate_experience_cap():
	var experience_cap = exp_level
	if exp_level<20:
		experience_cap = exp_level*5
	elif exp_level<40:
		experience_cap = 95 + (exp_level - 19) * 8
	else:
		experience_cap = 255 + (exp_level - 39) * 12
	return experience_cap

func update_exp_bar():
	exp_bar.max_value = calculate_experience_cap()
	exp_bar.value = experience

func level_up():
	level_up_panel.visible = true
	var options = 0 
	var max_options = 3
	while options<max_options:
		var option_instance = upgrade_button.instantiate()
		upgrades.add_child(option_instance)
		options += 1
	get_tree().paused = true

func upgrade_character(upgrade):
	var option_children = upgrades.get_children()
	for i in option_children:
		i.queue_free()
	level_up_panel.visible = false
	get_tree().paused = false
