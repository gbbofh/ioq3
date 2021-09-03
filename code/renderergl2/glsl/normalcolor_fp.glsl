uniform sampler2D u_DiffuseMap;

varying vec2      var_Tex1;

in vec3 v_Normal;

void main()
{
    vec4 texSample = texture2D(u_DiffuseMap, varTex1);
	gl_FragColor = texSample * vec4(v_Normal, 1);
}
