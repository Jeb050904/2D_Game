extends Area2D

@export var speed = 150
@export var bullet_scene: PackedScene

var screen_size
var shoot_timer = 0.0
var shoot_interval = 2.0

func _ready():
	screen_size = get_viewport_rect().size
	add_to_group("enemies")
	shoot_timer = randf_range(0.5, shoot_interval)

func _process(delta):
	position.y += speed * delta

	# Shoot at player
	shoot_timer -= delta
	if shoot_timer <= 0:
		shoot()
		shoot_timer = randf_range(1.0, shoot_interval)

	# Remove if off screen
	if position.y > screen_size.y + 40:
		queue_free()

func shoot():
	if bullet_scene == null:
		return
	var bullet = bullet_scene.instantiate()
	bullet.position = position + Vector2(0, 20)
	bullet.direction = Vector2(0, 1)
	get_parent().add_child(bullet)

func _on_area_entered(area):
	if area.is_in_group("bullets"):
		area.queue_free()
		# Notify main scene
		get_parent().enemy_killed()
		# Spawn explosion particles
		queue_free()
