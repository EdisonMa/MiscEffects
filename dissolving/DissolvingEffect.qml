import QtQuick 2.0

ShaderEffect 
{
   id: shader      
   property real showblock: 1.0
   property real xdivision: 4
   property real ydivision: 4
   property real transparency: 1.0
   property real offset: 0.0
   property real freq: 0.0
   property real speed: 30000
   property variant bgpic   
   property variant cloudsampler: ShaderEffectSource {
                smooth: true
                sourceItem: ShaderEffect
                {
                    width: 1024
                    height:  1024
                    property real offset: shader.offset
                    property real freq: shader.freq    
         
                    vertexShader:"
            
                      attribute highp vec4 qt_Vertex;
                      uniform highp mat4 qt_Matrix;
                      attribute highp vec2 qt_MultiTexCoord0;
                      uniform float offset;
                      uniform float freq;
                      const float texscale = 8.0;            
                      varying vec3 v_texCoord3D;
                      varying vec2 v_texCoord2D;

                      void main(void)
                      {
                         v_texCoord3D = vec3(vec2((qt_MultiTexCoord0.x*texscale+offset),(qt_MultiTexCoord0.y*texscale+offset)), freq);
                         v_texCoord2D = vec2(qt_MultiTexCoord0.xy);
                         gl_Position =  qt_Matrix * (qt_Vertex); 

                       }
                     "

                    fragmentShader: " 

                       varying vec3 v_texCoord3D;
                       varying vec2 v_texCoord2D;
                       const float intensity = 0.35;

                       vec4 permute(vec4 x)
                       {
                          return mod(((x*34.0)+1.0)*x, 289.0);
                       } 
                 

                       float genNoise(vec3 v)
                       { 
                           const vec2  A = vec2(1.0/6.0, 1.0/3.0) ;
                           const vec4  B = vec4(0.0, 0.5, 1.0, 2.0);


                           vec3 i  = floor(v + dot(v, A.yyy) );
                           vec3 x0 =   v - i + dot(i, A.xxx) ;


                           vec3 g = step(x0.yzx, x0.xyz);
                           vec3 l = 1.0 - g;
                           vec3 i1 = min( g.xyz, l.zxy );
                           vec3 i2 = max( g.xyz, l.zxy );


                           vec3 x1 = x0 - i1 + 1.0 * A.xxx;
                           vec3 x2 = x0 - i2 + 2.0 * A.xxx;
                           vec3 x3 = x0 - 1. + 3.0 * A.xxx;


                           i = mod(i, 289.0 ); 
                           vec4 p = permute( permute( permute( 
                                    i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
                                    + i.y + vec4(0.0, i1.y, i2.y, 1.0 )) 
                                    + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

                           float n_ = 1.0/7.0; 
                           vec3  ns = n_ * B.wyz - B.xzx;

                           vec4 j = p - 49.0 * floor(p * ns.z *ns.z);  

                           vec4 x_ = floor(j * ns.z);
                           vec4 y_ = floor(j - 7.0 * x_ );    

                           vec4 x = x_ *ns.x + ns.yyyy;
                           vec4 y = y_ *ns.x + ns.yyyy;
                           vec4 h = 1.0 - abs(x) - abs(y);

                           vec4 b0 = vec4( x.xy, y.xy );
                           vec4 b1 = vec4( x.zw, y.zw );


                           vec4 s0 = floor(b0)*2.0 + 1.0;
                           vec4 s1 = floor(b1)*2.0 + 1.0;
                           vec4 sh = -step(h, vec4(0.0));

                           vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
                           vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

                           vec3 p0 = vec3(a0.xy,h.x);
                           vec3 p1 = vec3(a0.zw,h.y);
                           vec3 p2 = vec3(a1.xy,h.z);
                           vec3 p3 = vec3(a1.zw,h.w);

                           vec4 norm = 1.79284291400159 - 0.85373472095314*vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3));
                           p0 *= norm.x;
                           p1 *= norm.y;
                           p2 *= norm.z;
                           p3 *= norm.w;

                           vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
                           m = m * m;
                           return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3) ) );
                      }


                      void main( void )
                      {
                          float n1 = genNoise(v_texCoord3D*1.);
                          float n2 = genNoise(v_texCoord3D*2.);
                          float n3 = genNoise(v_texCoord3D*4.);
                          float n4 = genNoise(v_texCoord3D*8.);
                          float n5 = genNoise(v_texCoord3D*16.);
  
                          float n= n1/1.+ n2/2.+n3/4.+n4/8.+n5/16.;
                          n = n*intensity;
                          gl_FragColor = vec4( n, n, n, 1.0); 

                      }
                     "
                } 
               }
   
         
   vertexShader:"
            
            attribute highp vec4 qt_Vertex;
            uniform highp mat4 qt_Matrix;
            attribute highp vec2 qt_MultiTexCoord0;            
            varying vec2 v_texCoord2D;             
            void main(void)
            {
               v_texCoord2D = vec2(qt_MultiTexCoord0.xy);
               gl_Position =  qt_Matrix * (qt_Vertex); 
              

            }
         "
   fragmentShader: "            
            uniform float showblock;
            varying vec2 v_texCoord2D;
            uniform float xdivision;
            uniform float ydivision;
            uniform float transparency;
            uniform sampler2D cloudsampler;
            uniform sampler2D bgpic;        
           
            void main( void )
            {
               float nx = abs((mod(showblock,xdivision)+v_texCoord2D.x)/xdivision);
               float ny = fract((floor(showblock/xdivision)+v_texCoord2D.y)/ydivision);               
               vec2 texcoord = vec2(nx, ny);

               vec4 base = texture2D(bgpic, v_texCoord2D);
               vec4 blend = texture2D(cloudsampler, texcoord);
              
               gl_FragColor = vec4((2.0-v_texCoord2D.y)*blend.rgb+base.rgb,transparency);

            }
         "

   ParallelAnimation 
    {            
       running: true        
        
       NumberAnimation 
       { 
           loops: Animation.Infinite
           target: shader 
           property: "offset"
           from: 0.0 
           to: 1.0
           duration: shader.speed 
       }   
     
       NumberAnimation 
       { 
           loops: Animation.Infinite
           target: shader
           property: "freq"
           from: 0.0
           to: 0.8
           duration: shader.speed 
       }
    } 

   Timer
    {
           id: timer
           interval: 50000
           running: true
           repeat: true
           onTriggered: 
           {
             shader.showblock = (shader.showblock +1)%(shader.xdivision*shader.ydivision)
           }
    }  
}


