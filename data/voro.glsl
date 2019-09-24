uniform float iTime;
uniform vec2 iResolution;

vec2 hash( vec2 p )
{
	// Dave Hoskin's hash as in https://www.shadertoy.com/view/4djSRW
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+19.19);
    vec2 o = fract(vec2((p3.x + p3.y)*p3.z, (p3.x+p3.z)*p3.y));
	return o;
}

vec3 voro(in vec2 x)
{
	// Tomasz Dobrowolski's fast voronoi with 3x3 scan as in https://www.shadertoy.com/view/llG3zy
	vec2 n = floor(x);
	vec2 f = fract(x);
	vec2 mr;
	float md = 8.0;
	for( int j=-1; j <= 1; j++)
	for( int i=-1; i <= 1; i++)
	{
		vec2 g = vec2(float(i),float(j));
		vec2 o = hash( n + g );
        o = 0.5 + 0.5*sin( iTime + 6.2831*o );
        vec2 r = g + o - f;
        float d = dot(r,r);
        if( d<md )
        {
            md = d;
            mr = r;
        }
	}
	md = 8.0;
    for( int j=-1; j<=1; j++ )
    for( int i=-1; i<=1; i++ )
    {
        vec2 g = vec2(float(i),float(j));
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
	vec3 c = voro(9*p);
	vec3 col = c.x*2.*(sin(c.x)+.9)*vec3(p.y,c.x,1.);
	gl_FragColor = vec4(col,1.0);
}