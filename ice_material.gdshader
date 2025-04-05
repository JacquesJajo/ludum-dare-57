shader_type canvas_item;

uniform float breakage;
uniform vec4 fade: source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (COLOR.a == 0.0) {
		// do nothing
	}
	else {
		COLOR = mix(COLOR, fade, breakage);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
