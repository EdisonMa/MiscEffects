import QtQuick 2.0
import QtQuick.Particles 2.0

ParticleSystem {
     
    id: particles  
    property url snowflakepic1 
    property url snowflakepic2
    property real speed1 : 40
    property real speed2 : 40
    property real intensity1 :120
    property real intensity2 :16
    property real size1 :10
    property real size2 :15
    
    ImageParticle {
        system: particles        
        source: snowflakepic1  
        groups: ["group_particle1"]  
        rotation: 360
        rotationSpeed: 40
        rotationSpeedVariation :-80                  
    }

    ImageParticle {
        system: particles
        source: snowflakepic1  
        groups: ["group_particle2"] 
        rotation: 360
        rotationSpeed: 35
        rotationSpeedVariation :-70              
    }    
   
    Wander { 
        id: wanderer
        system: particles
        anchors.fill: parent
        xVariance: 360
        pace: 200
    }

    Emitter {
        system: particles   
        group: "group_particle1"     
        emitRate: particles.intensity1
        lifeSpan: 7000*parent.height/540
        speed: PointDirection { y:80; yVariation: particles.speed1; }
        acceleration: PointDirection { y: 0 }
        size: particles.size1
        sizeVariation: particles.size1*1.5
        width: parent.width
        onEmitParticles: {
            for (var i=0; i<particles.length; i++) {
                var particle = particles[i];
                particle.y = 0;
            }
        }
    }    
    
    Emitter {
        system: particles   
        group: "group_particle2"     
        emitRate: particles.intensity2
        lifeSpan: 7000*parent.height/540
        speed: PointDirection { y:80; yVariation: particles.speed2; }
        acceleration: PointDirection { y: 0 }
        size:particles.size2
        sizeVariation: particles.size2*1.5
        width: parent.width
        onEmitParticles: {
            for (var i=0; i<particles.length; i++) {
                var particle = particles[i];
                particle.y = 0;
            }
        }
    }
    
    CustomParticle {
        system: particles 
        groups: ["group_particle1","group_particle2"]          
        vertexShader:"
            uniform lowp float qt_Opacity;
            varying lowp float fFade;
            
            void main() {                                           
                qt_TexCoord0 = qt_ParticleTex;
                highp float size = qt_ParticleData.z;
                highp float endSize = qt_ParticleData.w;

                highp float t = (qt_Timestamp - qt_ParticleData.x) / qt_ParticleData.y;

                highp float currentSize = mix(size, endSize, t * t);

                if (t < 0. || t > 1.)
                currentSize = 0.;

                highp vec2 pos = qt_ParticlePos
                - currentSize / 2. + currentSize * qt_ParticleTex          
                + qt_ParticleVec.xy * t * qt_ParticleData.y         
                + 0.5 * qt_ParticleVec.zw * pow(t * qt_ParticleData.y, 2.);

                gl_Position = qt_Matrix * vec4(pos.x, pos.y, 0, 1);

                highp float fadeIn = min(t * 20., 1.);
                highp float fadeOut = 1. - max(0., min((t - 0.75) * 4., 1.));

                fFade = fadeIn * fadeOut * qt_Opacity;    
                fFade = fadeIn * fadeOut;           
            }
        "
        fragmentShader: "            
            varying lowp float fFade;
            varying highp vec2 qt_TexCoord0;
            void main() {
                highp vec2 circlePos = qt_TexCoord0*2.0 - vec2(1.0,1.0);               
                highp float dist = length(circlePos);
                highp float circleFactor = max(min(1.0 - dist, 1.0), 0.0);
                gl_FragColor = vec4(0.9,0.9,0.9, 1.0)*  circleFactor* fFade; 
                
            }" 

    }        
    
    
}

