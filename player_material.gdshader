shader_type canvas_item;

uniform int steps;
uniform int max_steps;
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
		COLOR = mix(fade, COLOR, float(steps)/float(max_steps));
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
