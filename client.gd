extends Node
var ola = 1
var SOCKET := WebSocketPeer.new()

func _ready():
    SOCKET.connect_to_url("ws://localhost:8000/ws/game/")

func _process(_delta):
    SOCKET.poll()
    var state = SOCKET.get_ready_state()
    if state == WebSocketPeer.STATE_OPEN:
        if ola == 1:
            var message = {'message': 'hello server',}
            var json_message = JSON.stringify(message)
            print("Mensagem enviada para o servidor:", json_message)
            SOCKET.send_text(json_message)
        ola = 2
        while SOCKET.get_available_packet_count():
            # var servermsg = 
            print("Packet: ", SOCKET.get_packet().get_string_from_ascii())
    elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to achieve proper close.
        pass
    elif state == WebSocketPeer.STATE_CLOSED:
        var code = SOCKET.get_close_code()
        var reason = SOCKET.get_close_reason()
        print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != - 1])
        set_process(false) # Stop processing.