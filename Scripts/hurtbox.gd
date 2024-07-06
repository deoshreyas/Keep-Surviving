extends Area2D

@export_enum("Cooldown", "Hitonce", "Disabled") var HurtType = 0

@onready var collision = $CollisionShape2D
@onready var disabled_timer = $DisabledTimer

signal hurt(damage)

func _on_area_entered(area):
	if area.is_in_group("Attack"):
		if not area.get("damage")==null:
			match HurtType:
				"Cooldown": 
					collision.call_deferred("_set", "disabled", true)
					disabled_timer.start()
				"Hitonce":
					pass 
				"Disabled":
					if area.has_method("tempDisable"):
						area.tempDisable()
			var damage = area.damage
			emit_signal("hurt", damage)

func _on_disabled_timer_timeout():
	collision.call_deferred("_set", "disabled", false)
