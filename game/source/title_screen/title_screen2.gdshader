shader_type canvas_item;

uniform vec4 flash_color : source_color;
uniform float flash_value : hint_range(0.0, 1.0, 0.05);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR = mix(texture_color, flash_color, flash_value);
	COLOR.a = texture_color.a;
}