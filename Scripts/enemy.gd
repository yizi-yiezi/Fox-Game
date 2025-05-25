extends Area2D

@export var slime_speed: float = 100
@export var animator: AnimatedSprite2D
@export var damage: int = 1

var is_death: bool = false

signal kill_by_player
signal hit_charactor(value: int)

# physics movement
func _physics_process(delta: float) -> void:
	if is_death:
		return
	position += Vector2(slime_speed, 0) * delta
	
	if position.x < -264:
		queue_free()

# Collide player
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_death:
		hit_charactor.emit(damage)

# Killed by player
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		print(self.name + ": eliminated by bullet")
		#$AnimatedSprite2D.play("$Death") # weak connection
		animator.play("Death")			  # strong connection
		
		is_death = true
		$DeathSound.play()
		kill_by_player.emit()
		
		area.queue_free()
		await get_tree().create_timer(0.6).timeout
		self.queue_free()
