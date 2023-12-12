class_name GASwitchVisibility extends GameAction

@export var node : Node2D

func activate():
    node.visible = !node.visible