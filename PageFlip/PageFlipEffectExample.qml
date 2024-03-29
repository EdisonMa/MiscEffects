import QtQuick 2.0

Rectangle {
    id:main
    width: 320
    height: 480   
    color:"white"
    
    ListModel{
        id:pics
        ListElement{src:"images/01.jpg"}
        ListElement{src:"images/02.jpg"}
        ListElement{src:"images/03.jpg"}
        ListElement{src:"images/04.jpg"}
        ListElement{src:"images/05.jpg"}
        ListElement{src:"images/06.jpg"}
        ListElement{src:"images/07.jpg"}
        ListElement{src:"images/08.jpg"}
        ListElement{src:"images/09.jpg"}
        ListElement{src:"images/10.jpg"}
    }

    PageFlipEffect
    {
      model: pics
      width: parent.width*0.8
      height: parent.height*0.8
      anchors.verticalCenter: parent.verticalCenter
    }

    
}
