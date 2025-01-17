## goal_post.gd
# Controls the "goalpost" - the end of the current level.
# When it's touched, it'll play an animation. Once that animation has finished, it'll do the end-of-level stuff.

extends Area2D

var goaled:bool = false

# Called when the node enters the scene tree for the first time.
func _ready () -> void:
	helper_functions._whocares = self.connect ("area_entered", self, "hit_goalpost")
	helper_functions._whocares = $"AnimationPlayer".connect ("animation_finished", self, "goalpost_raised")
	return

##  hit_goalpost
# Called when something passes by the goalpost. If it's the player, then it'll trigger the end-of-level sequence.
# This handles the end-of-level animation, everything else should be handled by goalpost_raised.
func hit_goalpost (body) -> void:
	if not visible: return
	if (body is game_space.player_class and not goaled):	# Player has passed the goalpost.
		goaled = true
		$"AnimationPlayer".play ("goal")
		$"cartelAnimado".play("girar")
		sound_player.play_sound ("goalpost")
		if (OS.is_debug_build ()):
			printerr ("Goal post passed!")
	return

##  goalpost_raised
# Once the end-of-level animation has been played, start with everything else.
func goalpost_raised (_xxx) -> void:
	printerr ("TODO: End of level stuff here!")
	game_space.player_node.is_unmoveable = true
	jingle_player.play_jingle ("res://Assets/Audio/Jingles/Mission_Complete.ogg", false)
	helper_functions.add_path_to_node ("res://Scenes/UI/nextLevel.tscn", "/root/Level/game_hud")
	return
