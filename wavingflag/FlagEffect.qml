// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0

ShaderEffect{
//    anchors.fill: parent
    id: flagwaving
    property url flagPic
    property real flagPoleWidth
    property real flagPoleHeight
    property real wavingFrequency: 1.0

    Image{
        id:flag
        height: parent.height
        width: parent.width
        source: flagPic 
        visible: false
    }

    Rectangle{
        anchors.right: parent.left
        anchors.top: parent.top
        anchors.topMargin:  - 10
        width: parent.flagPoleWidth
        height: parent.flagPoleHeight
        radius: 5
        border.color: "#919190"
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#e8dddd";
            }
            GradientStop {
                position: 0.20;
                color: "#eeeedd";
            }
            GradientStop {
                position: 0.86;
                color: "#afaaaa";
            }
            GradientStop {
                position: 1.00;
                color: "#918f8f";
            }
        }
    }   
    
    ParallelAnimation {
            running: true
            loops: Animation.Infinite
            SequentialAnimation{
                NumberAnimation { target: flagwaving; property: "theta"; to: 0; duration: 35000*wavingFrequency }
                ScriptAction{script: flagwaving.theta = 360}
            }
            SequentialAnimation{
                NumberAnimation { target: flagwaving; property: "w"; easing.type: Easing.OutInCubic; to: 200.0; duration: 35000*wavingFrequency }
                ScriptAction{script: flagwaving.w = 80}
            }
        }

    

    mesh:GridMesh{
        resolution: Qt.size(200,200)
    }
    property real factor1:0.1
    property real factor2:0.9
    property real originalX1: -10.0
    property real originalY1: height*0.2
    property real originalX2: -50.0
    property real originalY2
    property real amplitude: 0.1
    property real theta:360
    property real   w: 80.0
    property variant source : flag

    vertexShader:
        "
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;
        uniform highp mat4 qt_Matrix;
        varying highp vec2 qt_TexCoord0;
        varying lowp float shade;


        uniform highp float originalX1;
        uniform highp float originalY1;
        uniform highp float originalX2;
        uniform highp float originalY2;
        uniform highp float theta;
        uniform highp float w;

       void main() {
            const highp float twopi = 3.141592653589 * 2.0;
            qt_TexCoord0 = qt_MultiTexCoord0;
            highp vec4 shift = vec4(.0,.0,.0,.0);
            highp vec4 grav = vec4(.0,.0,.0,.0);
            if(qt_Vertex.x >= 10.0)
            {
                shift.y = cos(((qt_Vertex.x - originalX1) /255.0)*twopi +theta);
                shift.y += ( sin(( sqrt(pow(qt_Vertex.x - originalX2, 2.0)+pow(qt_Vertex.y - originalY2, 2.0)) /w)*twopi + theta));
                shift.y *= qt_Vertex.x * (0.04 - theta/10000.0);
                shift.x = -2.0 * shift.y;
                grav.y =-qt_Vertex.x/10.0;
            }
            shade =clamp( -shift.y*0.06, -0.3, 0.3);
            gl_Position = qt_Matrix * (qt_Vertex  -  shift - grav);
        }
        "
    fragmentShader:
        "
        varying highp vec2 qt_TexCoord0;
        uniform sampler2D source;
        varying lowp float shade;
        void main() {
            highp vec4 color = texture2D(source, qt_TexCoord0);
            color.rgb *= 1.0-shade;
            gl_FragColor = color;
        }
        "
}
