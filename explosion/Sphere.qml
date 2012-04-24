import QtQuick 2.0
import QtQuick.Particles 2.0

ParticleSystem 
{
    
    id: particles
    property real interval: 2000
    property bool colliding: false
    property bool repeat: false
    property variant collidepoint: Qt.point(collidepoint_x,collidepoint_y)

    property real collidepoint_x
    property real collidepoint_y

    Canvas {
      id:canvas
      Component.onCompleted:
       { 
          colliding = false;
          emitter1.burst(1);
          emitter2.burst(1);                   
       }
    }

    ImageParticle {
        system: particles
        groups: ["group_particle1"]
        anchors.fill: parent        
        source: "img/fireball.png"
        rotation: 60
        rotationSpeed: 60
        rotationSpeedVariation : 30
        rotationVariation : 30
    }
    ImageParticle {
        system: particles
        groups: ["group_particle2"]
        anchors.fill: parent        
        source: "img/fireball.png"
        rotation: 60
        rotationSpeed: 60
        rotationSpeedVariation : 30
        rotationVariation : 30
    }     

   Emitter {
        id: emitter1
        group: "group_particle1"
        x: 50
        y: parent.height/2
        system: particles
        emitRate: 1
        lifeSpan: 20000
        lifeSpanVariation: 0
        enabled: false        
        speed: AngleDirection{angle:0;angleVariation:0;magnitude:200;magnitudeVariation:50}
        size: 25
        sizeVariation: 0
    } 

   
    Emitter {
        id: emitter2
        group: "group_particle2"
        x: parent.width-50
        y: emitter1.y
        system: particles
        emitRate: 1
        lifeSpan: 20000 
        lifeSpanVariation: 0       
        enabled: false
        speed: AngleDirection{angle:180;angleVariation:0;magnitude:200;magnitudeVariation:70}
        size: 25
        sizeVariation: 0
    } 
    
 
    Age {
            anchors.fill: parent
            system: particles
            whenCollidingWith :["group_particle1"]
            groups: ["group_particle2"]
            lifeLeft: 2
        } 

    Age {
            anchors.fill: parent
            system: particles
            whenCollidingWith :["group_particle2"]
            groups: ["group_particle1"]
            advancePosition: false
            lifeLeft: 2
            onAffected:
            { 
               if(particles.repeat)              
                  timer.running = true;
               particles.colliding = true;  
               particles.collidepoint_x = x; 
               particles.collidepoint_y = y;                           
            }
        } 
    

    Wander{
            anchors.fill: parent
            system: particles  
            groups: ["group_particle4"]          
            xVariance : 5
            yVariance : 5
            pace : 2
            enabled: false
    }        
      
    Timer {
         id: timer
         interval: particles.interval; running: false; repeat: false
         onTriggered: 
         {
           emitter1.burst(1);
           emitter2.burst(1);
           timer.running = false;
           particles.colliding = false;
         }
     }     
            
}
