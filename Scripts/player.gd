extends CharacterBody2D

@export var SPEED = 30
@export var HP = 100
const MAXHP = 100
var last_movement = Vector2.UP

# HUD
@onready var level_label = $HUD/Control/LevelLabel
@onready var exp_bar = $HUD/Control/Exp
@onready var health_bar = $Healthbar

var experience = 0 
var exp_level:
	get:
		return exp_level 
	set(value):
		exp_level = value
		level_label.text = "Level: " + str(exp_level) 
		
var collected_exp = 0

# Attacks
var star = preload("res://Scenes/star.tscn")
var hand = preload("res://Scenes/hand.tscn")

# Attack Nodes 
@onready var star_timer = get_node("%StarTimer")
@onready var star_attack_timer = get_node("%StarAttackTimer")

# Weapon 1 
var star_ammo = 0 
var star_base_ammo = 1
var star_attack_speed = 1.5
var star_level = 0

# Weapon 3 
var hand_ammo = 2
var hand_level = 0

# Level up 
@onready var level_up_panel = get_node("%LevelUpPanel")
@onready var upgrades = get_node("%Upgrades")
@onready var upgrade_button = preload("res://Scenes/upgrade_button.tscn")

# Enemy 
var enemy_close = []

# Upgrades
var collected_upgrades = []
var upgrade_options = []
var armour = 0 
var speed = 0 
var spell_cooldown = 0 
var spell_size = 0
var additional_attacks = 0

func _ready():
	attack()
	exp_level = 1
	upgrade_character("STAR1")
	health_bar.value = MAXHP

func _physics_process(delta):
	movement(delta)
	update_exp_bar()
	update_health_bar()

func _on_hurtbox_hurt(damage, _angle, _knockback):
	HP -= clamp(damage-armour, 1, 999)
	if HP <= 0:
		player_death()

func movement(delta):
	var input_axis_x = Input.get_axis("btn_left", "btn_right")
	var input_axis_y = Input.get_axis("btn_up", "btn_down")
	velocity = SPEED * Vector2(input_axis_x, input_axis_y).normalized()
	var mov = Vector2(input_axis_x, input_axis_y)
	if mov!=Vector2.ZERO:
		last_movement = mov
	move_and_collide(velocity * delta)
	
func attack():
	if star_level>0:
		star_timer.wait_time = star_attack_speed * (1 - spell_cooldown)
		if star_timer.is_stopped():
			star_timer.start()
	if hand_level>0:
		spawn_hand()

func _on_star_timer_timeout():
	star_ammo += star_base_ammo + additional_attacks
	star_attack_timer.start()
	
func _on_star_attack_timer_timeout():
	if star_ammo>0:
		var star_attack = star.instantiate()
		star_attack.position = position 
		star_attack.target = get_random_target()
		star_attack.level = star_level
		add_child(star_attack)
		star_ammo -= 1
		if star_ammo > 0:
			star_attack_timer.start()
		else:
			star_attack_timer.stop()

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

func spawn_hand():
	var get_hand_total = $Attack/HandBase.get_child_count()
	var count_spawns = hand_ammo + additional_attacks - get_hand_total
	while count_spawns>0:
		var hand_spawn = hand.instantiate()
		hand_spawn.global_position = global_position
		$Attack/HandBase.add_child(hand_spawn)
		count_spawns -= 1 
	var get_hand = $Attack/HandBase.get_children()
	for i in get_hand:
		i.update_weapon()

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
	if experience + collected_exp >= exp_required:
		collected_exp -= exp_required - experience 
		exp_level += 1
		experience = 0
		exp_required = calculate_experience_cap()
		level_up()
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
		option_instance.item = get_random_item()
		upgrades.add_child(option_instance)
		options += 1
	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"HEALTH":
			HP += 25
			HP = clamp(HP, 0, MAXHP)
		"STAR1":
			star_level = 1
			star_base_ammo += 1
		"STAR2":
			star_level = 2
			star_base_ammo += 1
		"STAR3":
			star_level = 3
		"STAR4":
			star_level = 4
			star_base_ammo += 2
		"HAND1":
			hand_level = 1
			hand_ammo = 1
		"HAND2":
			hand_level = 2
		"HAND3":
			hand_level = 3
		"HAND4":
			hand_level = 4
		"ARMOUR1","ARMOUR2","ARMOUR3","ARMOUR4":
			armour += 1
		"SPEED1","SPEED2","SPEED3","SPEED4":
			SPEED += 20.0
		"SIZE1","SIZE2","SIZE3","SIZE4":
			spell_size += 0.10
		"SCROLL1","SCROLL2","SCROLL3","SCROLL4":
			spell_cooldown += 0.05
		"RING1","RING2":
			additional_attacks += 1
	attack()
	var option_children = upgrades.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	level_up_panel.visible = false
	get_tree().paused = false
	calculate_experience(0)
	
func get_random_item():
	var dblist = []
	for i in UpgradesDb.UPGRADES:
		if i in collected_upgrades:
			pass 
		elif i in upgrade_options:
			pass
		elif UpgradesDb.UPGRADES[i]["type"]=="item":
			pass
		elif UpgradesDb.UPGRADES[i]["prerequisite"].size()>0:
			var to_add = true
			for n in UpgradesDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size()>0:
		var random_upgrade = dblist.pick_random()
		upgrade_options.append(random_upgrade)
		return random_upgrade
	else:
		return null
		
func player_death():
	get_tree().paused = true

func update_health_bar():
	health_bar.value = HP
