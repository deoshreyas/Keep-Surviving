extends CharacterBody2D

@export var SPEED = 20
@export var HP = 10
@export var knockback_recovery = 3.5
@export var exp = 1
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var loot_base = get_tree().get_first_node_in_group("Loot")

var exp_gem = preload("res://Scenes/gem.tscn")

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
		spawn_gems()
		queue_free()
		
func spawn_gems():
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.EXPERIENCE = exp
	get_tree().root.add_child(new_gem)
