extends Node2D

var node_jail_cords:= Vector2(-1000, -1000)

enum UICOMPONENTS {START, ENTRY, THINKING, INTEREST_CHOICES, POSSIBLE_CAREERS, CHATBOT}

enum STATES {START, INTEREST, SKILLS, INTEREST_EXPANDING, GENERATE_CAREERS, ONE_ON_ONE}
var current_state: STATES = STATES.START
var after_thinking_state: STATES = STATES.INTEREST_EXPANDING

@onready var start_button: StartButton = $StartButton
@onready var entry_box: EntryBox = $EntryBox
@onready var thinking: Thinking = $Thinking
@onready var interest_choices: InterestChoices = $InterestChoices
@onready var possible_careers: PossibleCareers = $PossibleCareers
@onready var chatbot: ChatBot = $Chatbot

@onready var ui_components = {
	UICOMPONENTS.START: {
		"node": start_button,
		"default_position": Vector2(928, 506)
	},
	UICOMPONENTS.ENTRY: {
		"node": entry_box,
		"default_position": Vector2(733, 357)
	},
	UICOMPONENTS.THINKING: {
		"node": thinking,
		"default_position": Vector2(770, 424)
	},
	UICOMPONENTS.INTEREST_CHOICES: {
		"node": interest_choices,
		"default_position": Vector2(580, 323)
	},
	UICOMPONENTS.POSSIBLE_CAREERS: {
		"node": possible_careers,
		"default_position": Vector2(658, 298)
	},
	UICOMPONENTS.CHATBOT: {
		"node": chatbot,
		"default_position": Vector2(670, 268)
	}
}

var interest: String
var skills: String
var expanded_runs: int = 0
var max_expanded_runs: int = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jail(UICOMPONENTS.ENTRY)
	jail(UICOMPONENTS.THINKING)
	jail(UICOMPONENTS.INTEREST_CHOICES)
	jail(UICOMPONENTS.POSSIBLE_CAREERS)
	jail(UICOMPONENTS.CHATBOT)

func unjail(ui_comp: UICOMPONENTS):
	ui_components[ui_comp]["node"].position = ui_components[ui_comp]["default_position"]
	
func jail(ui_comp: UICOMPONENTS):
	ui_components[ui_comp]["node"].position = node_jail_cords



func _on_start_button_clicked() -> void:
	if current_state == STATES.START:
		skills = ""
		interest = ""
		
		jail(UICOMPONENTS.START)
		entry_box.set_prompt("What all interest you?")
		unjail(UICOMPONENTS.ENTRY)
		current_state = STATES.INTEREST
		


func _on_entry_box_submitted() -> void:
	if current_state == STATES.INTEREST:
		interest = entry_box.text
		entry_box.set_prompt("Enter your skills.")
		
		current_state = STATES.SKILLS
	
	elif current_state == STATES.SKILLS:
		skills = entry_box.text
		jail(UICOMPONENTS.ENTRY)
		
		after_thinking_state = STATES.INTEREST_EXPANDING
		unjail(UICOMPONENTS.THINKING)
		
		expanded_runs = 1
		interest_choices.set_run_number(expanded_runs)
		interest_choices.load_interest_and_skills(interest, skills)
		interest_choices.generate_new_interest()
		await Gpt.recieved_response
		interest_choices.set_interest_labels()
		
		current_state = STATES.INTEREST_EXPANDING
		jail(UICOMPONENTS.THINKING)
		unjail(UICOMPONENTS.INTEREST_CHOICES)
		


func _on_interest_choices_interest_generated() -> void:
	if not current_state == STATES.INTEREST_EXPANDING:
		print("How did we get here? Interest signal recieved")
		
	if interest_choices.new_interest_found:
		interest += ", " + interest_choices.new_interest
		expanded_runs += 1
		
		if expanded_runs > max_expanded_runs:
			current_state = STATES.GENERATE_CAREERS
			
			jail(UICOMPONENTS.INTEREST_CHOICES)
			unjail(UICOMPONENTS.THINKING)
			
			possible_careers.load_interest_and_skills(interest, skills)
			possible_careers.generate_careers()
			await Gpt.recieved_response
			possible_careers.set_button_labels()
			
			current_state = STATES.GENERATE_CAREERS
			jail(UICOMPONENTS.THINKING)
			unjail(UICOMPONENTS.POSSIBLE_CAREERS)
			return
			
		
	jail(UICOMPONENTS.INTEREST_CHOICES)
	unjail(UICOMPONENTS.THINKING)

	interest_choices.set_run_number(expanded_runs)

	interest_choices.load_interest_and_skills(interest, skills)
	interest_choices.generate_new_interest()
	await Gpt.recieved_response
	interest_choices.set_interest_labels()
	
	current_state = STATES.INTEREST_EXPANDING
	jail(UICOMPONENTS.THINKING)
	unjail(UICOMPONENTS.INTEREST_CHOICES)

func _on_possible_careers_career_selected(text: String) -> void:
	jail(UICOMPONENTS.POSSIBLE_CAREERS)
	unjail(UICOMPONENTS.THINKING)
	
	chatbot.clear_history()
	chatbot.load_interest_and_skills(interest, skills)
	var prompt = "What are the key statistics for the role of "+ text
	chatbot.generate_first_answer(prompt)
	
	await Gpt.recieved_response
	
	current_state = STATES.ONE_ON_ONE
	jail(UICOMPONENTS.THINKING)
	unjail(UICOMPONENTS.CHATBOT)


func _on_possible_careers_major_selected(text: String) -> void:
	jail(UICOMPONENTS.POSSIBLE_CAREERS)
	unjail(UICOMPONENTS.THINKING)
	
	chatbot.clear_history()
	chatbot.load_interest_and_skills(interest, skills)
	var prompt = "What can I expect to learn in the " + text + " major program, how will this major set me up for the future, and what are the educational requirements?"
	chatbot.generate_first_answer(prompt)
	
	await Gpt.recieved_response
	
	current_state = STATES.ONE_ON_ONE
	jail(UICOMPONENTS.THINKING)
	unjail(UICOMPONENTS.CHATBOT)

func _on_chatbot_close() -> void:
	if current_state == STATES.ONE_ON_ONE:
		jail(UICOMPONENTS.CHATBOT)
		unjail(UICOMPONENTS.START)
		
		current_state = STATES.START
