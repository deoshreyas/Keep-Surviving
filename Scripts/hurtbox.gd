extends Area2D

@export_enum("Cooldown", "Hitonce", "Disabled") var HurtType = 0

@onready var collision = $CollisionShape2D
@onready var disabled_timer = $DisabledTimer

signal hurt(damage)

var hitbox = null

func _physics_process(delta):
	if self.get_overlapping_areas().size()>0 and hitbox!=null:
		if self.overlaps_area(hitbox):
			if not hitbox.get("damage")==null:
				match HurtType:
					0: 
						collision.call_deferred("set", "disabled", true)
						disabled_timer.start()
					1:
						pass 
					2:
						if hitbox.has_method("tempDisable"):
							hitbox.tempDisable()
			var damage = hitbox.damage
			hurt.emit(damage)
			if hitbox.has_method("enemy_hit"):
				hitbox.enemy_hit(1)

func _on_area_entered(area):
	if area.is_in_group("Attack"):
		hitbox = area

func _on_disabled_timer_timeout():
	collision.call_deferred("set", "disabled", false)
