extends Sprite2D


var revealed = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("show_answer"):
		if revealed:
			self.hide()
		else:
			self.show()
		revealed = not revealed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
