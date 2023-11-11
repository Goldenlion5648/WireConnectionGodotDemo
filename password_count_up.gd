extends RichTextLabel


var current_password = 543

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func bin_string(n):
	var ret_str = ""
	while n > 0:
		ret_str = str(n&1) + ret_str
		n = n>>1
	return ret_str


func update_password_display():
	var options = [1, 17, 98, 123, 729, 1127]
	var chosen = options.pick_random()
	print(chosen)
	self.current_password += chosen
	self.text = "[right][color=green][code]" + bin_string(current_password) +\
						 "[/code][/color][/right]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_password_display()
	
	
	
	
	
