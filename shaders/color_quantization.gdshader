shader_type spatial;

render_mode unshaded;
uniform vec3[16] pallate : source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

void vertex() {
    // Called for every vertex the material is visible on.
}

void fragment() {
    vec3 color_mix = texture(SCREEN_TEXTURE, SCREEN_UV,  1).rgb;

    // Initialize the closest color and its distance to a very high value.
    vec3 closest_color = vec3(0.0);
    float closest_distance =  1000.0;

    // Loop through each color in the palette.
    for (int i =  0; i < pallate.length(); i++) {
        // Calculate the distance between the current color and the input color.
        float distance = distance(color_mix, pallate[i]);

        // If this color is closer than the current closest color, update the closest color and its distance.
        if (distance < closest_distance) {
            closest_color = pallate[i];
            closest_distance = distance;
        }
    }

    // Set the final color to the closest color in the palette.
    ALBEDO = closest_color;
}