extends CanvasLayer


const PATH := "user://keybinds.ini"

var config: ConfigFile
var waiting_for_input := false
var previous_event: String
var current_button: Button
var current_action: String

onready var move_left := $PopupPanel/ScrollContainer/VBoxContainer/HBoxContainer/MoveLeft
onready var move_right := $PopupPanel/ScrollContainer/VBoxContainer/HBoxContainer2/MoveRight
onready var move_up := $PopupPanel/ScrollContainer/VBoxContainer/HBoxContainer3/MoveUp
onready var move_down := $PopupPanel/ScrollContainer/VBoxContainer/HBoxContainer4/MoveDown
onready var jump := $PopupPanel/ScrollContainer/VBoxContainer/HBoxContainer5/Jump


func _ready() -> void:
	set_process_unhandled_key_input(false)
	config = ConfigFile.new()
	if config.load(PATH) == OK:
		for action in ["move_left", "move_right", "move_up", "move_down", "jump"]:
			load_keybind(action, "movement")
	else:
		for action in ["move_left", "move_right", "move_up", "move_down", "jump"]:
			get(action).text = InputMap.get_action_list(action)[0].as_text()
			get(action).connect("pressed", self, "on_button_pressed", [get(action), action])


func load_keybind(action: String, section: String) -> void:
	var event = config.get_value(section, action, false)
	if event is InputEventKey:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
	get(action).text = InputMap.get_action_list(action)[0].as_text()
	get(action).connect("pressed", self, "on_button_pressed", [get(action), action])


func _unhandled_key_input(event: InputEventKey) -> void:
	if current_button and current_action:
		InputMap.action_erase_events(current_action)
		InputMap.action_add_event(current_action, event)
		set_process_unhandled_key_input(false)
		current_button.text = event.as_text()
		waiting_for_input = false
		config.set_value("movement", current_action, event)
		config.save(PATH)


func show_keybinds() -> void:
	$PopupPanel.popup_centered()
	

func on_button_pressed(b: Button, action: String) -> void:
	if waiting_for_input:
		current_button.text = previous_event
	previous_event = b.text
	b.text = "[Press any key]"
	current_button = b
	current_action = action
	set_process_unhandled_key_input(true)
	waiting_for_input = true


func _on_PopupPanel_popup_hide() -> void:
	if waiting_for_input:
		set_process_unhandled_key_input(false)
		current_button.text = previous_event
