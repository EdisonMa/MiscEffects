import QtQuick 2.0
import QtQuick.Particles 2.0
Rectangle {
    width: 800
    height: 400
    color: "black"
    FireworkEffect 
    {
       width: parent.width
       height: parent.height
       firework1Enabled: true
       firework2Enabled: true
       firework3Enabled: true
       firework1EmitRate: 1
       firework2EmitRate: 2
       firework3EmitRate: 2       
    }
}
