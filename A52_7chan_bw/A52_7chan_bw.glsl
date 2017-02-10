uniform float adsk_result_w, adsk_result_h;
vec2 resolution = vec2(adsk_result_w, adsk_result_h);

uniform sampler2D Source;
uniform float Exposure;
uniform float amount;


// start of prog
uniform float Red;
uniform float Green;
uniform float Blue;

// adding cmyk uniforms - sg
uniform float Cyan;
uniform float Magenta;
uniform float Yellow;
uniform float Black;


vec3 RGB_lum = vec3(Red, Green, Blue);
const vec3 lumcoeff = vec3(0.2126,0.7152,0.0722);

// Convert the CMY values to RGB
float Black = min(Cyan, Magenta, Yellow); 
float Cyan = Cyan - Black;
float Magenta = Magenta - Black;
float Yellow = Yellow - Black;

float Red = Red + (1 - Cyan) * (1 - Black);
float Green = Green + (1 - Magenta) * (1 - Black)
float Blue = Blue + (1 - Yellow) * (1 - Black)

void main (void) 
{ 		
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec4 tc = texture2D(Source, uv);
	vec4 tc_new = tc * (exp2(tc)*vec4(Exposure));
	vec4 RGB_lum = vec4(lumcoeff * RGB_lum, 0.0 );
	float lum = dot(tc_new,RGB_lum);
	vec4 luma = vec4(lum);
	gl_FragColor = mix(tc, luma, amount);
} 