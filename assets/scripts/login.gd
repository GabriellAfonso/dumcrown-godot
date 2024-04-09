extends Button
var json = JSON.new()
var socket
var url
@onready var http_request = $HTTPRequest

func _ready():
	url = get_node("/root/Urls")
	socket = get_node("/root/ClientSocket")

func _on_pressed():
	http_request.request_completed.connect(on_request_completed)

	var username = get_parent().get_node("usernameInput")
	var password = get_parent().get_node("passwordInput")

	login_request(username, password)

func login_request(username, password):
	var form_data = {
		"username": username.text,
		"password": password.text,
	}
	var form_json = JSON.stringify(form_data)

	var headers = ["Content-Type: application/json"]
	http_request.request(url.LOGIN, headers, HTTPClient.METHOD_POST, form_json)

func on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		var user_data = JSON.parse_string(body.get_string_from_utf8())
		socket.token = user_data.token
		socket._connect()
	else:
		print('conta errada')