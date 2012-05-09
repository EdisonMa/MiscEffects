import QtQuick 2.0
import QtQuick.Particles 2.0

ParticleSystem {
    id:ps
    property variant smokePoint
    property real smokeWidth
    property real smokeHeight
    property variant smokeColor
    
    SequentialAnimation{
        running: true
        loops: Animation.Infinite
        NumberAnimation {
            target: turb1;
            property: "strength";
            from: 1
            to:20
            duration: 6000
            easing.type: Easing.InOutBounce
        }
        NumberAnimation {
            target: turb1;
            property: "strength";
            from: 20
            to:1
            duration: 6000
            easing.type: Easing.OutInBounce
        }
        
    }
    Turbulence {
        id: turb1
        system: ps
        enabled: true
        height: smokeHeight
        strength: 20
        anchors.fill: parent
    }

    Emitter {
        id: smoke1
        x: smokePoint.x
        y: smokePoint.y
        width: smokeWidth
        anchors.horizontalCenter: parent.horizontalCenter
        system: ps
        group: "smoke"
        emitRate: 1000
        lifeSpan: 2500
        lifeSpanVariation: 1000
        size: 22
        endSize: 0
        sizeVariation: 2
        acceleration: PointDirection { y: -40 }
        speed: AngleDirection { angle: 270; magnitude: 5; angleVariation: 15; magnitudeVariation: 5 }
    }
    
    Emitter {
        id: smoke2
        x: smokePoint.x 
        y: smokePoint.y 
        width: smokeWidth
        system: ps
        group: "smoke"
        emitRate: 900
        lifeSpan: 3000
        size: 10
        endSize: 0
        sizeVariation: 2
        acceleration: PointDirection { y: -40 }
        speed: AngleDirection { angle: 270; magnitude: 5; angleVariation: 22; magnitudeVariation: 6}
    }

    CustomParticle {
        groups: ["smoke"]
        system:ps
        property variant color: smokeColor
        vertexShader:"
            uniform lowp float qt_Opacity;
            varying lowp float fFade;
            varying highp vec2 fPos;

            void main() {
                qt_TexCoord0 = qt_ParticleTex;
                highp float size = qt_ParticleData.z;
                highp float endSize = qt_ParticleData.w;

                highp float t = (qt_Timestamp - qt_ParticleData.x) / qt_ParticleData.y;

                highp float currentSize = mix(size, endSize, t * t);

                if (t < 0. || t > 1.)
                currentSize = 0.;

                highp vec2 pos = qt_ParticlePos
                - currentSize / 2. + currentSize * qt_ParticleTex          // adjust size
                + qt_ParticleVec.xy * t * qt_ParticleData.y         // apply speed vector..
                + 0.5 * qt_ParticleVec.zw * pow(t * qt_ParticleData.y, 2.);

                gl_Position = qt_Matrix * vec4(pos.x, pos.y, 0, 1);

                highp float fadeIn = min(t * 20., 1.);
                highp float fadeOut = 1. - max(0., min((t - 0.75) * 4., 1.));

               fPos = vec2(pos.x/1024., pos.y/768.);
                if(t < 0.2)
                        fFade = 0.01;
                else
                    fFade = 0.04;
            }
        "
        fragmentShader: "
            varying highp vec2 fPos;
            varying lowp float fFade;
            varying highp vec2 qt_TexCoord0;
            uniform vec4 color;
            void main() {//*2 because this generates dark colors mostly
                highp vec2 circlePos = qt_TexCoord0*2.0 - vec2(1.0,1.0);
                highp float dist = length(circlePos);
                highp float circleFactor = max(min(1.0 - dist, 1.0), 0.0);
//                gl_FragColor = vec4(fPos.x*2.0 - fPos.y, fPos.y*2.0 - fPos.x, fPos.x*fPos.y*2.0, 0.0) * circleFactor * fFade;
                gl_FragColor = color/255. * circleFactor * fFade;

            }"

    }
}
