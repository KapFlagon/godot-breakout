extends Camera2D

class_name ShakeableCamera


var _intensity = 0.0
var _duration = 0.0
var _noise: OpenSimplexNoise


# Virtual functions
func _ready() -> void:
	_noise = OpenSimplexNoise.new()
	_noise.set_seed(randi())
	_noise.set_octaves(4)
	_noise.set_period(20)
	_noise.set_persistence(0.8)


func _process(delta) -> void:
	if _duration <= 0:
		self.set_offset(Vector2.ZERO)
		_intensity = 0.0
		_duration = 0.0
		return
	
	_duration = _duration - delta
	
	var new_offset = Vector2.ZERO
	var noise_value_x = _noise.get_noise_1d(OS.get_ticks_msec() * 0.1)
	var noise_value_y = _noise.get_noise_1d(OS.get_ticks_msec() * 0.1 + 100.0)
	new_offset = Vector2(noise_value_x, noise_value_y) * _intensity * 2.0
		
	self.set_offset(new_offset)


# Public functions 
func shake(thing, new_intensity: float, new_duration: float) -> void:
	if new_intensity > _intensity and new_duration > _duration:
		_intensity = new_intensity
		_duration = new_duration
	else:
		_intensity += new_intensity
		_duration += new_duration


# Private functions
