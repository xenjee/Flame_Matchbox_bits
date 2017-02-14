//Autodesk Variables
uniform float adsk_result_w, adsk_result_h;
vec2 resolution = vec2(adsk_result_w, adsk_result_h);

uniform sampler2D Source;
uniform float amount; // Affects the amount of blending between the original image and the desaturated one.

// Color Sliders
uniform float Red;
uniform float Green;
uniform float Blue;
uniform float Cyan;
uniform float Magenta;
uniform float Yellow;
uniform float Exposure;

vec3 hsl2rgb( in vec3 c ){
    vec3 rgb = clamp( abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),6.0)-3.0)-1.0, 0.0,1.0);
    return c.z + c.y * (rgb-0.5)*(1.0-abs(2.0*c.z-1.0));
}

vec3 rgb2hsl( in vec3 c )
{
    const float epsilon = 0.00000001;
    float cmin = min( c.r, min( c.g, c.b ) );
    float cmax = max( c.r, max( c.g, c.b ) );
    float cd   = cmax - cmin;
    vec3 hsl = vec3(0.0);
    hsl.z = (cmax + cmin) / 2.0;
    hsl.y = mix(cd / (cmax + cmin + epsilon), cd / (epsilon + 2.0 - (cmax + cmin)), step(0.5, hsl.z));
    
    // Special handling for the case of 2 components being equal and max at the same time,
    // this can probably be improved but it is a nice proof of concept
    vec3 a = vec3(1.0 - step(epsilon, abs(cmax - c)));
    a = mix(vec3(a.x, 0.0, a.z), a, step(0.5, 2.0 - a.x - a.y));
    a = mix(vec3(a.x, a.y, 0.0), a, step(0.5, 2.0 - a.x - a.z));
    a = mix(vec3(a.x, a.y, 0.0), a, step(0.5, 2.0 - a.y - a.z));
    
    hsl.x = dot( vec3(0.0, 2.0, 4.0) + ((c.gbr - c.brg) / (epsilon + cd)), a );
    hsl.x = (hsl.x + (1.0 - step(0.0, hsl.x) ) * 6.0 ) / 6.0;
    return hsl;
}

float blendColorEffect(in float color1, in float color2, in float percentage)
{
    return color1 + percentage*(color2-color1);
}


void main (void)
{
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    vec4 tc = texture2D(Source, uv);
    vec3 fragRGB = tc.rgb;
	vec3 fragHSL = rgb2hsl(fragRGB.xyz);
	
	if (fragHSL.x <= 30.0/360.0) // First half of RED
	{
        fragHSL.y -= blendColorEffect(Red, (Red+Yellow)/2.0, fragHSL.x/(30.0/360.0));
	}
    else if (fragHSL.x <= 90.0/360.0) // YELLOW
	{
		fragHSL.y -= blendColorEffect((Red+Yellow)/2.0, (Yellow+Green)/2.0, (fragHSL.x-(30.0/360.0))/(60.0/360.0));
	}
	else if (fragHSL.x <= 150.0/360.0) // GREEN
	{
		fragHSL.y -= blendColorEffect((Yellow+Green)/2.0, (Green+Cyan)/2.0, (fragHSL.x-(90.0/360.0))/(60.0/360.0));
	}
	else if (fragHSL.x <= 210.0/360.0) // CYAN
	{
		fragHSL.y -= blendColorEffect((Green+Cyan)/2.0, (Cyan+Blue)/2.0, (fragHSL.x-(150.0/360.0))/(60.0/360.0));
	}
	else if (fragHSL.x <= 270.0/360.0) // BLUE
	{
		fragHSL.y -= blendColorEffect((Cyan+Blue)/2.0, (Blue+Magenta)/2.0, (fragHSL.x-(210.0/360.0))/(60.0/360.0));
	}
	else if (fragHSL.x <= 330.0/360.0) // MAGENTA
	{
		fragHSL.y -= blendColorEffect((Blue+Magenta)/2.0, (Magenta+Red)/2.0, (fragHSL.x-(270.0/360.0))/(60.0/360.0));
	}
	else // Last half of RED
	{
		fragHSL.y -= blendColorEffect((Magenta+Red)/2.0, Red, (fragHSL.x-(330.0/360.0))/(30.0/360.0));
	}
    
    //fragHSV = min(max(vec3(0.0,0.0,0.0), fragHSL.xyz), vec3(1.0, 1.0, 1.0));
    fragRGB = hsl2rgb(fragHSL);
    
    gl_FragColor = mix(tc, vec4(fragRGB, 1.0), amount);
}
