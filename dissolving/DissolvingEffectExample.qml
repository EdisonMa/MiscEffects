import QtQuick 2.0

Rectangle {
    width: 800
    height: 400
    id: root
    color: "blue"
    
    Image 
    {
       id : skypic
       source : "img/sky.jpg" 
       anchors.centerIn: parent
       visible: false          
    }

    DissolvingEffect
    {
      id: dissolvingeffect
      width: root.width
      height:  root.height 
      bgpic: skypic
      transparency: 0.4
      speed: 30000
    }     

}
