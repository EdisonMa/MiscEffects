import QtQuick 2.0
import QtQuick.Particles 2.0
ParticleSystem {
       
        property bool firework1Enabled: true
        property bool firework2Enabled: true
        property bool firework3Enabled: true
        property real firework1EmitRate: 1
        property real firework2EmitRate: 2
        property real firework3EmitRate: 2

        id: fireworks
        anchors.fill: parent
               
        ParticleGroup {
            name: "fire"
            duration: 200
            durationVariation: 200
            to: {"temp":1}
        }
        ParticleGroup{
        	name : "temp"
        	duration : (height * 5 / 3 - 200)
        	durationVariation : 500
        	to : {"dead" : 1}      	
        	TrailEmitter {
		        group: "work"
		        emitRatePerParticle: 80
		        lifeSpan: 1000
		        maximumEmitted: 1000
		        size: 8
		        speed : PointDirection {y : 50}
            }
        }
        ParticleGroup {
            name: "dead"
            duration: 200
            Wander {
                once: true
                onAffected:{
                	 worksEmitter.burst(70,x,y)
                	 whiteEmitter.burst(100,x ,y)
                }
            }
        }
        ParticleGroup {
            name: "tail"
            duration: 200
            to: {"ss":1}
        }
        ParticleGroup{
        	name : "ss"
        	duration : 3000
        	TrailEmitter {
		        group: "flame"
		        emitRatePerParticle: 55
		        lifeSpan: 800
		        maximumEmitted: 8000
		        size: 10
            }        	
        }
        Emitter {
            id: startingEmitter
            group: "fire"
            width: parent.width / 2
            x : parent.width / 4
            y: parent.height
            enabled: fireworks.firework1Enabled
            emitRate: fireworks.firework1EmitRate
            lifeSpan: 2000
            speed: PointDirection {y:-300; yVariation : 10; xVariation : 20}
            size: 16
        }
        Emitter {
            id: worksEmitter
            group: "tail"
            enabled: false
            emitRate: 10
            lifeSpan: 900
            maximumEmitted: 3000
            size: 16
            speed:AngleDirection {angleVariation: 360; magnitude : 50 ;magnitudeVariation: 150;}
            acceleration: PointDirection {y:120; yVariation: 20; }
        }
        
        Emitter {
	    	id : whiteEmitter
	    	enabled : false  
	        emitRate: 40
	        maximumEmitted: 4000
	        speed : AngleDirection {angleVariation: 360; magnitude: 50; }     
	        acceleration: AngleDirection {angleVariation: 360; magnitude: -50; }
	        lifeSpan : 1000
	        size: 16
	    }
  	
    	ParticleGroup {
            name: "temp1"
            duration: 200
            durationVariation: 200
            to: {"fire1":1}
        }
        ParticleGroup{
        	name : "fire1"
        	duration : (height * 5 / 2 - 200)
        	durationVariation : 500
        	to : {"dead1" : 1}      	
        	TrailEmitter {
		        group: "works1"
		        emitRatePerParticle: 50
		        lifeSpan: 1000
		        maximumEmitted: 1000
		        size: 8
		       	speed : PointDirection {y : 50}
            }
        }
        ParticleGroup {
            name: "dead1"
            duration: 200
            Wander {
                once: true
                onAffected:{
                	 noTailsEmitter.burst(100,x,y)
                }
            }
        }
        Emitter {
            id: nextEmitter
            group: "temp1"
            width: parent.width / 2
            x : parent.width / 4
            y: parent.height
            enabled: fireworks.firework2Enabled
            emitRate: fireworks.firework2EmitRate
            lifeSpan: 6000
            speed: PointDirection {y:-200; xVariation : 30}
            size: 8
        }

        Emitter {
            id: noTailsEmitter
            group: "splode1"
            enabled: false
            emitRate: 200
            lifeSpan: 1500
            maximumEmitted: 10000
            size: 8
            speed: AngleDirection {angleVariation: 360; magnitude : 50 ; magnitudeVariation : 30}
        }
        ImageParticle {
            groups:[ "fire","work","temp","tail", "flame", "ss"]
            source: "images/particle.png"
            color: "#000000FF"
            colorVariation : 0.4
        }	
        ImageParticle {
            groups: [ "works1","fire1","temp1","splode1"]
            source: "images/particleA.png"
            colorVariation : 0.6
            color : "#00ff400f"
            
        }
    	ShaderEffectSource {
       	 	id: theSource
        	sourceItem: theItem
        	hideSource: true
    	}
    	Image {
       	 	id: theItem
        	source: "images/particleA.png"
    	}    	
	CustomParticle {				
	        vertexShader:"
	            uniform lowp float qt_Opacity;
	            varying lowp float fFade;		           		
	            void main() {                                           
	                defaultMain();
	                highp float t = (qt_Timestamp - qt_ParticleData.x) / qt_ParticleData.y;
	                highp float fadeIn = min(t * 10., 1.);
	                highp float fadeOut = 1. - max(0., min((t - 0.1) * 4., 1.));		
	                fFade = fadeIn * fadeOut * qt_Opacity;		               
	            }
	        "
	        property variant source: theSource		        
	        fragmentShader: "
	            uniform sampler2D source;		          
	            varying highp vec2 qt_TexCoord0;		          
	            varying highp float fFade;
	            void main() {           
	                gl_FragColor = texture2D(source, qt_TexCoord0) * fFade;
	            }"
    	}
    	
//the third firework    	
    
        ParticleGroup {
            name: "temp2"
            duration: 200
            durationVariation: 200
            to: {"fire2":1}
        }
        ParticleGroup{
        	name : "fire2"
        	duration : (height * 5 / 2 - 200)
        	durationVariation : 500
        	to : {"dead2" : 1}      	
        	TrailEmitter {
                group: "works2"
                emitRatePerParticle: 50
                lifeSpan: 1000
                maximumEmitted: 1000
                size: 8
               	speed : PointDirection {y : 50}
            }
        }
        ParticleGroup {
            name: "dead2"
            duration: 200
            Wander {
                once: true
                onAffected:{
                	 worksEmitter1.burst(100,x,y)
                }
            }
        }
        Emitter {
            id: startingEmitter1
            group: "temp2"
            width: parent.width / 2
            x : parent.width / 4
            y: parent.height
            enabled: fireworks.firework3Enabled
            emitRate: fireworks.firework3EmitRate
            lifeSpan: 6000
            speed: PointDirection {y:-200; xVariation : 30}
            size: 8
        }

        Emitter {
            id: worksEmitter1
            group: "splode2"
            enabled: false
            emitRate: 500
            lifeSpan: 3500            
            maximumEmitted: 10000
            size: 15
            speed: AngleDirection {angleVariation: 360; magnitude : 100 ; magnitudeVariation : 30}
        }

        ImageParticle {
            groups: [ "works2","fire2","temp2"]
            source: "images/particleA.png"
            color : "#0f80277a"
            colorVariation : 0.1
        }
        ShaderEffectSource {
       	 	id: theSource1
        	sourceItem: theItem1
        	hideSource: true
    	}
    	Image {
       	 	id: theItem1
        	source: "images/particleA.png"
    	}    	
	CustomParticle {		
	 	groups: [ "splode2"]		
	        vertexShader:"
	        		
	            uniform lowp float qt_Opacity;
	            varying lowp float fFade;		           		
	            void main() {                                           
	                defaultMain();
	                highp float t = (qt_Timestamp - qt_ParticleData.x) / qt_ParticleData.y;
	                highp float fadeIn = min(t * 10., 1.);
	                highp float fadeOut = 1. - max(0., min((t - 0.1) * 4., 1.));		
	                fFade = fadeIn * fadeOut * qt_Opacity;		               
	            }
	        "
	        property variant source: theSource1
	         	        
	        fragmentShader: "
	        	const vec4 color11 = vec4(0.5, 0.153, 0.5, 1.0);
	            uniform sampler2D source;		          
	            varying highp vec2 qt_TexCoord0;		          
	            varying highp float fFade;
	            void main() {           
	               vec2 temp = qt_TexCoord0;
	                vec2 center = vec2(0.5,0.5);
	                float f = distance(temp, center);
	                if(f>=0.5)
	                	gl_FragColor = texture2D(source, qt_TexCoord0) * fFade;
	                else
	                	gl_FragColor = color11 * fFade * (1.0 - f) * (1.0 - f);
	            }"

    	} 
    }
