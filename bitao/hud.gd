extends CanvasLayer

signal start_game

func update_score(value):
	$ScoreLabel.text = "Score: " + str(value)

func update_lives(value):
	$LivesLabel.text = "Lives: " + str(value)

func update_level(value):
	$LevelLabel.text = "Level: " + str(value)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over(final_score):
	show_message("Game Over!\nScore: " + str(final_score))
	await $MessageTimer.timeout
	$MessageLabel.text = "Space Shooter"
	$MessageLabel.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func hide_message():
	$MessageLabel.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	$MessageLabel.hide()
	emit_signal("start_game")

func _on_message_timer_timeout():
	$MessageLabel.hide()


func _on_timer_timeout() -> void:
	pass # Replace with function body.
