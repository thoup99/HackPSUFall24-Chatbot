extends Node2D

class_name InterestChoices

@onready var label := $Label

var interest: String
var skills: String

signal interest_generated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_run_number(run_num: int):
	label.text = "Which Interest you Most? (" + str(run_num) + "/3)"
	
func load_interest_and_skills(in_interest: String, in_skills: String):
	interest = in_interest
	skills = in_skills

func generate_new_interest():
	var question: String = "Given my skills in '"+ skills +"', and my interest '"+ interest +"', what are some other interest that might appeal to me and could possibly fall into my skillset. Create 4 interest and make sure they are one or two words each. Return your answers in the following format: {1: \"interest_1\", 2: \"interest_2\", 3: \"interest_3\", 4: \"interest_4\"}, where interest_# is the value you are changing."
	
	Gpt.clear_message_history()
	Gpt.send_request(question)
	
	await Gpt.recieved_response
	var message: String = Gpt.last_message
	
	##Change Boxes
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
