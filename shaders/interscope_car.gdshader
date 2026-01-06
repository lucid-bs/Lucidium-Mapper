// NOTE: Shader automatically converted from Godot Engine 4.3.dev5's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;

void fragment() {
	ALBEDO = albedo.rgb;

	METALLIC = 0.31;
	SPECULAR = 0.5;

	ROUGHNESS = 0.291;
}
