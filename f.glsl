//GLSL
#version 140

uniform vec4 light_color[100];
uniform vec4 light_pos[100];
uniform int num_lights;
uniform sampler2D p3d_Texture0;
uniform sampler2D normal_map;
uniform vec3 camera_pos;
uniform vec3 ambient;

in vec2 uv;
in vec4 world_pos;
in vec3 normal;

//TBN by Chris­t­ian Schuler from http://www.thetenthplanet.de/archives/1180
mat3 cotangent_frame( vec3 N, vec3 p, vec2 uv )
    {
    // get edge vectors of the pixel triangle
    vec3 dp1 = dFdx( p );
    vec3 dp2 = dFdy( p );
    vec2 duv1 = dFdx( uv );
    vec2 duv2 = dFdy( uv );
 
    // solve the linear system
    vec3 dp2perp = cross( dp2, N );
    vec3 dp1perp = cross( N, dp1 );
    vec3 T = dp2perp * duv1.x + dp1perp * duv2.x;
    vec3 B = dp2perp * duv1.y + dp1perp * duv2.y;
 
    // construct a scale-invariant frame 
    float invmax = inversesqrt( max( dot(T,T), dot(B,B) ) );
    return mat3( T * invmax, B * invmax, N );
    }


vec3 perturb_normal( vec3 N, vec3 V, vec2 texcoord )
    {
    // assume N, the interpolated vertex normal and 
    // V, the view vector (vertex to eye)
    vec3 map = (texture( normal_map, texcoord ).xyz)*2.0-1.0;
    mat3 TBN = cotangent_frame( N, -V, texcoord );
    return normalize( TBN * map );
    }


void main()
    {           
    vec3 color=vec3(0.0, 0.0, 0.0);
    vec4 color_tex=texture(p3d_Texture0,uv);
    vec3 up= vec3(0.0,0.0,1.0);
    float specular =0.0;           
    vec3 N=normalize(normal);    
    vec3 V = normalize(world_pos.xyz - camera_pos);    
    N = perturb_normal( N, V, uv);
    
    //ambient 
    color+= (ambient+max(dot(N,up), -0.2)*ambient)*0.5; 
    
    vec3 L;
    vec3 R;
    float att;   
    for (int i=0; i<num_lights; ++i)
        { 
        //diffuse
        L = normalize(light_pos[i].xyz-world_pos.xyz);
        att=pow(distance(world_pos.xyz, light_pos[i].xyz), 2.0);      
        att =clamp(1.0 - att/(light_pos[i].w), 0.0, 1.0);  
        color+=light_color[i].rgb*max(dot(N,L), 0.0)*att;
        //specular
        R=reflect(L,N)*att;
        specular +=pow(max(dot(R, V), 0.0), 10.0)*light_color[i].a;
        }
    
    gl_FragData[0]=vec4((color_tex.rgb*color)+specular, color_tex.a);      
    }
