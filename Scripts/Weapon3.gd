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
	
func update_weapon():
	level = player.javelin_level
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
	scale = Vector2(0.5, 0.5) * attack_speed
	attack_timer.wait_time = attack_speed

func _physics_process(delta):
	if target_array.size()>0:
		position += angle * speed * delta


func _on_attack_timer_timeout():
	pass # Replace with function body.
