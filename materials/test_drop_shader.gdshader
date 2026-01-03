shader_type spatial;

render_mode unshaded;

uniform sampler2D color_palette_a;
uniform sampler2D color_palette_b;

uniform float palette_lerp = 0;

uniform float darkness = 1;

varying vec3 local_position;

vec3 color(float t)
{
	vec3 color_a = texture(color_palette_a, vec2(t, 0)).rgb;
	vec3 color_b = texture(color_palette_b, vec2(t, 0)).rgb;
	return mix(color_a, color_b, palette_lerp);
}

void vertex() {
	VERTEX = vec3(mod(VERTEX.r + -TIME, 2) + VERTEX.r, mod(VERTEX.g, 2) + VERTEX.g, mod(VERTEX.b, 2) + VERTEX.b);
	local_position = VERTEX;
}


void fragment() {
	vec2 xy_plane = local_position.xy;
	float dist = length(xy_plane);

	float angle = atan(xy_plane.y, xy_plane.x);
	float normalized_angle = angle / (2. * PI) + 0.5;
	normalized_angle += local_position.z / 12. + sin(TIME + dist * 1.) * 0.25;

	vec3 col = color(-normalized_angle * 2.);
	col = pow(col, vec3(5. * darkness));
	ALBEDO = col;
	// ALBEDO = vec3(xy_plane, 0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
