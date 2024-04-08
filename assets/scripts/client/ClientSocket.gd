extends Node
var thread = Thread.new()
var connected = false
var state

var ping_time = 0
var pong_time = 0
var latency_ms = 0

var SOCKET := WebSocketPeer.new()

var code_handlers = {
    'connected': '_connected_with_Server',
    'pong': 'ping',
    'ranking_update': 'handle_ranking_update',
    # Adicione outros tipos de mensagens e métodos de manipulação conforme necessário
}

func _connect():

    var token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxfQ.86bZyALOgsNr--DeTG18IqJtLqi7nvo5cuCAgNKPRdU'
    var url = "ws://localhost:8000/ws/game/?token=" + token # Adicione o token como parâmetro de consulta, se necessário

    print('Conectando...')
    SOCKET.connect_to_url(url)
    # print('conectando...')
    # SOCKET.connect_to_url("ws://localhost:8000/ws/game/", headers)

func _disconnect():
    connected = false
    print('desconectado')
    await get_tree().create_timer(3).timeout
    reconnect()

func _ready():
    pass

func _process(_delta):
    SOCKET.poll()
    state = SOCKET.get_ready_state()
    if state == SOCKET.STATE_OPEN:
        receive()
    elif state == SOCKET.STATE_CLOSED:
        if connected:
            _disconnect()

func receive():
    while SOCKET.get_available_packet_count():
        var server_data_str = SOCKET.get_packet().get_string_from_utf8()
        var server_msg = JSON.parse_string(server_data_str)

        for code in code_handlers.keys():
            if code == server_msg.code:
                if server_msg.data:
                    call(code_handlers[code], server_msg.data)
                else:
                    call(code_handlers[code])

func send(code, data=""):
    var message = {
        'code': code,
        'data': data,
    }
    var dataJson = JSON.stringify(message)
    SOCKET.send_text(dataJson)

func reconnect():
    print('reconectando')
    _connect()

#fazer uma funçao pra ver se ta conectado e retornando algo caso nao esteja
func _connected_with_Server():
    connected = true
    print('conectado ao servidor')
    ping()

func ping():
    latency_ms = get_ping_latency_ms()
    send('ping')

func get_ping_latency_ms():
    pong_time = Time.get_unix_time_from_system() * 1000
    var ms = pong_time - ping_time
    ping_time = Time.get_unix_time_from_system() * 1000
    return int(floor(ms))