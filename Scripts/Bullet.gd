extends KinematicBody2D

var MOTION_SPEED = 2000
var dropped = false
var bulletType = "Normal"	# Bounce
var bounces = 0
var canKillPlayer = false
var kills = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here

	pass

func _process(delta):
	var movedir = Vector2(1,0).rotated(rotation)
	var motion = movedir.normalized() * MOTION_SPEED
	var collision = move_and_collide(motion*delta)
	
	if collision:
		if collision.collider.is_in_group("Enemy"):
			collision.collider.onHit()
			kills += 1
		elif collision.collider.is_in_group("Player"):
			if canKillPlayer:
				collision.collider.playerHit()
		elif collision.collider.is_in_group("Breakable"):
			collision.collider.onHit()	# Pierces boxes
		elif collision.collider.has_method("onHit"):
			collision.collider.onHit()
			dropped = true
		else:
			if bulletType == "Bounce":
				bounces += 1
				if bounces > 3:
					dropped = true
					canKillPlayer = false
				else:
					var n = collision.normal
					movedir = movedir.bounce(n)
					rotation = movedir.angle()
					move_and_slide(movedir)
					if !canKillPlayer:
						collision_mask = collision_mask | 2	# Adds player collision
						canKillPlayer = true
					
			else:
				dropped = true
				canKillPlayer = false
			#queue_free()
		if dropped:
			if kills == 2:
				BGMSFX.play("res://Audio/doublekillVoice.wav")
			if kills == 3:
				BGMSFX.play("res://Audio/triplekillVoice.wav")
			if kills == 5:
				BGMSFX.play("res://Audio/pentakillVoice.wav")
			if kills >= 6:
				BGMSFX.play("res://Audio/multikillVoice.wav")

			MOTION_SPEED = 0
			collision_mask = collision_mask | 2	# Adds player collision
			collision_mask -= 4	# Removes collision with enemy 