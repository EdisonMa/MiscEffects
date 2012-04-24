import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {  
    id: root  
    width: 800
    height: 400
    color: "black"

    Universe
    {
      width: parent.width
      height: parent.height
    }

    Sphere
    {
      id: movingsphere
      width: parent.width
      height: parent.height
      interval: 2000
      repeat: true
    }

    ExplosionEffect
    {
      width: parent.width
      height: parent.height
      enabled: movingsphere.colliding
      flashpoint: movingsphere.collidepoint
    }
}
