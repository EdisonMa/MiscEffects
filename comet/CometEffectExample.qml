import QtQuick 2.0
import QtQuick.Particles 2.0


Rectangle {
    id: root
    width: 800
    height: 400
    color: "#eeb0a6"
    Image {
        id: bg
        source: "images/bg.jpg"
        width: parent.width
        height: parent.height
    }

    MaskShape {
     id: atmosphereMask 
     source: "images/mask.png"
    }

    CometEffect {
      width: parent.width
      height: parent.height
      cometPic: "images/comet.png"
      atmosphere: atmosphereMask
      cometEmitRate: 0.2
      fallingSpeed: 1.0
    }

}
