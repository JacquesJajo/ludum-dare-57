shader_type canvas_item;

uniform float outerRadius : hint_range(0.0, 5.0) = 1.0;
uniform int steps;
uniform int max_steps;
uniform vec4 fade: source_color;

void fragment() {
	float x = abs(UV.x-0.5)*2.0;
	float y = abs(UV.y-0.5)*2.0;
	float v = (sqrt((x*x)+(y*y))/outerRadius);
	COLOR = vec4(fade.rgb, v * (1.0 - float(steps)/float(max_steps)));
}
