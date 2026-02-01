//https://godotshaders.com/shader/2d-outline-inline/
shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);
uniform bool ito = true;
uniform float width: hint_range(0.0,0.5) = 0.0;


void fragment() {
	if ((ito && (abs(UV.x-0.5) < width)) || (abs(UV.x-0.5) > width)){
		float s = 0.2126*COLOR.r + 0.7152*COLOR.g + 0.0722*COLOR.b;
		COLOR.rgb = vec3(color.r*s,color.g*s,color.b*s);
	}
}