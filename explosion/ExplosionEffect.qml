import QtQuick 2.0
import QtQuick.Particles 2.0

ParticleSystem {  
    
    id: particles  
    property bool enabled: false
    property variant flashpoint

    Timer 
    {
         id: timer
         interval: 1000; running: particles.enabled; repeat: false
         triggeredOnStart: true
         onTriggered: 
         {          
            emitter.x= flashpoint.x;
            emitter.y= flashpoint.y;
            emitter.burst(1000);
            emitter.pulse(500);
            timer.stop();          
         }
     }  
    
    ImageParticle {
        system: particles
        groups: ["group_particle"]
        anchors.fill: parent        
        source: "img/particle.png"
        alpha: 0
        z: 1
        colorVariation: 0.5   
        colorTable: "img/flame.png"
        sizeTable: "img/flame.png"
    }

    Emitter {
        id: emitter
        group: "group_particle"        
        system: particles
        emitRate: 500
        lifeSpan: 2000  
        enabled: false
        speed: AngleDirection{angle:0;angleVariation:360;magnitude:100;magnitudeVariation:10}
        size: 16
        sizeVariation: 30
    } 
    

     Age {
            anchors.fill: parent
            system: particles            
            groups: ["group_particle"]
            advancePosition: false
            once: true
            lifeLeft: emitter.lifeSpan/3            
        } 

    Wander{
            anchors.fill: parent
            system: particles  
            groups: ["group_particle"]          
            xVariance : 1000
            yVariance : 1000
            pace : 1500
    }       
    
     
     Loader {
         id: loader
         sourceComponent: explosion
         active : particles.enabled
         asynchronous : false
         anchors.centerIn: parent
     }
   
     Component {       
        id: explosion 
              
        Rectangle {
            id: explosionArea
            color: "transparent"
            width: root.width
            height:  root.height
            anchors.centerIn: parent            
          Image {
            id : flameimg
            source : "img/flame.png" 
            anchors.centerIn: parent
            visible: false
           }   


          ParallelAnimation {            
            running: true
            
            NumberAnimation { target: cust_par ; property: "flamability";  from: 0.0; to: 1.0; duration: 1000 }
            NumberAnimation { target: cust_par; property: "pressure";  from: 0.0; to: 1.0; duration: 1000 }
            NumberAnimation { target: cust_par ; property: "time";  from: 0.0; to: 1.0; duration: 1500 }           
            NumberAnimation { target: cust_par; property: "powerBoost"; from: 0.0; to: 1.0; duration: 1000 }
            NumberAnimation { target: cust_par; property: "noisiness"; from: 0.0; to: 1.0; duration: 1000 }
            NumberAnimation { target: cust_par; property: "speed"; from: 0.0; to: 1.0; duration: 1000 }
            NumberAnimation { target: cust_par; property: "explositivity"; from: 0.0; to: 1.0; duration: 1000 }
            
            NumberAnimation { target: cust_par; property: "intensity"; from: 0.0; to: 0.4; duration: 1000 }            
            
          }

          ShaderEffect {
             id : cust_par
             width: parent.width
             height:  parent.height
             property real time: 0.0
             property real flamability:0.34
             property real pressure:0.6
             property real powerBoost:0.16
             property real noisiness:0.5
             property real speed:0.15
             property real explositivity:0.44955
             property real intensity:1.0
             property variant flamesampler : flameimg
             property variant explosionpoint : Qt.point(emitter.x/particles.width, emitter.y/particles.height)
             property real fadetime: 0.5
             property real sizescale: 1.5
        
         
             vertexShader:"
            
                 attribute highp vec4 qt_Vertex;
                 uniform highp mat4 qt_Matrix;
                 attribute highp vec2 qt_MultiTexCoord0;

                 varying vec2 vTexCoord;
                 varying vec2  vOrigPosition;
                 uniform vec2  explosionpoint;
                 

                 void main(void)
                 {
	            vTexCoord = vec2(sign(qt_Vertex)) - explosionpoint; 
                    gl_Position =  qt_Matrix * (qt_Vertex); 
                    vOrigPosition = qt_MultiTexCoord0;
                    
                 }
             "
            fragmentShader: " 

                 uniform float flamability;
                 uniform float pressure;
                 uniform float powerBoost;
                 uniform float intensity;
                 uniform float speed;
                 uniform float noisiness;
                 uniform float time;
                 uniform float fadetime;
                 uniform float explositivity;
                 uniform float sizescale;
                 uniform sampler2D flamesampler;

                 varying vec2 vTexCoord;
                 varying vec2 vOrigPosition;
                 uniform lowp float qt_Opacity;

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
                 void main(void)
                 {   
                    float realtime =  min(time, fadetime);           
                    float t = fract(realtime * speed);
                    
                
   
                    t = clamp(pow(t, explositivity),0.0,1.0);

                    float size = intensity * 6.75 * t * (t * (t - 2.0) + 1.0);   
                    
                    float dist = length(vTexCoord) / (size)*sizescale;   
                   
                    float m =genNoise(vec3(vTexCoord,  flamability * realtime - pressure * dist )*8.) +genNoise(vec3(vTexCoord,  flamability * realtime - pressure * dist )*16.) +genNoise(vec3(vTexCoord,  flamability * realtime - pressure * dist )*32.) +genNoise(vec3(vTexCoord,  flamability * realtime - pressure * dist )*64.);
                    m = m/4.0;
                    
                    float p = (1.6 - dist)+ m;
                    p=(1.6 - dist)+min(max(m,0.0),0.5)+0.35;
                    
                    vec4 flame1 = texture2D(flamesampler, vec2(p, 0.0));
                    vec4 flame2 = texture2D(flamesampler, vec2((1.6 - dist), 0.0));
                    vec4 flame = (vec4(1.,1.,1.,1.)-flame1)*flame2;                   
                    
                                  
                    if( time <= fadetime )
                      gl_FragColor = flame ;
                      
                    else                     
                      gl_FragColor = vec4(.0,.0,.0,.0);
      
                }  
          " 
         }    
       }
    }    
}
