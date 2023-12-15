class_name ExitInteraction extends Control

func _on_no_button_pressed():
	Observer.cancel_interaction()

func _on_yes_button_pressed():
	Observer.end_screen()
