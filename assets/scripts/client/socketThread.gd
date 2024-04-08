# extends Node
# var thread: Thread
# var thread2: Thread

# # The thread will start here.
# func _ready():
#     thread = Thread.new()
#     thread2 = Thread.new()

#     # You can bind multiple arguments to a function Callable.
#     thread.start(_on_process_frame)
#     thread2.start(_on_process_half_frame)

# func _on_process_frame():
#     while true:
#         # Coloque aqui o código da primeira função
#         print("Executando a primeira função...")
#         OS.delay_msec(1000)
#         # Aguarde um pequeno intervalo
#         # Isso permite que o código seja executado novamente na próxima iteração

# func _on_process_half_frame():
#     while true:
#         # Coloque aqui o código da segunda função
#         print("Executando a segunda função...")
#         OS.delay_msec(1000)
#         # Aguarde um pequeno intervalo

#         # Isso permite que o código seja executado novamente na próxima iteração
