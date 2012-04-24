import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {
    width: 800
    height: 400    
    Image 
    {
         source : "img/snowflake-background.jpg" 
         width: parent.width
         height: parent.height
    }
    
    SnowEffect
    {
        id: snoweffect 
        width: parent.width
        height: parent.height
        snowflakepic1: "img/snowflake1-white.png"
        snowflakepic2: "img/snowflake3-white.png"
        speed1: 40
        speed2: 40
        intensity1: 120
        intensity2: 16
        size1: 10
        size2: 15
    }
    
    
}

