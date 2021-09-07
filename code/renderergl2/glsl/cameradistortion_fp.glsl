uniform sampler2D u_ScreenImageMap;
uniform int u_PixelSize;

varying vec2   var_ScreenTex;

void main()
{
    vec2 texSize = textureSize(u_ScreenImageMap, 0).xy;

    float x = int(gl_FragCoord.x) % u_PixelSize;
    float y = int(gl_FragCoord.y) % u_PixelSize;

    vec4 sample = texture(u_ScreenImageMap, gl_FragCoord.xy / texSize);

    if(sample.a <= 0) return;

    x = floor(u_PixelSize / 2.0) - x;
    y = floor(u_PixelSize / 2.0) - y;

    x = x + gl_FragCoord.x;
    y = y + gl_FragCoord.y;

    sample = texture(u_ScreenImageMap, vec2(x, y) / texSize);
    gl_FragColor = sample;

	// gl_FragColor = texture(u_ScreenImageMap, var_ScreenTex);
}
