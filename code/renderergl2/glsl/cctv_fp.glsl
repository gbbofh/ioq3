uniform sampler2D u_ScreenImageMap;

varying vec2   var_ScreenTex;

void main()
{
    vec4 color = texture2D(u_ScreenColorMap, var_ScreenTex);
    gl_FragColor = color * vec4(1.0, 0.0, 0.0, 1.0);
}

