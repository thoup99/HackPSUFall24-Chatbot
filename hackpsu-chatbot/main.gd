extends Node2D

var node_jail_cords:= Vector2(-1000, -1000)

enum UICOMPONENTS {START, ENTRY, THINKING}

enum STATES {START, INTEREST, SKILLS, MAJORS, GENERATE_FIELDS}
var current_state = STATES.START

@onready var start_button: StartButton = $StartButton
@onready var entry_box: EntryBox = $EntryBox
@onready var thinking: Thinking = $Thinking

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
	}
}



var interest: String
var skills: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jail(UICOMPONENTS.ENTRY)
	jail(UICOMPONENTS.THINKING)
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
		unjail(UICOMPONENTS.THINKING)
		
		current_state = STATES.MAJORS
		
