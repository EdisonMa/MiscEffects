import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle 
{
    id:root
    width: 320
    height: 500
    color: "grey"
   
    Image 
    {
        id: cup
        width: parent.width*0.4
        height: width
        source: "images/cup.png"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    SmokeEffect
    {
       x: cup.x
       anchors.fill: parent
       smokePoint: Qt.point(cup.x,parent.height - cup.height+ 50)
       smokeWidth: cup.width*0.5
       smokeHeight: parent.height*0.5
       smokeColor: Qt.rect(77, 77,51, 0)        
    }

}
