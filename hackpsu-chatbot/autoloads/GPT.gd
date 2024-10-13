extends Node

var api_key = "Enter API Key"
var url: String = "https://api.openai.com/v1/chat/completions"
var temperature: float = 0.5
var max_tokens: int = 1024
var headers = ["Content-type: application/json", "Authorization: Bearer " + api_key]
var model: String = "gpt-4o-mini"
var messages = []
var request: HTTPRequest

var last_message: String

enum STATUS {OPEN, REQUESTING}
var current_status : STATUS = STATUS.OPEN

signal recieved_response

func _ready() -> void:
	request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(_on_request_completed)
	
func clear_message_history():
	messages.clear()
	
func send_request(question: String):
	if current_status == STATUS.REQUESTING:
		print("GPT is currently requesting try again later")
		return
		
	current_status = STATUS.REQUESTING
	messages.append({
		"role": "user",
		"content": question
		})
		
	var body = JSON.stringify({
		"messages": messages,
		"temperature": temperature,
		"max_tokens": max_tokens,
		"model": model
	})
	
	
	var sendt_request = request.request(url, headers, HTTPClient.METHOD_POST, body)
	
	if sendt_request != OK:
		print("There was an error processing the request.")
	
func _on_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	var message = response["choices"][0]["message"]["content"]
	
	#Add Chat gpt response to messages
	messages.append({
		"role": "system",
		"content": message
	})
	
	print(message)
	last_message = message
	current_status = STATUS.OPEN
	recieved_response.emit()
