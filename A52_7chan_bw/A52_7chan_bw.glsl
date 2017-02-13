uniform float adsk_result_w, adsk_result_h;
vec2 resolution = vec2(adsk_result_w, adsk_result_h);

uniform sampler2D Source;
uniform float Exposure;
uniform float amount;


// start of prog
uniform float Red;
uniform float Green;
uniform float Blue;

// adding cmyk > to be added in UI xml as well
uniform float Cyan;
uniform float Magenta;
uniform float Yellow;
//uniform float Black; // Unneccessary. You can calculate black from CMY - tf

// Convert the CMY values to RGB
float Black = min(Cyan, Magenta, Yellow); 
float newCyan = Cyan - Black;
float newMagenta = Magenta - Black;
float newYellow = Yellow - Black;

float newRed = Red + (1 - Cyan) * (1 - Black);
float newGreen = Green + (1 - Magenta) * (1 - Black)
float newBlue = Blue + (1 - Yellow) * (1 - Black)


vec3 RGB_lum = vec3(newRed, newGreen, newBlue);
const vec3 lumcoeff = vec3(0.2126,0.7152,0.0722);

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
