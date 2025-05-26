extends Node2D

@export var slime_scene: PackedScene
@export var swordman_scene: PackedScene
@export var medkit_scene: PackedScene
@export var speader_scene: PackedScene
@export var spawn_timer: Timer
@export var player: CharacterBody2D
@export var ui: CanvasLayer
@export var windowMode: int = 0
@export var score: int = 0
@export var rate_rare_enemy: float = 0.3
@export var rate_medkit: float = 0.1
@export var rate_speader: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.player_dead.connect(_on_player_player_dead)
	ui.get_node("ScoreLabel").text = "Score: " + str(score)
	ui.get_node("GameOverLabel").visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update UI
	ui.get_node("ScoreLabel").text = "Score: " + str(self.score)
	ui.get_node("HealthLabel").text = "Health: " + str(player.player_health)
	# More enemy spawn when time passed
	spawn_timer.wait_time -= 0.02 * delta
	spawn_timer.wait_time = clamp(spawn_timer.wait_time, 0.2, 3)
	rate_rare_enemy += 0.005 * delta
	rate_rare_enemy = clamp(rate_rare_enemy, 0, 0.9)
	# Switch window mode
	if Input.is_action_just_pressed("switchWindow"):
		if windowMode != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			windowMode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		else:
			windowMode = DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_mode(windowMode)

# Spawn Timer
func _spawn_slime() -> void:
	# rand spawn enemy
	var enemy_node: Node
	if randf() < rate_rare_enemy:
		enemy_node = swordman_scene.instantiate()
	else:
		enemy_node = slime_scene.instantiate()
	# Init enemy
	self._init_enemy(enemy_node, Vector2(246, randf_range(42, 110)))

# Init enemy after spawned
func _init_enemy(enemy_node: Area2D, pos: Vector2 = Vector2.ZERO) -> void:
	enemy_node.position = pos
	enemy_node.kill_by_player.connect(_on_enemy_kill_by_chractor)
	enemy_node.hit_by_bullet.connect(_on_enemy_hit_by_bullet)
	enemy_node.hit_charactor.connect(_on_enemy_hit_charactor)
	get_tree().current_scene.add_child(enemy_node)

# Init Item and Signals
func _init_item(item_node: Area2D, pos: Vector2 = Vector2.ZERO) -> void:
	if item_node == null:
		return
	item_node.position = pos
	if item_node.is_in_group("ItemMedkit"):
		item_node.used.connect(_on_medkit_used)
	elif item_node.is_in_group("ItemSpeader"):
		item_node.used.connect(_on_speader_used)
	get_tree().current_scene.add_child(item_node)

# Add Score
func _on_enemy_kill_by_chractor(enemy_node: Node, value: int = 1) -> void:
	var item_node: Area2D
	self.score += value * enemy_node.damage
	# drop items
	if randf() < rate_speader * enemy_node.damage:
		item_node = speader_scene.instantiate()
	elif randf() < rate_medkit * enemy_node.damage:
		item_node = medkit_scene.instantiate()
	self._init_item(item_node, enemy_node.position)
	# log
	print("Current Score: " + str(self.score))

# forward slime signal to player
func _on_enemy_hit_charactor(damage: int) -> void:
	player.change_health(-damage)

# func discrease bullet's durability
func _on_enemy_hit_by_bullet(bullet_node: Area2D) -> void:
	bullet_node.change_durability(-1)

# handler player dead
func _on_player_player_dead() -> void:
	self.ui.get_node("GameOverLabel").visible = true
	$GameOverSound.play()
	await player._player_dead()
	self.get_tree().reload_current_scene()

# health player
func _on_medkit_used(health: float) -> void:
	player.change_health(health)

# Speed up attack	
func _on_speader_used(attackspeed: float) -> void:
	player.set_attackspeed(player.attackspeed * attackspeed)
