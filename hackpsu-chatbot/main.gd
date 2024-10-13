extends Node2D

var node_jail_cords:= Vector2(-1000, -1000)

enum UICOMPONENTS {START, ENTRY}

@onready var start_button: StartButton = $StartButton
@onready var entry_box: EntryBox = $EntryBox

@onready var ui_components = {
	UICOMPONENTS.START: {
		"node": start_button,
		"default_position": Vector2()
	},
	UICOMPONENTS.ENTRY: {
		"node": entry_box,
		"default_position": Vector2()
	}
}

enum STATES {START, INTEREST, SKILLS, MAJORS, GENERATE_FIELDS}
var current_state = STATES.START

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#Gpt.dialogue_request("Why is patrick webster bad at spelling patryck?")

func retrieve(ui_comp: UICOMPONENTS):
	ui_components[ui_comp]["node"].position = ui_components[ui_comp]["default_position"]
	
func jail(ui_comp: UICOMPONENTS):
	ui_components[ui_comp]["node"].position = node_jail_cords

func set_state(new_state: STATES):
	if new_state == STATES.INTEREST:
		pass

func _on_start_button_clicked() -> void:
	if current_state == STATES.START:
		jail(UICOMPONENTS.START)
		
	
