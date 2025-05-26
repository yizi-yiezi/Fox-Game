extends Area2D

@export var health: float = 5
@export var auto_recycle_timer: Timer

signal used(health: float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	auto_recycle_timer.start(health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Collide charactor
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		used.emit(health)
		print(self.name + " hit by charactor")
		queue_free()

# Auto Recycle
func _on_auto_recycle_timer_timeout() -> void:
	print(self.name + " auto recycled")
	queue_free()
