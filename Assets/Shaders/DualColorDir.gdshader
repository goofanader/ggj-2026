shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

group_uniforms Value_1;
uniform vec4 input_color_1 : source_color = vec4(1.0);
uniform int color_mode_1 : hint_enum("Replace","Multiply","Add","Devide","Subtract","Multiply (Greyscale)","Devide (Greyscale)","Average","Max","Min","Ignore") = 1;
uniform int alpha_mode_1 : hint_enum("Same as Color","Overlay Top","Overlay Bottom","Ignore") = 3;
uniform vec2 start_pos_1 = vec2(0.0,0.0);
uniform vec2 normal_dir_1 = vec2(0.0,1.0);
uniform bool mirrored_dir_1 = false;
uniform bool flipped_dir_1 = false;
uniform float input_value_1 : hint_range(0.0, 1.0) = 0.0;

group_uniforms Value_2;
uniform vec4 input_color_2 : source_color = vec4(1.0);
uniform int color_mode_2 : hint_enum("Replace","Multiply","Add","Devide","Subtract","Multiply (Greyscale)","Devide (Greyscale)","Average","Max","Min","Ignore") = 1;
uniform int alpha_mode_2 : hint_enum("Same as Color","Overlay Top","Overlay Bottom","Ignore") = 3;
uniform vec2 start_pos_2 = vec2(0.0,0.0);
uniform vec2 normal_dir_2 = vec2(0.0,1.0);
uniform bool mirrored_dir_2 = false;
uniform bool flipped_dir_2 = false;
uniform float input_value_2 : hint_range(0.0, 1.0) = 0.0;

group_uniforms Other_Settings;
uniform vec3 greyscale_weights = vec3(0.299,0.587,0.114);

bool is_active(vec2 pos, vec2 start_pos, vec2 normal_dir, bool mirrored_dir, bool flipped_dir, float value) {
	float val = dot(pos-start_pos,normal_dir);
	val = (mirrored_dir) ? abs(val)*2.0 : val;
	return (flipped_dir) ? val > value : val < value;
}

vec3 blend(int mode, vec3 ref, vec3 input) {
	switch (mode) {
		case 0: return input;
		case 1: return ref*input;
		case 2: return ref+input;
		case 3: return ref/input;
		case 4: return ref-input;
		case 5: return dot(ref,greyscale_weights)*input;
		case 6: return dot(ref,greyscale_weights)/input;
		case 7: return (ref+input)/2.0;
		case 8: return max(ref,input);
		case 9: return min(ref,input);
		default: return ref;
	}
}
float blend(int mode, float ref, float input) {
	switch (mode) {
		case 0: return input;
		case 1: return ref*input;
		case 2: return ref+input;
		case 3: return ref/input;
		case 4: return ref-input;
		case 5: return ref*input;
		case 6: return ref/input;
		case 7: return (ref+input)/2.0;
		case 8: return max(ref,input);
		case 9: return min(ref,input);
		default: return ref;
	}
}

vec4 apply(bool active, int color_mode, int alpha_mode, vec4 ref, vec4 input) {
	if (active) {
		vec4 ans;
		ans.rgb = blend(color_mode,ref.rgb,input.rgb);
		switch (alpha_mode) {
			case 0: ans.a = blend(color_mode,ref.a,input.a); break;
			case 1:
				ans.a = clamp(ref.a+input.a,0.0,1.0);
				ans.rgb = (ans.rgb*input.a + ref.rgb*(1.0-input.a))/ans.a;
				break;
			case 2:
				ans.a = clamp(ref.a+input.a,0.0,1.0);
				ans.rgb = (ref.rgb*input.a + ans.rgb*(1.0-input.a))/ans.a;
				break;
			default:
				ans.a = ref.a;
				break;
		}
		return ans;
	} else {
		return ref;
	}
}

void fragment() {
	COLOR = apply(
		is_active(UV,start_pos_1,normal_dir_1,mirrored_dir_1,flipped_dir_1,input_value_1),
		color_mode_1, alpha_mode_1, texture(screen_texture,SCREEN_UV), input_color_1);
	COLOR = apply(
		is_active(UV,start_pos_2,normal_dir_2,mirrored_dir_2,flipped_dir_2,input_value_2),
		color_mode_2, alpha_mode_2, COLOR, input_color_2);
}