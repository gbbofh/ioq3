uniform sampler2D u_ScreenImageMap;
uniform sampler2D u_ScreenDepthMap;
uniform int u_PixelSize;

varying vec2   var_ScreenTex;

vec4 pixelate(sampler2D color, vec2 coord)
{
    vec2 texSize = textureSize(color, 0).xy;

    float x = int(coord.x) % u_PixelSize;
    float y = int(coord.y) % u_PixelSize;

    x = floor(u_PixelSize / 2.0) - x;
    y = floor(u_PixelSize / 2.0) - y;

    x = x + coord.x;
    y = y + coord.y;

    return texture(color, vec2(x, y) / texSize);
}

vec4 grayscale(vec4 sample)
{
    float maxColor = max(sample.r, max(sample.g, sample.b));

    return vec4(maxColor, maxColor, maxColor, 1);
}

#if 0
vec4 tint_sample(vec4 sample, vec4 color, float amount)
{
    return mix(sample, color, amount);
}
#endif

vec4 distort(sampler2D color, vec2 coord)
{
    const vec4 tintColor = vec4(0, 1, 0, 1);
    const float tintAmount = 0.25;

    vec4 sample = pixelate(color, coord);
    vec4 lum = grayscale(sample);

#if 0
    sample = tint_sample(sample, tintColor, tintAmount);
#endif

    // Randomize luminance of the pixel
    // https://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl
    vec3 noise_in = vec3(coord, time);
    uint bitPattern = floatBitsToUint(lum.r);
    uint hash = bitPattern;

    hash += (hash << 10u);
    hash ^= (hash >> 6u);
    hash += (hash << 3u);
    hash ^= (hash >> 11u);
    hash += (hash << 15u);

    bitPattern = hash & 0x007FFFFFu;
    bitPattern |= 0x3F800000u;

    // float fNoise = uintBitsToFloat(bitPattern) - 1.0;

    // vec4 noise = vec4(fNoise, fNoise, fNoise, 1.0);

    float noise = uintBitsToFloat(bitPattern) - 1.0;

    return mix(sample, vec4(1, 1, 1, 1), noise);
}

void main()
{
    vec2 texSize = textureSize(u_ScreenDepthMap, 0).xy;
    vec4 depth = texture(u_ScreenDepthMap, gl_FragCoord.xy / texSize);

    if(depth.a <= 0) return;

    gl_FragColor = distort(u_ScreenImageMap, gl_FragCoord.xy);
}
