// Base https://www.shadertoy.com/view/3dcXzs
// With the help of https://github.com/jospic/godot3_shaders/tree/master/sea-water
shader_type canvas_item;

const float PI = 3.141592654;

uniform vec2 screen_size;
uniform vec2 worm_hole_origin;
uniform vec4 cloud_color : hint_color;
uniform vec4 base_color : hint_color;
uniform vec4 fog_color : hint_color;
uniform float time_override;
uniform float texture_alpha;
uniform float effect_multiplier;

vec2 rot(vec2 v, float angle)
{
	return vec2(v.x * cos(angle) + v.y * sin(angle), v.y * cos(angle) - v.x * sin(angle));
}

float map(float l)
{
	float lm = 1.0;
	l = clamp(1e-1, l, l);
	float lm2 = lm * lm;
	float lm4 = lm2 * lm2;
	return sqrt(lm4 / (l * l) + lm2);
}

vec3 draw_cloud(float dis, float angle, vec2 coord, float time){
	vec3 baseColor = base_color.xyz;
	vec3 cloudColor = cloud_color.xyz;
	float x = angle + dis;
	float fre = 2.0;
	float ap = 1.0;
	float d = float(0.0);
	coord = rot(coord, 0.3 * time);
	vec3 kp = vec3(coord * max(dis, 1.0), dis);
	for (int i = 1; i < 5; i++) {
		float k = 1.0 + sin(fre * x + 0.3 * time);
		k = k * k * 0.25;
		float p = fract(k + dis / float(i + 1));
		p = p * (1.0 - p);
		p = smoothstep(0.1, 0.25, p);
		d += ap * p;
		kp += sin(kp.zxy * 0.75 * fre + 0.3 * time);
		d -= abs(dot(cos(kp), sin(kp.yzx)) * ap);
		fre *= -2.0;
		ap *= 0.5;
	}
	float len2=dot(coord,coord);
	d+=len2*4.0;
	return baseColor + cloudColor * d;
}

vec3 render(vec2 coord, float time){
    float len = length(coord);
    float angle = PI - acos(coord.x / len) * sign(coord.y);

    vec3 baseColor = vec3(0.0, 0.0, 0.0);
    float dis = map(len);
    baseColor += draw_cloud(dis, angle, coord, time) * 0.3;
    float fogC = pow(0.97, dis);
    baseColor = mix(fog_color.xyz, baseColor, fogC);
    return baseColor;
}

void fragment(){
	vec2 coord = UV - (worm_hole_origin);

	if (screen_size.y > screen_size.x) {
		coord.x *= screen_size.x / screen_size.y;
	} else {
		coord.y /= screen_size.x / screen_size.y;
	}
	
	vec3 baseColor;
	if (time_override > 0.0){
		baseColor = render(coord, time_override);
	} else {
		baseColor = render(coord, TIME);
	}
	
	COLOR = vec4(baseColor*effect_multiplier, texture_alpha);
}