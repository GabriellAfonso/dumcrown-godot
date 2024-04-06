extends Button
var json = JSON.new()
@onready var http_request = $HTTPRequest
const URL = "http://127.0.0.1:8000/api/login/"

# Função chamada quando o botão é pressionado
func _on_pressed():
	var ws = get_node("/root/Client")
	ws.start = true
	ws.SOCKET.connect_to_url("ws://localhost:8000/ws/game/")
	
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

    # # Configurar a URL para enviar a requisição POST
    # var url = "http://127.0.0.1:8000/api/login/"

    # # Configurar a requisição HTTP
    # var http_request = $HTTPRequest
    # http_request.request(url, [], {"Content-Type": "application/json"}, form_json)

# Função chamada quando a resposta da requisição HTTP é recebida
# func _on_HTTPRequest_request_completed(result, response_code, headers, body):
#     if response_code == 200: # Verificar se a resposta foi bem-sucedida
#         var response_data = json.parse(body)
#         # Armazenar a resposta em uma variável
#         var resposta = response_data # Substitua pela variável que você deseja usar para armazenar a resposta
#         # Faça qualquer coisa que você precise fazer com a resposta aqui
#         print(resposta)
#     else:
#         print("Erro na requisição:", response_code)

func _on_request_completed(_result, _response_code, _headers, body):
	var recebido = JSON.parse_string(body.get_string_from_utf8())
	print(recebido)