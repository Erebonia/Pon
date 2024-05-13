shader_type canvas_item;

uniform bool active = false;
uniform float outline_width = 1.0; // Width of the outline in pixels

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    vec4 outline_color = vec4(1.0, 0.0, 0.0, 1.0); // Fully opaque red outline
    vec4 result_color = original_color;

    if (active && original_color.a < 0.1) {
        // Check pixels around the current one to detect edges
        bool is_edge = false;
        for (int x = -1; x <= 1; x++) {
            for (int y = -1; y <= 1; y++) {
                if (x == 0 && y == 0) continue; // Skip the center pixel itself
                vec2 offset = vec2(float(x), float(y)) * outline_width * TEXTURE_PIXEL_SIZE;
                vec4 neighbor_color = texture(TEXTURE, UV + offset);
                // Edge detection condition: looking for opaque neighbors
                if (neighbor_color.a > 0.1) {
                    is_edge = true;
                }
            }
        }

        // Apply outline color if the current pixel is next to an edge
        if (is_edge) {
            result_color = outline_color;
        }
    }

    COLOR = result_color;
}
