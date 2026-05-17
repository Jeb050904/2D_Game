extends Node

@export var enemy_scene: PackedScene

var score = 0
var level = 1
var enemies_killed = 0
var enemies_per_level = 10

func _ready():
	$HUD.update_score(0)
	$HUD.update_lives(3)

func new_game():
	score = 0
	level = 1
	enemies_killed = 0
	$HUD.update_score(0)
	$HUD.update_lives(3)
	$HUD.update_level(1)
	$HUD.hide_message()
	$Player.start()
	$EnemyTimer.start()
	$ScoreTimer.start()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("bullets", "queue_free")

func game_over():
	$EnemyTimer.stop()
	$ScoreTimer.stop()
	$HUD.show_game_over(score)

func _on_enemy_timer_timeout():
	if enemy_scene == null:
		return
	var enemy = enemy_scene.instantiate()
	var screen_width = get_tree().root.get_visible_rect().size.x
	var x = randf_range(40, screen_width - 40)
	enemy.position = Vector2(x, -30)
	add_child(enemy)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_player_hit():
	game_over()

func _on_player_lives_changed(lives):
	$HUD.update_lives(lives)

func enemy_killed():
	score += 10
	enemies_killed += 1
	$HUD.update_score(score)
	if enemies_killed >= enemies_per_level * level:
		level += 1
		$HUD.update_level(level)
		$HUD.show_message("Level " + str(level) + "!")
		var new_wait = max(0.3, $EnemyTimer.wait_time - 0.1)
		$EnemyTimer.wait_time = new_wait


func _on_hud_start_game() -> void:
	new_game()
