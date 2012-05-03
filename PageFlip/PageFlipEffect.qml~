import QtQuick 2.0

Rectangle {
    id:main
    property variant model

    property real offsetX
    property real offsetY
    property bool autorun: false
    property real curindex: 0
    function processEffect()  {
        var tb;
        if(offsetX <= 0) offsetX = 1;
        if(offsetY <= 0) offsetY = 1;//if offsetY <0 ,effect.a will be >0
        if(offsetX > 2*effect.width)  offsetX = 2*effect.width;
        if(offsetY > 2*effect.height)  offsetY = 2*effect.height;
        effect.a =  - offsetX/offsetY ;
        tb =  effect.height - offsetY/2.0 + effect.width*offsetX/offsetY - Math.pow(offsetX, 2.0)/(2.0*offsetY);
        effect.aone =  Math.pow(effect.a, 2.0) +1.0;
        if(effect.a <0)  {
            if(tb < effect.height && tb > 0)
                tb = effect.height;
            else if(tb === NaN)
                tb =10000;
        }
        else  {
            if(tb > 0)
                tb =0;
        }
        effect.b = tb;
    }
    function autoprocess(){
        if((offsetX < 2*effect.width) || (offsetY  > 1)) {
            offsetX +=3;
            offsetY -=0.5;
        }
        else {
            autorun = false;
            turnover();
        }
        processEffect();
    }
    function turnover() {
        shadersource.sourceItem = toppage
        curindex ++
        toppage.source = model.get(curindex ).src
        if(curindex  >= model.count-1){
            bottompage.source =model.get( 0).src
            curindex = -1
            }
        else
            bottompage.source =model.get( curindex + 1).src

        offsetX = 0
        offsetY =0
    }    

    Item{
        id:rights
        width:main.width
        height: main.height
        Image {
            id: bottompage
            source: model.get(curindex + 1).src
            anchors.fill: parent
        }
        Image {
            id: toppage
            source: model.get(curindex ).src
            anchors.fill: parent
        }

        ShaderEffect{
            id:effect
            anchors.fill: parent            
            ShaderEffectSource{id:shadersource;sourceItem: toppage;hideSource: true}
            Component.onCompleted: {
                main.offsetX =20;
                main.offsetY =  5;
                main.processEffect();
            }
            mesh:GridMesh
            {
              resolution: Qt.size(220,220)
            }
            property variant source:shadersource
            property real  a: 0.0
            property real  b: 0.0
            property real   aone:0.0

            vertexShader:
            "
                 attribute highp vec4 qt_Vertex;
                 attribute highp vec2 qt_MultiTexCoord0;
                 uniform highp mat4 qt_Matrix;
                 uniform lowp float qt_Opacity;
                 varying highp vec2 qt_TexCoord0;

                 uniform highp float a;
                 uniform highp float b;
                 uniform highp float aone;
                 varying lowp float shade;

                 void main()
                 {
                     qt_TexCoord0 = qt_MultiTexCoord0;
                     highp vec4 temp = vec4(qt_Vertex);
                     shade =0.0;
                     if(b >0.0)
                     {
                         if(qt_Vertex.y > (a*qt_Vertex.x + b ))
                         {
                           temp.x = (2.0*a*(qt_Vertex.y - b) + qt_Vertex.x*(1.0-pow(a,2.0)))/aone;
                           temp.y = (pow(a, 2.0) *qt_Vertex.y  + 2.0*a*qt_Vertex.x + 2.0*b - qt_Vertex.y)/aone;
                           shade = 50.0/(qt_Vertex.y - a*qt_Vertex.x - b);
                           shade = clamp(shade, 0.0, 1.0);
                          }
                     }
                     else
                     {
                         if(qt_Vertex.y <=(a*qt_Vertex.x + b ))
                         {
                           temp.x = (2.0*a*(qt_Vertex.y - b) + qt_Vertex.x*(1.0-pow(a,2.0)))/aone;
                           temp.y = (pow(a, 2.0) *qt_Vertex.y  + 2.0*a*qt_Vertex.x + 2.0*b - qt_Vertex.y)/aone;
                           shade = -50.0/(qt_Vertex.y - a*qt_Vertex.x - b);
                           shade = clamp(shade, 0.0, 1.0);
                          }
                         else
                         {
                           temp.z -= 1.0;
                         }
                     }
                     gl_Position=qt_Matrix *temp;
                 }
             "
         fragmentShader:
             "
                 varying highp vec2 qt_TexCoord0;
                 uniform sampler2D source;
                 varying lowp float shade;

                 void main()
                 {
                   highp vec4 color = texture2D(source, qt_TexCoord0);
                   color.rgb *= 1.0 - shade*vec3(0.8,0.8,0.7);
                   gl_FragColor = color;
                 }
             "
        }

        MouseArea{
            id:ma
            anchors.fill: parent
            onPositionChanged: {
                main.autorun = false;
                if(pressed)  {
                    offsetX = effect.width - mouseX;
                    offsetY = effect.height - mouseY;
                    main.processEffect();
                }
            }
            onReleased: {
                if(released)  {
                    if(offsetX  > 0.5*effect.width)  {
                        main.autorun = true;
                    }
                }
            }
        }

        Timer {
            interval: 10; running: main.autorun; repeat: true
            onTriggered: main.autoprocess()
        }
    }
}
