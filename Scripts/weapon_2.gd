extends Area2D

var level = 1
var hp = 999
var speed = 100 
var damage = 5  
var knock_amt = 100
var attack_size = 1.0 

var last_movement = Vector2.ZERO  
var angle = Vector2.ZERO 
var angle_less = Vector2.ZERO
var angle_more = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")

signal remove_from_array(object)

func _ready():
	match level:
		1:
			hp = 2
			speed = 100 
			damage = 5 
			knock_amt = 100 
			attack_size = 1.0
			
	var move_to_less = Vector2.ZERO
	var move_to_more = Vector2.ZERO
	match last_movement:
		Vector2.UP, Vector2.DOWN:
			move_to_less = global_position + Vector2(randf_range(-1, -0.25), last_movement.y) * 500
			move_to_more = global_position + Vector2(randf_range(0.25, 1), last_movement.y) * 500
		Vector2.LEFT, Vector2.RIGHT:
			move_to_less = global_position + Vector2(last_movement.x, randf_range(-1, -0.25)) * 500
			move_to_more = global_position + Vector2(last_movement.x, randf_range(0.25, 1)) * 500
		Vector2(1, 1), Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1):
			move_to_less = global_position + Vector2(last_movement.x, last_movement.y) * 500
			move_to_more = global_position + Vector2(last_movement.x + randf_range(0, 0.75), last_movement.y) * 500
		
	angle_less = global_position.direction_to(move_to_less)
	angle_more = global_position.direction_to(move_to_more)
	
	var init_tween = create_tween()
	init_tween.tween_property(self, "scale", Vector2(0.5, 0.5)*attack_size, 3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	var final_speed = speed
	speed = speed/5
	init_tween.tween_property(self, "speed", final_speed, 6).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	init_tween.play()
	
	var tween = create_tween().set_loops(3)
	var set_angle = randi_range(0, 1)
	if set_angle==1:
		angle = angle_less
		tween.tween_property(self, "angle", angle_more, 2)
		tween.tween_property(self, "angle", angle_less, 2)
	else:
		angle = angle_more
		tween.tween_property(self, "angle", angle_less, 2)
		tween.tween_property(self, "angle", angle_more, 2)
		
func _physics_process(delta):
	position += angle * speed * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	remove_from_array.emit(self)
	queue_free()
