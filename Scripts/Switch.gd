extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal onHit

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Switch_body_entered(body):
	if body.is_in_group("Bullet"):
		emit_signal("onHit")
		$AudioStreamPlayer2D.play()
