extends Node

var api_key = "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"
var url: String = "https://api.openai.com/v1/chat/completions"
var temperature: float = 0.5
var max_tokens: int = 1024
var headers = ["Content-type: application/json", "Authorization: Bearer " + api_key]
var model: String = "gpt-4o-mini"
var messages = []
var request: HTTPRequest

enum STATUS {OPEN, REQUESTING}
var current_status : STATUS = STATUS.OPEN

func _ready() -> void:
	request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(_on_request_completed)
	
func clear_message_history():
	messages.clear()
	
func dialogue_request(player_dialogue: String):
	if current_status == STATUS.REQUESTING:
		print("GPT is currently requesting try again later")
		return
		
	current_status = STATUS.REQUESTING
	messages.append({
		"role": "user",
		"content": player_dialogue
		})
		
	var body = JSON.new().stringify({
		"messages": messages,
		"temperature": temperature,
		"max_tokens": max_tokens,
		"model": model
	})
	
	
	var send_request = request.request(url, headers, HTTPClient.METHOD_POST, body)
	
	if send_request != OK:
		print("There was an error processing the request.")
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	var message = response["choices"][0]["message"]["content"]
	
	#Add Chat gpt response to messages
	messages.append({
		"role": response["choices"][0]["role"],
		"message": message
	})
	
	print(message)
	current_status = STATUS.OPEN
