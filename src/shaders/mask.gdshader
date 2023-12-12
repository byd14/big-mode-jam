shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float alpha = 1.0;

void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR.a = texture(TEXTURE, UV).a * alpha;
}
