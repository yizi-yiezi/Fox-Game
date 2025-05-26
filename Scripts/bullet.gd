extends Area2D

@export var bullet_speed: float = 300
@export var durability: float = 1
@export var damage: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# auto destroy bullet 
	await get_tree().create_timer(3).timeout
	_recycle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += Vector2(bullet_speed, 0) * delta

# Change bullet durability
func change_durability(value: int) -> void:
	durability += value
	if durability <= 0:
		self._recycle()

# Recycle function
func _recycle() -> void:
	print("bullet " + self.name + " recycled")
	self.queue_free()	
