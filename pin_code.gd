extends Node2D

const Circle = preload("res://circle.gd")


# Called when the node enters the scene tree for the first time.
var circles: Array[Circle] = []
var spacing = 100
var radius = 20
var side_offset = 100
var currently_selected = null
var default_color = Color.GREEN

var main_line = Line2D.new()

var good_line_color = Color.BLACK
var bad_line_color = Color.RED
var most_recent_color = Color.BLACK

func _ready() -> void:
	add_child(main_line)
#	main_line.add_point(Vector2(side_offset,side_offset))
#	main_line.add_point(Vector2(side_offset+spacing,side_offset+spacing))
	
	for y in range(3):
		for x in range(3):
			circles.append(Circle.new(
						Vector2(x*spacing+side_offset, 
								y*spacing+side_offset), 
								radius, default_color))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_connection_valid(start, end):
#	print(start, end)
	print(main_line.points)
	for circle in circles:
		if circle.pos == start or circle.pos == end:
			continue
		if main_line.points.has(end):
			print('stopped since point used')
			return false
		if Geometry2D.segment_intersects_circle(start, end, circle.pos, circle.radius) >= 0:
#			prints("returning false", start, end, circle.pos, circle.radius)
			return false
	return true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	
	if event is InputEventMouseButton and event.is_pressed():
		for circle in circles:
			if Geometry2D.is_point_in_circle(
						get_local_mouse_position(), 
						circle.pos, radius
			):
				if currently_selected != null:
					currently_selected.color = default_color
				if currently_selected == null or is_connection_valid(currently_selected.pos, circle.pos):
					main_line.add_point(circle.pos)
					currently_selected = circle
					circle.color = Color.RED
					queue_redraw()
				
				
		


func _draw() -> void:
	for circle in circles:
		draw_circle(circle.pos, circle.radius, circle.color)
#	for line in lines:
#		var start = line
#		draw_line()
