#version 120

#define ratio adsk_result_frameratio

uniform float ratio;
uniform float adsk_result_w, adsk_result_h;
vec2 res = vec2(adsk_result_w, adsk_result_h);
uniform float factor;  // added

uniform sampler2D Front;
uniform sampler2D Matte;

uniform bool divide;
uniform bool bypass;
uniform bool swap;


void main(void) {
	vec2 st = gl_FragCoord.xy / res;
	vec3 front = texture2D(Front, st).rgb;
	vec3 matte = texture2D(Matte, st).rgb;
	float multiplier = factor;


	//---------------------- boolean conditions
	if (swap) {
		front = texture2D(Matte, st).rgb;
		matte = texture2D(Front, st).rgb;}

	if (divide) {
		front = front / max((matte.r * multiplier), .00001);} 
		else {
		front *= (matte.r * multiplier);}
			
	if (bypass) {
		front = texture2D(Front, st).rgb;}
	//----------------------
	
	
	float alpha = mix(0.0, matte.r, multiplier);

	vec4 result = vec4(front.rgb, alpha);

	gl_FragColor = result;
}
