uniform sampler2D u_DiffuseMap;

varying vec2      var_Tex1;

in vec3 v_Normal;

void main()
{
    vec3 normColor = v_Normal + vec3(1, 1, 1);
    normColor += 0.5;

    vec4 texSample = texture2D(u_DiffuseMap, var_Tex1);
    gl_FragColor = texSample * vec4(normColor, 1);
}
