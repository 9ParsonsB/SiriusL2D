uniform sampler2D tNoise;
uniform vec3 uColor;
uniform vec2 offset;
uniform float scale, density, falloff, tNoiseSize;

float normalnoise(vec2 p) {
    return cnoise(p) * 0.5 + 0.5;
}

float noise(vec2 p) {
    p += offset;
    const int steps = 5;
    float scale = pow(2.0, float(steps));
    float displace = 0.0;
    for (int i = 0; i < steps; i++) {
        displace = normalnoise(p * scale + displace);
        scale *= 0.5;
    }
    return normalnoise(p + displace);
}

vec4 effect(vec4 color, Image texture, vec2 uv, vec2 pos) { 
    vec4 s = Texel(texture, uv);
    float n = noise(gl_FragCoord.xy * scale * 1.0);
    n = pow(n + density, falloff);
    return vec4(mix(s.rgb, uColor, n), 1);
}
