uniform sampler2D u_ScreenImageMap;
uniform sampler2D u_ScreenDepthMap;

uniform int u_PixelSize;
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
    const float NOISE_FREQUENCY = 0.6;
    const vec4 TINT_COLOR = vec4(0.89, 1, 1, 1);

    vec2 texSize = textureSize(u_ScreenImageMap, 0).xy;
    vec2 depthSize = textureSize(u_ScreenDepthMap, 0).xy;
    vec4 depth = texture(u_ScreenDepthMap, gl_FragCoord.xy / depthSize);

    vec2 texCoords = gl_FragCoord.xy;

    if(depth.a <= 0) return;

    float x = int(texCoords.x) % u_PixelSize;
    float y = int(texCoords.y) % u_PixelSize;

    x = floor(u_PixelSize / 2.0) - x;
    y = floor(u_PixelSize / 2.0) - y;

    x = x + texCoords.x;
    y = y + texCoords.y;

    vec2 coord = vec2(x, y);

    vec4 sample = texture(u_ScreenImageMap, coord / texSize);

    float noise = n8rand(coord + 0.07 * u_Time);

    vec4 lumSample = grayscale(sample);

    vec4 tinted = lumSample * TINT_COLOR;

    vec4 outSample = mix(tinted, vec4(1.0), noise * NOISE_FREQUENCY);

    gl_FragColor = outSample;
}
