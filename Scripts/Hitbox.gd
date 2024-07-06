extends Area2D

@export var damage = 1

@onready var collision = $CollisionShape2D
@onready var disabled_timer = $DisabledTimer

func tempDisable():
	collision.call_deferred("set", "disabled", true)
	disabled_timer.start()

func _on_disabled_timer_timeout():
	collision.call_deferred("set", "disabled", false)
