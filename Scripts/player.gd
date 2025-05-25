extends CharacterBody2D


@export var v_factor: int = 50
@export var animator: AnimatedSprite2D
@export var bullet_scene: PackedScene 
@export var player_health: int = 10

var is_gameover: bool = false
var direction: int = 1
var is_onhit: bool = false

signal player_dead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("player ready")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or is_gameover:
		$RunningSound.stop()
	elif not $RunningSound.playing:
		$RunningSound.play()

# physics related process
func _physics_process(delta: float) -> void:
	if is_gameover:
		return
	
	velocity = Input.get_vector("left", "right", "up", "down") * v_factor
	
	# diff direction with input
	if velocity.x < 0:
		direction = -1
	elif velocity.x > 0:
		direction = 1
	animator.scale.x = 1 * direction
	
	# animation
	if not is_onhit:
		if velocity == Vector2.ZERO:
			animator.play("Idle")
		else:
			animator.play("Run")
		
	# run
	move_and_slide()


func _player_dead():
	if is_gameover:
		return
	
	is_gameover = true
	animator.play("Death")
	await get_tree().create_timer(3).timeout

# Timer handler function
func _on_fire() -> void:
	# shot when fixed
	if velocity != Vector2.ZERO or is_gameover:
		return
	var bullet_node = bullet_scene.instantiate()
	
	# set direction
	if direction > 0:
		bullet_node.position = position + Vector2(16, 7)
	else:
		bullet_node.position = position + Vector2(-16, 7)
	bullet_node.bullet_speed *= direction
	
	$FireSound.play()
	get_tree().current_scene.add_child(bullet_node)

# external func for health change
func change_health(value: int) -> void:
	$HitAnimationTimer.start()
	is_onhit = true
	animator.play("OnHit")
	self.player_health += value
	
	if self.player_health <= 0:
		player_dead.emit()
	print("Taken Damage: " + str(value))
	print("Current health: " + str(self.player_health))


func _on_hit_animation_timer_timeout() -> void:
	is_onhit = false
