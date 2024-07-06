extends CharacterBody2D

@export var SPEED = 20
@export var HP = 10
@onready var player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	move_and_collide(velocity * delta)

func _on_hurtbox_hurt(damage):
	HP -= damage 
	if damage <= 0:
		queue_free()
