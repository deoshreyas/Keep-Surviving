extends Area2D

@export_enum("Cooldown", "Hitonce", "Disabled") var HurtType = 0

@onready var collision = $CollisionShape2D
@onready var disabled_timer = $DisabledTimer

signal hurt(damage, angle, knockback)

var hitbox = null

var hitonce_array = []

func _physics_process(delta):
	if self.get_overlapping_areas().size()>0 and hitbox!=null:
		if self.overlaps_area(hitbox):
			if not hitbox.get("damage")==null:
				match HurtType:
					0: 
						collision.call_deferred("set", "disabled", true)
						disabled_timer.start()
					1:
						if hitonce_array.has(hitbox)==false:
							hitonce_array.append(hitbox)
							if hitbox.has_signal("remove_from_array"):
								if not hitbox.is_connected("remove_from_array", Callable(self, "remove_from_list")):
									hitbox.connect("remove_from_array", Callable(self, "remove_from_list"))
						else:
							return 
					2:
						if hitbox.has_method("tempDisable"):
							hitbox.tempDisable()
			var damage = hitbox.damage
			var angle = Vector2.ZERO
			var knockback = 1
			if not hitbox.get("angle")==null:
				angle = hitbox.angle 
			if not hitbox.get("knock_amt")==null:
				knockback = hitbox.knock_amt 
			hurt.emit(damage, angle, knockback)
			if hitbox.has_method("enemy_hit"):
				hitbox.enemy_hit(1)
				
func remove_from_list(object):
	if hitonce_array.has(object):
		hitonce_array.erase(object)

func _on_area_entered(area):
	if area.is_in_group("Attack"):
		hitbox = area

func _on_disabled_timer_timeout():
	collision.call_deferred("set", "disabled", false)
