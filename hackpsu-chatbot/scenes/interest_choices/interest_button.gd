extends Node2D

class_name InterestButton

@export var id: int = 0

@onready var button:= $ColorRect/Button

signal clicked(id: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_text(new_text):
	button.text = new_text

func get_text() -> String:
	return button.text


func _on_button_button_up() -> void:
	clicked.emit(id)
