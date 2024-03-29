import QtQuick 2.0
import QtQuick.Particles 2.0


ParticleSystem {
    id: ps
    anchors.fill: parent
    property url cometPic
    property variant atmosphere
    property real cometEmitRate
    property real fallingSpeed

    //comet group
    ParticleGroup{
        name:"comet"
        system: ps
        ImageParticle{
            anchors.fill: parent
            source: cometPic 
        }
    }
    //tail group
    ParticleGroup{
        name:"tail"
        system: ps
        TrailEmitter {
            group: "tail1"
            follow: "comet"
            emitRatePerParticle: 400
            lifeSpan: 200
            emitWidth: 0.2*TrailEmitter.ParticleSize
            emitHeight: 0.2*TrailEmitter.ParticleSize
            speed: PointDirection {y: -36*6;   x:200;   yVariation: 5;xVariation: 5}
            acceleration: PointDirection {y: -36*8;    x:400}
            size: 16
            sizeVariation: 6
            endSize: 0
        }
        TrailEmitter {
            group: "tail2"
            follow: "comet"
            emitRatePerParticle: 600
            lifeSpan: 400
            emitWidth: TrailEmitter.ParticleSize
            emitHeight: TrailEmitter.ParticleSize
            speed: PointDirection {y: -36*8;   x:200}
            acceleration: PointDirection {y: -36*9;    x:200}
            size: 12
            sizeVariation: 2
            endSize: 0
        }
    }

    Emitter {
        id: cometEmitter
        system: ps
        group: "comet"
        y: 0
        width: parent.width
        emitRate: cometEmitRate
        lifeSpan:8000
        speed: PointDirection {y:16*2*fallingSpeed; x:-40; xVariation: 20}
        acceleration: PointDirection {y: 16*3; x:-15;xVariation: 2}
        size: 16
        sizeVariation: 2
        GroupGoal {
            groups: ["comet"]
            goalState: "tail"
            jump: true
            system: ps
            enabled:true
            height: root.height
            width: root.width
            shape: atmosphere
        }
    }

    TrailEmitter {
        group: "tail0"
        follow: "comet"
        system: ps
        x:-5
        y:5
        emitRatePerParticle: 300
        lifeSpan: 500
        emitWidth: 10
        emitHeight: 12
        speed: PointDirection {y: -18;   x:25;   xVariation: 1}
        acceleration: PointDirection {y: -36;    x:80}
        size: 6
        sizeVariation: 3
        endSize: 0
    }

    ImageParticle{
        groups:["tail1","tail2","tail0"]
        system: ps
        anchors.fill: parent
        source: "images/particle.png"
        color: "#33565053"
    }

}
