extends ColorRect

export(float) var time_multiplier : float = 1.0
var current_time : float
var shader_material : ShaderMaterial

func setup():
	current_time = 0.0
	time_multiplier = 1.0
	shader_material = get_material()

func _process(delta):
	current_time += delta * time_multiplier
	shader_material.set_shader_param("time_override", current_time)
