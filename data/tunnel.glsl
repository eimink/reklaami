uniform float iTime;
uniform vec2 iResolution;

float hash(float n) { 
	return fract(sin(n)*297.5453123); 
}

float noise(vec3 x) {
    vec3 p = floor(x);
    vec3 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + p.z*113.0;
    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+114.1), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

float cyl( vec3 p, vec3 c ) {
  return length(p.xy-c.xy)-c.z;
}

vec2 rot(vec2 k, float t) {
    return vec2(cos(t)*k.x-sin(t)*k.y,sin(t)*k.x+cos(t)*k.y);
}

float DE(vec3 p) {
    p.z+=iTime*2.0;
    p.x+=sin(p.z*0.5)*3.0;
    return cyl(p, vec3(0.0,0.0,1.5));    
}

vec4 DEc4(vec3 p) {
    float t=DE(p);
        p.z+=iTime*4.0;
        t+=noise(p*1.75-iTime*1.5)*0.6;

    vec4 res = vec4(  clamp( t, 0.0, 1.0 ) );
    	 res.xyz = mix( vec3(1.0,1.0,1.0), vec3(0.0,0.0,0.05), res.x );
	return res;
}

void main(void) {
	vec3 ro=vec3(0.0, 0.0, -4.0);
	vec3 rd=normalize( vec3( (-1.0+2.0*gl_FragCoord.xy/iResolution.xy)*vec2(iResolution.x/iResolution.y,1.0), 1.0));
	vec3 lig=normalize(vec3(0.0, 1.0, 0.0));

    ro.x+=cos(iTime)*2.5;
    rd.xy=rot(rd.xy,iTime*0.5+cos(iTime));
    rd.x+=sin(iTime-3.14*0.2)*0.2;


	float d=0.0;
	vec4 col=vec4(0.07,0.1,0.15,0.0);
	
	for(int i=0; i<120; i++) {
        if(col.w >.99) break;
		vec4 res=DEc4(ro+rd*d);
            res.w *= 0.35;
    		res.xyz *= res.w;
    	    col = col + res*(1.0 - col.w);  
        d+=0.1;
	}

    col.xyz/=col.w;
    col = sqrt( col );
    
	gl_FragColor = vec4( col.xyz, 1.0 );
}