extends Control

const target_scene_path = "res://assets/scenes/login.tscn"

var loading_status: int
var progress: Array[float]

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var enter_button: TextureButton = $enter_button

func _ready() -> void:
    # Request to load the target scene:
	enter_button.hide()
	ResourceLoader.load_threaded_request(target_scene_path)
	enter_button.button_up.connect(self._enter_button_up)
    
func _process(_delta: float) -> void:
    # Update the status:
	loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
    
    # Check the loading status:
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
            # Atualize o valor atual do ProgressBar
			progress_bar.value = progress[0] * 100

		ResourceLoader.THREAD_LOAD_LOADED:
			progress_bar.value = progress[0] * 100
			await get_tree().create_timer(1).timeout
			progress_bar.hide()
			enter_button.show()
           
		ResourceLoader.THREAD_LOAD_FAILED:
            # Well some error happened:
			print("Error. Could not load Resource")

func _enter_button_up() -> void:
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene_path))
