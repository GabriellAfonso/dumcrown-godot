extends Node

func _ready():
    var math = load("res://math.gd")
    var resultado = math.soma(10, 5)
    print(resultado) # Isso imprimirá "15" no console
