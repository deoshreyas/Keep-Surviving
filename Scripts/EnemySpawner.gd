extends Node2D

@export var spawns : Array[SpawnInfo] = []

@onready var player = get_tree().get_first_node_in_group("Player")

func _on_spawn_timer_timeout():
	var enemy_spawns = spawns 
	for i in enemy_spawns:
		if i.spawn_delay_counter < i.enemy_spawn_delay:
			i.spawn_delay_counter += 1 
		else:
			i.spawn_delay_counter = 0
			var new_enemy = i.enemy
			var enemy_spawn = new_enemy.instantiate()
			enemy_spawn.global_position = get_random_position()
			add_child(enemy_spawn)
					
func get_random_position():
	var v_rect = get_viewport_rect().size * randf_range(1.1, 1.4)
	var top_left = Vector2(player.global_position.x - v_rect.x/2, player.global_position.y - v_rect.y/2)
	var top_right = Vector2(player.global_position.x + v_rect.x/2, player.global_position.y - v_rect.y/2)
	var bottom_left = Vector2(player.global_position.x - v_rect.x/2, player.global_position.y + v_rect.y/2)
	var bottom_right = Vector2(player.global_position.x + v_rect.x/2, player.global_position.y + v_rect.y/2)
	var rand_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO 
	var spawn_pos2 = Vector2.ZERO
	match rand_side:
		"up": 
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)
