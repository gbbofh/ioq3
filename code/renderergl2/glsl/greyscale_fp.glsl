uniform sampler2D u_ScreenImageMap;

varying vec2   var_ScreenTex;

vec4 decompose(vec4 sample)
{
    float lum;

#ifdef MIN_DECOMP

    lum = min(min(sample.r, sample.g), sample.b);

#else

    lum = max(max(sample.r, sample.g), sample.b);

#endif

    return vec4(lum, lum, lum, 1);
}

void main()
{
    vec4 sample = texture(u_ScreenImageMap, var_ScreenTex);

    return decompose(sample);
}
