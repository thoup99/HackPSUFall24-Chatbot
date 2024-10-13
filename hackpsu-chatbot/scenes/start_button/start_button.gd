extends Node2D

class_name StartButton

@onready var animation_player := $AnimationPlayer

signal clicked
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	clicked.emit()
