extends Area2D
class_name Gem

@export var EXPERIENCE = 1

var target = null 
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready():
	if EXPERIENCE<5:
		return 
	elif EXPERIENCE<25:
		sprite.modulate = Color.RED
	else:
		sprite.modulate = Color.BLUE
		
func _physics_process(delta):
	if target!=null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2 * delta
	
func collect():
	SoundRoot.play_sound("coin")
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false 
	return EXPERIENCE 
	queue_free()
