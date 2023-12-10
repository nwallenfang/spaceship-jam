shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

#include "res://Shaders/lib.gdshaderinc"

uniform vec4 base_color_fuel : source_color;
uniform vec4 base_color_particle : source_color;
uniform vec4 base_color_particle2 : source_color;
uniform vec4 base_color_empty : source_color;
uniform vec4 base_color_blinking : source_color;
uniform float roughness : hint_range(0,1);
uniform float progress : hint_range(0.0, 1.0);
uniform float blink_amount : hint_range(0.0, 1.0);
uniform float time_scale = 1.0;
uniform sampler2D wave_noise;
uniform sampler2D scatter_noise;

float is_on_diagonal_stripe(vec2 pos, float x, float y, float width) {
	return float(mod(pos.x * x + pos.y * y, 1.0) < width);
}

void fragment() {
	float time = TIME * time_scale;
	float wave = texture(wave_noise, vec2(UV.x * .5+ time* .8, time * .1)).r - .5;
	float liquid_border = float(UV.y < progress + wave * .035 + sin(time*1.0) * .02);
	float blinking_border = float(UV.y > progress - blink_amount);
	
	vec3 color_fuel = mix(base_color_fuel.rgb, base_color_particle.rgb, float(texture(scatter_noise, vec2(UV.x * .1 + time * .01, UV.y-time *.3)).r > .9));
	color_fuel = mix(color_fuel, base_color_particle2.rgb, float(texture(scatter_noise, vec2(UV.x * .07 + time * .01, UV.y * .7-time *.32)).r > .9));
	vec3 color_empty = base_color_empty.rgb;
	float blink_energy = clamp_and_map(sin(time * 15.0), -1, 1, .7, .9);
	float blink_w = clamp_and_map(sin(time * 15.0), -1, 1, .85, 1.15);
	float fade_top = clamp_and_map(blink_amount, 0, .07, 0.0, 1.0);
	vec3 color_blinking = mix(color_fuel, base_color_blinking.rgb, blinking_border * is_on_diagonal_stripe(UV, 6, 40, .7 * blink_w) * blink_energy* fade_top);
	
	ALBEDO = mix(color_empty, color_blinking, liquid_border );
	EMISSION = ALBEDO;
	ROUGHNESS = roughness;
}
