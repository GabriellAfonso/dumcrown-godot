extends Button
var json = JSON.new()

@onready var http_request = $HTTPRequest
const URL = "http://127.0.0.1:8000/api/login/"

# Função chamada quando o botão é pressionado
func _on_pressed():
	var ws = get_node("/root/ClientSocket")

	ws._connect()
	ws.send('ping', 've o ping ai')
	
	http_request.request_completed.connect(_on_request_completed)
	
	# Obter referência aos LineEdits
	var username = get_parent().get_node("usernameInput")
	var password = get_parent().get_node("passwordInput")

	# Criar dicionário com os dados do formulário
	var form_data = {
		"username": username.text,
		"password": password.text
	}

	# Converter os dados em JSON
	var form_json = JSON.stringify(form_data)

	var headers = ["Content-Type: application/json"]
	http_request.request(URL, headers, HTTPClient.METHOD_POST, form_json)

func _on_request_completed(_result, _response_code, _headers, body):
	var recebido = JSON.parse_string(body.get_string_from_utf8())
	print(recebido)
