// NOTE: Shader automatically converted from Godot Engine 4.3.beta2's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx, unshaded;

uniform vec4 albedo : source_color;
uniform float alpha : hint_range(0.0, 1.0, 0.125);

void fragment() {
	vec2 base_uv = UV;

	ALBEDO = albedo.rgb;
	ALPHA = alpha;
}
