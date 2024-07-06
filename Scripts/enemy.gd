extends CharacterBody2D

@export var SPEED = 20
@export var HP = 10
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")

signal remove_from_array(object)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	velocity += knockback
	move_and_collide(velocity * delta)

func _on_hurtbox_hurt(damage, angle, knockback_amount):
	HP -= damage
	knockback = angle * knockback_amount 
	if HP <= 0:
		remove_from_array.emit(self)
		queue_free()
