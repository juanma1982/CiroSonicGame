extends VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func goToScene (sceneLevel, nextLevel) -> void:
	helper_functions.setCurrentLevel(nextLevel)
	if (not helper_functions.change_scene ("res://Scenes/"+sceneLevel) == OK):
		printerr ("Unable to load the test level!")
		get_tree ().quit ()
	return

func _on_btn_goback_pressed():
	var currentLevel = helper_functions.getCurrentLevel()
	if currentLevel == 0:
		currentLevel += 1
		goToScene("Levels/moronCity_2.tscn",currentLevel)
	elif currentLevel == 1 :
		currentLevel += 2
		goToScene("Levels/finalBossLevel.tscn",currentLevel)
	elif currentLevel == 2:
		currentLevel = 0
		goToScene("UI/main_menu.tscn",currentLevel)
	return


func _on_QuitBtn_pressed():
	get_tree ().quit ()
	return
