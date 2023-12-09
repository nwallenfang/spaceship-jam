shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform float roughness : hint_range(0,1);

uniform sampler2D wave_noise;

void fragment() {
	ALBEDO = albedo.rgb;
	ROUGHNESS = roughness;
}
