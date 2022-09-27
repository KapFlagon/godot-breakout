extends GutTest

var _BrickGenerator = load("res://game_objects/brick_generator.gd")
var _brick_generator_instance: BrickGenerator



# Test setup functions 
func before_all() -> void:
	gut.p("ran run setup", 2)


func before_each() -> void:
	_brick_generator_instance = _BrickGenerator.new()
	gut.p("ran setup", 2)



# Test teardown functions 
func after_all() -> void:
	gut.p("ran run teardown", 2)


func after_each() -> void:
	_brick_generator_instance.free()
	gut.p("ran teardown", 2)



# Tests 
func test_generated_and_not_null() -> void:
	assert_not_null(_brick_generator_instance, "Brick generated created successfully")
	


func test_generates_brick_with_parameters() -> void:
	var sample_colour := Color.blue
	var sample_score: int = 50
	var brick: Brick = _brick_generator_instance._generate_brick(sample_colour, sample_score)
	assert_eq(brick.get_base_colour(), sample_colour)
	assert_eq(brick.get_score_value(), sample_score)
	brick.free()


func test_generates_yellow_brick() -> void:
	var yellow_colour := Color.yellow
	var yellow_score: int = 1
	var yellow_brick: Brick = _brick_generator_instance.generate_yellow_brick()
	assert_eq(yellow_brick.get_base_colour(), yellow_colour)
	assert_eq(yellow_brick.get_score_value(), yellow_score)
	yellow_brick.free()


func test_generates_green_brick() -> void:
	var green_colour := Color.green
	var green_score: int = 3
	var green_brick: Brick = _brick_generator_instance.generate_green_brick()
	assert_eq(green_brick.get_base_colour(), green_colour)
	assert_eq(green_brick.get_score_value(), green_score)
	green_brick.free()


func test_generates_orange_brick() -> void:
	var orange_colour := Color.orange
	var orange_score: int = 5
	var orange_brick: Brick = _brick_generator_instance.generate_orange_brick()
	assert_eq(orange_brick.get_base_colour(), orange_colour)
	assert_eq(orange_brick.get_score_value(), orange_score)
	orange_brick.free()


func test_generates_red_brick() -> void:
	var red_colour := Color.red
	var red_score: int = 7
	var red_brick: Brick = _brick_generator_instance.generate_red_brick()
	assert_eq(red_brick.get_base_colour(), red_colour)
	assert_eq(red_brick.get_score_value(), red_score)
	red_brick.free()
