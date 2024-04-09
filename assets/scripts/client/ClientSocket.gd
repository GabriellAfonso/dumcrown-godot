extends Node
var thread = Thread.new()
var connected = false
var can_disconnect
var url
var codes
var state
var token
var ping_time = 0
var pong_time = 0
var latency_ms = 0

var SOCKET := WebSocketPeer.new()

var code_handlers

func _ready():
    url = get_node("/root/Urls")
    codes = get_node("/root/Codes")
    code_handlers = codes.handlers

func _connect():
    can_disconnect = true
    print('Conectando...')
    SOCKET.connect_to_url(url.WEB_SOCKET + token)

func _disconnect():
    connected = false
    can_disconnect = false
    # add reconecting scene here
    print('desconectado')
    await get_tree().create_timer(2).timeout
    reconnect()

func _process(_delta):
    SOCKET.poll()
    state = SOCKET.get_ready_state()
    if state == SOCKET.STATE_OPEN:
        receive()
    elif state == SOCKET.STATE_CLOSED:
        if can_disconnect:
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

func _connected_with_Server():
    connected = true
    # exit reconnect scene here
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
