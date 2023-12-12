shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap; 

void fragment()
{
    vec4 color;
    
	vec2 uv = SCREEN_UV;
    
    float distanceFromCenter = length( uv - vec2(0.5,0.5) );
    
    float vignetteAmount;
    
    float lum;
    
    vignetteAmount = 1.0 - distanceFromCenter;
    vignetteAmount = smoothstep(0.4, 1.0, vignetteAmount);
    
    color = texture(screen_texture, uv);
    
    // luminance hack, responses to red channel most
    lum = dot(color.rgb, vec3( 0.85, 0.30, 0.10) );
    
    color.rgb = vec3(0.0, lum, 0.0);
    
    // scanlines
    color += 0.1*sin(uv.y / SCREEN_PIXEL_SIZE.y * 2.0);
    
    // screen flicker
    color += 0.005 * sin(TIME * 16.0);
    
    // vignetting
    color.rgb *=  vignetteAmount * 1.0;
    
	COLOR = color;
}
