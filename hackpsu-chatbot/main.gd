extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gpt.dialogue_request("Why is patrick webster bad at spelling patryck?")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
