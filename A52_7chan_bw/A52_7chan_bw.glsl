\uniform float adsk_result_w, adsk_result_h;
vec2 resolution = vec2(adsk_result_w, adsk_result_h);

uniform sampler2D Source;
uniform float Exposure;
uniform float amount;

// start of prog
uniform float Red;
uniform float Green;
uniform float Blue;

// for adding cmyk > will need to be added to the xml (UI) - sg
uniform float Cyan;
uniform float Magenta;
uniform float Yellow;

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}


void main (void) // need to add the cmyk part - sg
{ 		
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec4 tc = texture2D(Source, uv);
	vec3 fragRGB = tc.rgb;
	vec3 fragHSV = rgb2hsv(fragRGB.xyz);
	
	if (fragHSV.x <= 30) // First half of RED
	{
		fragHSV.y -= Red;
	}
	else if (fragHSV.x <= 90) // YELLOW
	{
		fragHSV.y -= Yellow;
	}
	else if (fragHSV.x <= 150) // GREEN
	{
		fragHSV.y -= Green;
	}
	else if (fragHSV.x <= 210) // CYAN
	{
		fragHSV.y -= Cyan;
	}
	else if (fragHSV.x <= 270) // BLUE
	{
		fragHSV.y -= Blue;
	}
	else if (fragHSV.x <= 330) // MAGENTA
	{
		fragHSV.y -= Magenta;
	}
	else // Last half of RED
	{
		fragHSV.y -= RED;
	}
	
	//fragHSV.xyz = min(max(0.0, fragHSV.xyz), 1.0);
	fragRGB = hsv2rgb(fragHSV);

	gl_FragColor = vec4(fragRGB, amount);//mix(tc.rgb, fragRGB, amount);
}
