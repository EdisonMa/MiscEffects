import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {  
    id: root  
    color: "black"    

    Image {
        id: bgimg
        source: "img/universe.png"
        anchors.fill: parent
        width: parent.width
        height: parent.height
    }    
    

    Canvas {
      id:canvas
      Component.onCompleted:
       { 
          timer.running= true;          
          emitter.burst(200);
                   
       }
    } 
         
    ParticleSystem {
        id: particles
    }   

    ImageParticle {
        id: starpic
        system: particles
        groups: ["group_particle"]
        anchors.fill: parent        
        source: "img/star.png"        
    }

   
    Emitter {
        id: emitter
        system: particles   
        group: "group_particle"
        enabled: false     
        emitRate: 1
        lifeSpan: 30000  
        speed: AngleDirection{angle:0;angleVariation:360;magnitude:2;magnitudeVariation:2}
        size: 8
        sizeVariation: 5
        onEmitParticles: {
            for (var i=0; i<particles.length; i++) {
                var particle = particles[i];
                particle.x = Math.min(Math.max(Math.random()*root.width,0),root.width);
                particle.y = Math.min(Math.max(Math.random()*root.height,0),root.height);                
            }
        }
    }      

    

    Wander{
            anchors.fill: parent
            system: particles  
            groups: ["group_particle"]          
            xVariance : 5
            yVariance : 5
            pace : 2
            enabled: false
    }        
    
     
     Timer {
         id: timer
         interval: 30000; running: false; repeat: true
         onTriggered: 
         {
           emitter.burst(200);
         }
     }        
}
