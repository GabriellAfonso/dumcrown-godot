extends Node

var handlers = {
    'connected': '_connected_with_Server',
    'pong': 'ping',
    'ranking_update': 'handle_ranking_update',
    # Adicione outros tipos de mensagens e métodos de manipulação conforme necessário
}