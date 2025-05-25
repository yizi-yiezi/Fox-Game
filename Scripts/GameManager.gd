extends Node2D

@export var slime_scene: PackedScene
@export var spawn_timer: Timer
@export var score: int = 0
@export var player: CharacterBody2D
@export var ui: CanvasLayer
@export var windowMode: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.player_dead.connect(_on_player_player_dead)
	ui.get_node("ScoreLabel").text = "Score: " + str(score)
	ui.get_node("GameOverLabel").visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer.wait_time -= 0.2 * delta
	spawn_timer.wait_time = clamp(spawn_timer.wait_time, 1, 3)
	# Switch window mode
	if Input.is_action_just_pressed("switchWindow"):
		if windowMode != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			windowMode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		else:
			windowMode = DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_mode(windowMode)

# Spawn Timer
func _spawn_slime() -> void:
	var slime_node = slime_scene.instantiate()
	self._init_slime(slime_node)
	get_tree().current_scene.add_child(slime_node)

# Init slime after spawned
func _init_slime(slime_node: Area2D) -> void:
	slime_node.position = Vector2(246, randf_range(42, 110))
	slime_node.kill_by_player.connect(_on_slime_kill_by_player)
	slime_node.hit_charactor.connect(_on_slime_hit_charactor)

# Add Score
func _on_slime_kill_by_player(value: int = 1) -> void:
	self.score += value
	ui.get_node("ScoreLabel").text = "Score: " + str(self.score)
	print("Current Score: " + str(self.score))

# forward slime signal to player
func _on_slime_hit_charactor(damage: int) -> void:
	player.change_health(-damage)

# handler player dead
func _on_player_player_dead() -> void:
	self.ui.get_node("GameOverLabel").visible = true
	$GameOverSound.play()
	await player._player_dead()
	self.get_tree().reload_current_scene()
