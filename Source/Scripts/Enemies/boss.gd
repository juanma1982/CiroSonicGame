### enemy_eggpawn.gd
# A generic test enemy.

extends "res://Scripts/Enemies/enemy_generic.gd"

var enableHit = true
var xSpeed = 0.4
var movement_direction = -1

func resetHits() -> void:
	hits_left = 8

func _ready () -> void:
	# The function that this refers to should be created in the actual scripts for enemies.
	hits_left = 8
	
	return

# The basic pawn is updated every frame.
func _process (_delta) -> void:
	if (hits_left > 0):	# So long as the enemy has hits left...
		# ...do a stupid simple AI routine. Simply move by x pixels per frame
		position.x += xSpeed*movement_direction #abs (random_helpers.RNG.randf_range (0.1, 0.5))
		if(position.x > 1300 or position.x < -120):
			movement_direction = movement_direction*-1
			$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	else:
		# This enemy is no more.
		# calculations for the explosion animation. 
		# Applies velocity, rotates, and then applies gravity
		position += explode_velocity
		rotation += 0.1
		explode_velocity.y += 0.5
		if (explode_velocity.y > 10):	# After a certain point, free them.
			queue_free ()
	return

## _on_enemy_area_entered
# Something has collided with this, what is it and what happens next?
func _on_enemy_area_entered (area) -> void:
	if(!enableHit):
		 return
	if (area is game_space.player_class and hits_left > 0):	# The player is hitting the egg pawn...
		# If the player isn't attacking, hurt the player.
		if (not area.is_player_attacking ()):
			area.hurt_player ()
			return
		elif (area.state == -1):	# Bounce a bit back into the air if attacking from above.
			area.player_velocity.y = -5
		if (area.is_player_attacking () and enableHit):	# Carry out the attack.
			hits_left = hits_left - 1
			$AnimatedSprite.play("hit")
			$CollisionShape2D.disabled = true
			enableHit = false
			$explosion.visible = true;
			$explosion2.visible = true;
			xSpeed += 0.2
			movement_direction = movement_direction*-1			
			$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
			$Timer.start()
			if (hits_left > 0):	# More than one hit remaining means the enemy survives for now.
				return

		# This enemy is dead...
		game_space.score += points_value
		var newNode = boostParticle.instance ()
		newNode.position = position
		newNode.boostValue = 2
		get_node ("/root/Level").add_child (newNode)

		

		# Set the velocity to match the player's speed, with a few constraints.
		explode_velocity = area.get ("player_velocity") * 1.5
		explode_velocity.y = min (explode_velocity.y, 10)
		explode_velocity.y -= 7

		# Play the explosion sfx.
		sound_player.play_sound ("enemy_boom")
	return


func _on_Timer_timeout():
	$AnimatedSprite.play("default")
	get_node("CollisionShape2D").disabled = false  # Replace with function body.
	enableHit = true
	$explosion.visible = false;
	$explosion2.visible = false;
	$Timer.stop()
	
