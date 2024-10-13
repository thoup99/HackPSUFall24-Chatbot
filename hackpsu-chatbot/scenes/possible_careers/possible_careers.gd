extends Node2D

class_name PossibleCareers

@onready var major_buttons: Array[IDButton] = [$IdButton1, $IdButton2, $IdButton3]
@onready var jobs_buttons: Array[IDButton] = [$IdButton4, $IdButton5, $IdButton6, $IdButton7, $IdButton8]

var interest: String
var skills: String
var careers_dict: Dictionary

signal career_selected(text: String)
signal major_selected(text: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func load_interest_and_skills(in_interest: String, in_skills: String):
	interest = in_interest
	skills = in_skills

func generate_careers():
	var question: String = "Based on my interest in "+ interest +" and my skills in "+ skills +", suggest 3 suitable college majors, and 5 potential job options that result from the generated majors and my skills/interest. Make sure responses are one or two words each. Return your answers in the following format: {\"j1\": \"job_1\", \"j2\": \"job_2\", \"j3\": \"job_3\", \"j4\": \"job_4\", \"j5\": \"job_5\", \"m1\": \"maj_1\", \"m2\": \"maj_2\", \"m3\": \"maj_3\"} where job_# and maj_# are the values you are changing."
	
	Gpt.clear_message_history()
	Gpt.send_request(question)
	
	await Gpt.recieved_response
	var message: String = Gpt.last_message
	
	careers_dict = JSON.parse_string(message)
	
func set_button_labels():
	set_job_labels()
	set_majors_labels()
	
func set_job_labels():
	for x in range(1, 6):
		jobs_buttons[x-1].set_text(careers_dict["j" + str(x)].capitalize())
	
func set_majors_labels():
	for x in range(1, 4):
		major_buttons[x-1].set_text(careers_dict["m" + str(x)].capitalize())

func on_id_button_clicked(id: int):
	if id == 0:
		pass
		
	elif id < 4:
		major_selected.emit(careers_dict["m" + str(id)].capitalize())
	elif id < 9:
		career_selected.emit(careers_dict["j" + str(id - 3)].capitalize())
	else:
		print("Should not be here. PossibleCareers: Unexpected value: "+ str(id))
