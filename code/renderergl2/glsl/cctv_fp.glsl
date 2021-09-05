uniform sampler2D u_ScreenImageMap;

varying vec2   var_ScreenTex;

vec4 cctv(sampler2D image, vec2 coords)
{
    vec2 texSize = textureSize(image, 0);
    vec2 pixCoord = coords * texSize;
    vec4 sample = texture2D(image, coords);

    if(mod(pixCoord.x, 3) == 0) {

        return vec4(sample.r, 0, 0, 1);
    }

    if(mod(pixCoord.x, 3) == 1) {

        return vec4(0, sample.g, 0, 1);
    }

    if(mod(pixCoord.x, 3) == 2) {

        return vec4(0, 0, sample.b, 1);
    }
}

void main()
{
    // vec4 color = texture2D(u_ScreenImageMap, var_ScreenTex);
    // gl_FragColor = color * vec4(1.0, 0.0, 0.0, 1.0);

    gl_FragColor = cctv(u_ScreenImageMap, var_ScreenTex);
}

