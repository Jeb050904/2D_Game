extends Area2D

@export var speed = 600
var direction = Vector2(0, -1)  # Default: goes up (player bullet)
var is_enemy_bullet = false

func _ready():
	if direction.y > 0:
		is_enemy_bullet = true
		add_to_group("enemy_bullets")
		$ColorRect.color = Color(1, 0.2, 0.2)  # Red for enemy
	else:
		add_to_group("bullets")
		$ColorRect.color = Color(0.2, 1, 1)  # Cyan for player

func _process(delta):
	position += direction * speed * delta
	var screen_size = get_viewport_rect().size
	if position.y < -20 or position.y > screen_size.y + 20:
		queue_free()
