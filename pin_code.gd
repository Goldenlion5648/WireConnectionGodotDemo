extends Node2D

@export var allow_crossed_wires = true
@export var only_cardinals = false


const Circle = preload("res://circle.gd")



# Called when the node enters the scene tree for the first time.
var circles: Array[Circle] = []
var correct_sequence = Line2D.new()
var is_correct = false
var correct_color = null

var spacing = 150
var radius = 36
var side_offset = 100
var currently_selected = null
var default_color = Color.GREEN

var main_line = Line2D.new()

var good_line_color = Color.BLACK
var bad_line_color = Color.RED
var most_recent_color = Color.BLACK

var solved_color = Color.PURPLE

func _ready() -> void:
	if not Globals.has_setup:
		Globals.allow_crossed_wires = allow_crossed_wires
		Globals.only_cardinals = only_cardinals
		Globals.has_setup = true
	
	add_child(main_line)
#	main_line.add_point(Vector2(side_offset,side_offset))
#	main_line.add_point(Vector2(side_offset+spacing,side_offset+spacing))
	
	for y in range(3):
		for x in range(3):
			circles.append(Circle.new(
						Vector2(x*spacing+side_offset, 
								y*spacing+side_offset), 
								radius, default_color))
	for i in [0, 1, 4, 2, 5, 8, 7, 3, 6]:
		correct_sequence.add_point(circles[i].pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	allow_crossed_wires = Globals.allow_crossed_wires
	only_cardinals = Globals.only_cardinals

func is_connection_valid(start: Vector2, end: Vector2):
	if not allow_crossed_wires:
		var bad = false
		for i in range(main_line.points.size()-1):
			if Geometry2D.segment_intersects_segment(
						main_line.get_point_position(i), 
						main_line.get_point_position(i+1),
						start, end
			) != null and main_line.get_point_position(i+1) != start:
				bad = true
				break
		if bad:
			return false
	
	if only_cardinals and not (start.x == end.x or start.y == end.y):
		return false
	
	for circle in circles:
		if circle.pos == start or circle.pos == end:
			continue
		if main_line.points.has(end):
			return false

		if Geometry2D.segment_intersects_circle(start, end, circle.pos, circle.radius) >= 0:
#			prints("returning false", start, end, circle.pos, circle.radius)
			return false
	return true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	
	if Input.is_action_pressed("select"):
		for circle in circles:
			if Geometry2D.is_point_in_circle(
						get_local_mouse_position(), 
						circle.pos, radius
			):
				if currently_selected != null:
					currently_selected.color = default_color
				if currently_selected == null or is_connection_valid(currently_selected.pos, 
													circle.pos):
					main_line.add_point(circle.pos)
					currently_selected = circle
					circle.color = Color.RED
					queue_redraw()
				
func blink_color():
	for i in range(10):
		correct_color = solved_color
		await get_tree().create_timer(.6).timeout
		correct_color = null
		await get_tree().create_timer(.6).timeout

func _draw() -> void:
	if not is_correct and main_line.points == correct_sequence.points:
		is_correct = true
		print("is_correct", is_correct)
		blink_color()
		
	for circle in circles:
		if correct_color == null:
			draw_circle(circle.pos, circle.radius, circle.color)
		else:
			draw_circle(circle.pos, circle.radius, correct_color)
			
#	for line in lines:
#		var start = line
#		draw_line()
