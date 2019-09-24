uniform float iTime;
uniform vec2 iResolution;

vec2 hash( vec2 p )
{
	return fract(sin(vec2(dot(p,vec2(120.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}

vec3 voro(in vec2 x)
{
	vec2 n = floor(x);
	vec2 f = fract(x);
	vec2 mg, mr;
	float md = 8.0;
	for( int j=-1; j <= 1; j++)
	for( int i=-1; i <= 1; i++)
	{
		vec2 g = vec2(float(i),float(j));
		vec2 o = hash( n + g );
		#ifdef ANIMATE
        o = 0.5 + 0.5*sin( iTime + 6.2831*o );
        #endif	
        vec2 r = g + o - f;
        float d = dot(r,r);

        if( d<md )
        {
            md = d;
            mr = r;
            mg = g;
        }
	}
	md = 8.0;
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        vec2 g = mg + vec2(float(i),float(j));
		vec2 o = hash( n + g );
        o = 0.5 + 0.5*sin( iTime + 6.2831*o );
        vec2 r = g + o - f;

        if( dot(mr-r,mr-r)>0.00001 )
        md = min( md, dot( 0.5*(mr+r), normalize(r-mr) ) );
    }

    return vec3( md, mr );
}

void main(void)
{
	vec2 p = gl_FragCoord.xy/iResolution.xx;
	vec3 c = voro(8.0*p);
	vec3 col = c.x*(0.5 + 0.5*sin(64.0*c.x))*vec3(1.0);
	//col = mix( vec3(1.0,0.6,0.0), col, smoothstep( 0.04, 0.07, c.x ) );
	gl_FragColor = vec4(col,1.0);

	/*vec2 q = gl_FragCoord.xy/iResolution.yy;
	q.x += 2.0;
	vec2 p = 10.*q*mat2(0.7071, -0.7071, 0.7071, 0.7071);
	vec2 pi = floor(p);
	vec4 v = vec4(pi.xy, pi.xy +1.0);
	v -= 64.*floor(v*0.015);
	v.xz = v.xz*1.435 + 34.423;
	v.yw = v.yw*2.349 + 183.37;
	v = v.xzxz*v.yyww;
	v *= v;
	v *= iTime*0.000004 + 0.5;
	vec4 vx = 0.25*sin(fract(v*0.00047)*6.2831853);
	vec4 vy = 0.25*sin(fract(v*0.00074)*6.2831853);
	vec2 pf = p - pi;
	vx += vec4(0., 1., 0., 1.) - pf.xxxx;
    vy += vec4(0., 0., 1., 1.) - pf.yyyy;
    v = vx*vx + vy*vy;
    v.xy = min(v.xy, v.zw);
    vec3 col = mix(vec3(0.0,0.4,0.9), vec3(0.0,0.95,0.9), min(v.x, v.y) );     
	gl_FragColor = vec4(col, 1.0);*/
}