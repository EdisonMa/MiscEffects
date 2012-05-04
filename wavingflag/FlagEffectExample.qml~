import QtQuick 2.0

Item{
    id: main
    width:800
    height:400
    Image {
        id: bg
        source: "images/bg.jpg"
        anchors.fill: parent
    }  

    FlagEffect{
        id:flageffect1
        z: 3
        x: 50
        y: 100        
        flagPic: "images/nokia.jpg"
        width: 300
        height: 200
        flagPoleWidth: 10
        flagPoleHeight: parent.height
        wavingFrequency: 1.5
    }
   
    FlagEffect{
        id:flageffect2
        z:2
        x:flageffect1.x + 220
        y:flageffect1.y
        height:200
        width: 300
        flagPic:"images/Qt_logo.png"
        flagPoleWidth: 10
        flagPoleHeight: parent.height
        wavingFrequency: 1.3
    }

    FlagEffect{
        id:flageffect3
        z:1
        x:flageffect2.x+220
        y:flageffect2.y
        height:200
        width: 300
        flagPic:"images/cienet_logo.png"
        flagPoleWidth: 10
        flagPoleHeight: parent.height
        wavingFrequency: 1.0
    }
}
