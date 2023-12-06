shader_type fog;

group_uniforms Color;
uniform vec3 albedo: source_color;
uniform float emission_strength;
uniform vec3 emission_color: source_color;

group_uniforms Density;
uniform float density = 1.0;
uniform sampler3D noise;

group_uniforms Dynamics;
uniform float speed = 1.0;
uniform sampler2D time_noise;

void fog() {
	// TODO emission strength based on distance from center :) 
	vec3 pos = WORLD_POSITION - OBJECT_POSITION;
	float center_distance = distance(vec3(0.5), UVW);
	float size = SIZE.x * SIZE.y * SIZE.z;
	
	DENSITY = density; // texture(noise, pos * 10.0).r; // UVW + vec3(1.0, -1.0, 0.5) * TIME * speed).r;
	ALBEDO = albedo;
	EMISSION = emission_strength * emission_color;
	
	
	
	
	
	
	
	
}
