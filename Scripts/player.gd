extends CharacterBody2D

@export var SPEED = 30
@export var HP = 80

func _physics_process(delta):
	var input_axis_x = Input.get_axis("btn_left", "btn_right")
	var input_axis_y = Input.get_axis("btn_up", "btn_down")
	velocity = SPEED * Vector2(input_axis_x, input_axis_y).normalized()
	move_and_slide()

func _on_hurtbox_hurt(damage):
	HP -= damage
	print(HP)
