// Front passthrough for later
// lewis@lewissaunders.com  // modified by xenjee@gmail.com ** v01b

uniform sampler2D frontt;
uniform float adsk_result_w, adsk_result_h;

void main() {
	vec2 xy = gl_FragCoord.xy;
	vec2 px = vec2(1.0) / vec2(adsk_result_w, adsk_result_h);
	gl_FragColor = texture2D(frontt, xy * px);
}
