extends Node2D

class_name InterestChoices

@onready var label := $Label

@onready var interest_buttons: Array[InterestButton] = [$InterestButton1, $InterestButton2, $InterestButton3, $InterestButton4]
@onready var none_button:= $InterestButtonNone

var interest: String
var skills: String

var new_interest_found: bool = false
var new_interest: String

var interest_dict: Dictionary

signal interest_generated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	none_button.set_text("None")

func set_run_number(run_num: int):
	label.text = "Which Interest you Most? (" + str(run_num) + "/3)"
	
func load_interest_and_skills(in_interest: String, in_skills: String):
	interest = in_interest
	skills = in_skills

func generate_new_interest():
	var question: String = "Given my skills in '"+ skills +"', and my interest '"+ interest +"', what are some other interest that might appeal to me and could possibly fall into my skillset. Create 4 interest and make sure they are one or two words each. Return your answers in the following format: {\"1\": \"interest_1\", \"2\": \"interest_2\", \"3\": \"interest_3\", \"4\": \"interest_4\"}, where interest_# is the value you are changing."
	
	Gpt.clear_message_history()
	Gpt.send_request(question)
	
	await Gpt.recieved_response
	var message: String = Gpt.last_message
	
	print(message)
	interest_dict = JSON.parse_string(message)
	
	
func set_interest_labels():
	for x in range(1, 5):
		interest_buttons[x - 1].set_text(interest_dict[str(x)].capitalize())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_interest_button_clicked(id: int):
	if id == 0:
		new_interest_found = false
	
	else:
		new_interest_found = true
		new_interest = interest_dict[str(id)]
	interest_generated.emit()
