extends Node2D

class_name Thinking

@onready var animation_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("thinking")
