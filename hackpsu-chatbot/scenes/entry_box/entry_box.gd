extends Node2D

class_name EntryBox

@onready var prompt_label: Label = $PromptLabel
@onready var inline_edit: LineEdit = $LineEdit

var text: String

signal submitted

func set_prompt(new_prompt: String):
	prompt_label.text = new_prompt

func _on_submit_button_button_up() -> void:
	text = inline_edit.text
	submitted.emit()
