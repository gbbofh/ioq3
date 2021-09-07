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

vec4 distort(sampler2D color, vec2 coord)
{
    vec4 sample = pixelate(color, coord);

    return sample;
}

void main()
{
    vec2 texSize = textureSize(u_ScreenDepthMap, 0).xy;
    vec4 depth = texture(u_ScreenDepthMap, gl_FragCoord.xy / texSize);

    if(depth.a <= 0) return;

    gl_FragColor = distort(u_ScreenImageMap, gl_FragCoord);
}
