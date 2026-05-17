extends Area2D

signal hit
signal lives_changed(lives)

@export var speed = 400
@export var bullet_scene: PackedScene

var screen_size
var lives = 3
var invincible = false
var invincible_timer = 0.0
const INVINCIBLE_DURATION = 2.0
var can_shoot = true
var shoot_cooldown = 0.25

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func start():
	lives = 3
	position = Vector2(screen_size.x / 2, screen_size.y - 80)
	show()
	$CollisionShape2D.disabled = false
	invincible = false

func _process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	position.x = clamp(position.x, 20, screen_size.x - 20)
	position.y = clamp(position.y, 20, screen_size.y - 20)

	# Shooting
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

	# Invincibility flash
	if invincible:
		invincible_timer -= delta
		visible = int(invincible_timer * 10) % 2 == 0
		if invincible_timer <= 0:
			invincible = false
			visible = true
			$CollisionShape2D.disabled = false

func shoot():
	if bullet_scene == null:
		return
	can_shoot = false
	var bullet = bullet_scene.instantiate()
	bullet.position = position + Vector2(0, -30)
	get_parent().add_child(bullet)
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func take_damage():
	if invincible:
		return
	lives -= 1
	emit_signal("lives_changed", lives)
	if lives <= 0:
		call_deferred("_die")
	else:
		invincible = true
		invincible_timer = INVINCIBLE_DURATION
		$CollisionShape2D.set_deferred("disabled", true)
		await get_tree().create_timer(0.1).timeout
		$CollisionShape2D.set_deferred("disabled", false)

func _die():
	$CollisionShape2D.disabled = true
	hide()
	emit_signal("hit")

func _on_area_entered(area):
	if area.is_in_group("enemies") or area.is_in_group("enemy_bullets"):
		take_damage()
		if area.is_in_group("enemy_bullets"):
			area.call_deferred("queue_free")
