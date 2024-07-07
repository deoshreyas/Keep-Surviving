extends Area2D

var level = 1
var hp = 9999
var speed = 200 
var damage = 30
var knock_amt = 100
var path = 1
var attack_size = 1.0 
var attack_speed = 4.0

var target = Vector2.ZERO 
var target_array = []

var angle = Vector2.ZERO 
var reset_pos = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var collision = $CollisionShape2D
@onready var attack_timer = $AttackTimer
@onready var change_dir_timer = $ChangeTimer
@onready var reset_pos_timer = $ResetPosTimer

signal remove_from_array(object)

func _ready():
	update_weapon()
	_on_reset_pos_timer_timeout()
	
func update_weapon():
	level = player.weapon3_level
	match level:
		1:
			var level = 1
			var hp = 9999
			var speed = 200 
			var damage = 30
			var knock_amt = 100
			var path = 1
			var attack_size = 1.0 
			var attack_speed = 4.0
	scale = Vector2(0.1, 0.1) * attack_speed
	attack_timer.wait_time = attack_speed

func _physics_process(delta):
	if target_array.size()>0:
		position += angle * speed * delta
	else:
		var player_angle = global_position.direction_to(reset_pos)
		var distance_diff = global_position - player.global_position 
		var return_speed = 50 
		if abs(distance_diff.y)>500 or abs(distance_diff.x)>500:
			return_speed = 100 
		position += player_angle*return_speed*delta
		rotation = global_position.direction_to(player.global_position).angle() + deg_to_rad(-55)

func _on_attack_timer_timeout():
	add_paths()
	
func add_paths():
	remove_from_array.emit(self)
	target_array.clear()
	var counter = 0 
	while counter < path:
		var new_path = player.get_random_target()
		target_array.append(new_path)
		counter += 1
		enable_attack(true)
	target = target_array[0]
	process_path()
	
func process_path():
	angle = global_position.direction_to(target)
	$ChangeTimer.start()
	var tween = create_tween()
	var new_rotation_degrees = angle.angle() + deg_to_rad(135)
	tween.tween_property(self, "rotation", new_rotation_degrees, 0.25).set_trans(tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _on_change_timer_timeout():
	if target_array.size()>0:
		target_array.remove_at(0)
		if target_array.size()>0:
			target = target_array[0]
			process_path()
			remove_from_array.emit(self)
		else:
			enable_attack(false)
	else:
		$ChangeTimer.stop()
		$AttackTimer.start()
		enable_attack(false)

func enable_attack(atk=true):
	if atk:
		collision.call_deferred("set", "disabled", false)
	else:
		collision.call_deferred("set", "disabled", true)

func _on_reset_pos_timer_timeout():
	var choose_dir = randi() % 4 
	reset_pos = player.global_position
	match choose_dir:
		0:
			reset_pos.x += 50
		1:
			reset_pos.x -= 50 
		2:
			reset_pos.y += 50
		3:
			reset_pos.y -= 50
