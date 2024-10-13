extends Node2D

var node_jail_cords:= Vector2(-1000, -1000)

enum UICOMPONENTS {START, ENTRY, THINKING, INTEREST_CHOICES}

enum STATES {START, INTEREST, SKILLS, INTEREST_EXPANDING, GENERATE_CAREERS, ONE_ON_ONE}
var current_state: STATES = STATES.START
var after_thinking_state: STATES = STATES.INTEREST_EXPANDING

@onready var start_button: StartButton = $StartButton
@onready var entry_box: EntryBox = $EntryBox
@onready var thinking: Thinking = $Thinking
@onready var interest_choices: InterestChoices = $InterestChoices

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
	#Gpt.dialogue_request("Why is patrick webster bad at spelling patryck?")

func unjail(ui_comp: UICOMPONENTS):
	ui_components[ui_comp]["node"].position = ui_components[ui_comp]["default_position"]
	
func jail(ui_comp: UICOMPONENTS):
	ui_components[ui_comp]["node"].position = node_jail_cords



func _on_start_button_clicked() -> void:
	if current_state == STATES.START:
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
			pass #To Impliment
			
		
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
