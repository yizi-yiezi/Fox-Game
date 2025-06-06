extends Area2D

@export var slime_speed: float = 0
@export var animator: AnimatedSprite2D
@export var damage: int = 1
@export var health: int = 1

var is_death: bool = false

signal hit_by_bullet(bullet_node: Node)
signal kill_by_player(enemy_node: Node)
signal hit_charactor(value: int)

# physics movement
func _physics_process(delta: float) -> void:
	if is_death:
		return
		
	position += Vector2(self.slime_speed, 0) * delta
	
	if position.x < -264:
		queue_free()

# Collide player
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_death:
		hit_charactor.emit(self.damage)

# Killed by player
func _on_area_entered(area: Area2D) -> void:
	if not is_death and area.is_in_group("bullet"):
		self.health -= area.damage
		hit_by_bullet.emit(area)	# for bullet durability 
		
		if self.health <= 0:
			self.animator.play("Death")
			is_death = true
			$DeathSound.play()
			kill_by_player.emit(self)
			await get_tree().create_timer(0.6).timeout
			self.queue_free()
