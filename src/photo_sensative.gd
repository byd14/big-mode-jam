class_name PhotoSensative extends Area2D

var on_photo_callback = func ():
	print("'on_photo' is not specified")

func on_photo():
	if get_parent().has_method("on_photo"):
		get_parent().on_photo()
	else:
		on_photo_callback.call()
