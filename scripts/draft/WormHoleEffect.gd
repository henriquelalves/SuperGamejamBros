extends ColorRect

export(float) var time_multiplier : float = 1.0
var current_time : float
var shader_material : ShaderMaterial
var shaking : bool = false
var shake_center_position : Vector2
var shake_target_position : Vector2

func setup():
	current_time = 0.0
	time_multiplier = 1.0
	shader_material = get_material()

func start_shake(duration : float, shaking_duration : float):
	shaking = true
	shake_center_position = Vector2(0.5,0.5)
	var timer = 0.0
	while (timer < duration):
		timer += shaking_duration
		var delta = timer / duration * 0.3
		shake_target_position = Vector2((0.5 - delta/2) + randf()*delta, (0.5 - delta/2) + randf()*delta)
		yield(get_tree().create_timer(0.1),"timeout")
	shaking = false

func _process(delta):
	current_time += delta * time_multiplier
	shader_material.set_shader_param("time_override", current_time)
	
	if shaking:
		shake_center_position = lerp(shake_center_position,shake_target_position, 0.1)
		shader_material.set_shader_param("worm_hole_origin", shake_center_position)
