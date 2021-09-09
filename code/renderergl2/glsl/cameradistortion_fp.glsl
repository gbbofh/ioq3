#define GRAYSCALE_MASK	(0x00000001)
#define TINTCOLOR_MASK	(0x00000002)
#define NOISE_MASK	(0x00000004)

uniform sampler2D u_ScreenImageMap;
uniform sampler2D u_ScreenDepthMap;

uniform vec4 u_ViewInfo;	// paramBitmask, pixelSize, width, height
uniform vec4 u_Color;       // Color tint
uniform float u_Time;

varying vec2   var_ScreenTex;

// Noise functions from:
// https://www.shadertoy.com/view/MlVSzw

float nrand( vec2 n )
{
	return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}


float n8rand( vec2 n )
{
    float t = fract( u_Time );
    float nrnd0 = nrand( n + 0.07*t );
    float nrnd1 = nrand( n + 0.11*t );	
    float nrnd2 = nrand( n + 0.13*t );
    float nrnd3 = nrand( n + 0.17*t );
    
    float nrnd4 = nrand( n + 0.19*t );
    float nrnd5 = nrand( n + 0.23*t );
    float nrnd6 = nrand( n + 0.29*t );
    float nrnd7 = nrand( n + 0.31*t );
    
    return (nrnd0+nrnd1+nrnd2+nrnd3 +nrnd4+nrnd5+nrnd6+nrnd7) / 8.0;
}


// Calculate min decomposition of the given sample 
vec4 grayscale(vec4 sample)
{
    float minColor = min(sample.r, min(sample.g, sample.b));

    return vec4(minColor, minColor, minColor, 1);
}

void main()
{
    // Rather than add two new uniforms,
    // the parameters to the shader have been embedded into
    // the ViewInfo vector, since the first two elements
    // were previously unused. This could probably be
    // compressed even further, using only 1 of the 2 elements
    // But it's not worth doing unless I need to add more
    // configuration options down the line.
    // The only three things that may need to be
    // encoded are NOISE_RADIUS, NOISE_SOFT, and NOISE_FREQUENCY,
    // and they could all be represented in ~4 bits each
    // if step size is not a concern. If step size is a concern
    // then a greater number of bits would need to be used
    // to allow for more detailed control over their exact appearance
    // If this pattern of needing to allow for control over effect
    // parameters continues, it may be worthwhile to add an int or
    // ivec2/3/4 uniform(s) to tr_glsl.c and tr_local.h to facilitate
    // the passing of configuration options that way.
    int paramBits = int(u_ViewInfo.x);
    int pixelSize = int(u_ViewInfo.y);

    bool grayscaleEnabled = bool(paramBits & GRAYSCALE_MASK);
    bool tintColorEnabled = bool(paramBits & TINTCOLOR_MASK);
    bool noiseEnabled = bool(paramBits & NOISE_MASK);

    const float NOISE_RADIUS = 0.75;
    const float NOISE_SOFT = 0.5;
    const float NOISE_FREQUENCY = 0.4;
    // const vec4 TINT_COLOR = vec4(0.89, 1, 1, 1);

    vec2 texSize = textureSize(u_ScreenImageMap, 0).xy;
    vec2 depthSize = textureSize(u_ScreenDepthMap, 0).xy;
    vec4 depth = texture(u_ScreenDepthMap, gl_FragCoord.xy / depthSize);

    vec2 texCoords = gl_FragCoord.xy;

    if(depth.a <= 0) return;

    float x = int(texCoords.x) % pixelSize;
    float y = int(texCoords.y) % pixelSize;

    x = floor(pixelSize / 2.0) - x;
    y = floor(pixelSize / 2.0) - y;

    x = x + texCoords.x;
    y = y + texCoords.y;

    vec2 coord = vec2(x, y);
    vec2 resolution = u_ViewInfo.zw;
    vec2 aspect = vec2(resolution.x / resolution.y, 1.0);

    // Calculate the distance from the coordinate
    // to the center of the window
    // Multiply by the aspect ratio to account for rectangular windows
    float dist = length((coord / resolution - vec2(0.5)) * aspect);

    // Calculate a gradient value from the center of the screen
    // This, when multiplied by the other noise parameters will
    // produce a noiseless circle in the middle of the viewport.
    float noiseGradient = 1.0 - smoothstep(NOISE_RADIUS, NOISE_RADIUS - NOISE_SOFT, dist);

    vec4 sample = texture(u_ScreenImageMap, coord / texSize);

    float noise = noiseEnabled ? n8rand(coord + 0.07 * u_Time) : 0.0;

    vec4 lumSample = grayscaleEnabled ? grayscale(sample) : sample;

    // vec4 tinted = lumSample * (tintColorEnabled ? TINT_COLOR : vec4(1.0));
    vec4 tinted = lumSample * (tintColorEnabled ? u_Color : vec4(1.0));

    vec4 outSample = mix(tinted, vec4(1.0), noise * NOISE_FREQUENCY * noiseGradient);

    gl_FragColor = outSample;
}
