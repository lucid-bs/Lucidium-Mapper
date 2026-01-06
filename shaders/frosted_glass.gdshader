/*
©Lunar Candor
https://lunarcandor.itch.io/
This work is licensed under a Creative Commons Attribution 4.0 International (CC-BY 4.0 Intl.) License.
https://creativecommons.org/licenses/by/4.0/
*/

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4 g_color : source_color = vec4(1.0, 1.0, 1.0, 0.25);
uniform float g_blur: hint_range(0.0, 6.0) = 1.0;

void fragment(){
	vec3 color_mix = texture(SCREEN_TEXTURE, SCREEN_UV, g_blur).rgb;
	color_mix = mix(color_mix, g_color.rgb, g_color.a);
	COLOR = vec4(color_mix, 1.0);
}
