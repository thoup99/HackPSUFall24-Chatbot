extends Node2D

class_name StartButton

@onready var animation_player := $AnimationPlayer

signal clicked
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("idle")




func _on_button_button_up() -> void:
	clicked.emit()
