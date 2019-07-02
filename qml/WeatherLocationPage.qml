import QtQuick 2.0

Item {
anchors.fill: parent
property bool planePosAsSource: true
FontLoader{
    id: standardFont
    source: "qrc:/assetsMenu/agency_fb.ttf"
}

onPlanePosAsSourceChanged: {
    if(planePosAsSource == true){
        planePositionRadioButton.buttonState = true;
        operatorPositionRadioButton.buttonState = false;
    }
    else {
        planePositionRadioButton.buttonState = false;
        operatorPositionRadioButton.buttonState = true;
    }
}

Text {
    font.family: standardFont.name
    text: "Location:"
    font.pixelSize: parent.height*0.15
    color: "white"
    anchors {
        left: parent.left
        top: parent.top
        leftMargin: parent.width*0.05
        topMargin: parent.height*0.1
    }
}
Text {
    id: planePosition
    font.family: standardFont.name
    text: "Plane position:"
    font.pixelSize: parent.height*0.10
    color: "white"
    anchors {
        left: parent.left
        verticalCenter: parent.verticalCenter
        leftMargin: parent.width*0.5
    }

    WeatherSettingsRadioButton {
                id:planePositionRadioButton
                width: planePosition.font.pixelSize
                height: planePosition.font.pixelSize
                anchors{
                left: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: planePosition.font.pixelSize*0.8
                }
                buttonState: planePosAsSource
                onButtonStateChanged: {
                    if(buttonState == true){
                        planePosAsSource = true
                    }
                    else{
                        buttonState=false
                    }
                }
    }
}
Text {
    id:operatorPosition
    font.family: standardFont.name
    text: "Operator position:"
    font.pixelSize: parent.height*0.10
    color: "white"
    anchors {
        right: planePosition.right
        verticalCenter: parent.verticalCenter
        verticalCenterOffset: parent.height*0.12
    }

    WeatherSettingsRadioButton {
          id:operatorPositionRadioButton
          width: planePosition.font.pixelSize
          height: planePosition.font.pixelSize
          anchors{
            left: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: operatorPosition.font.pixelSize*0.8
                }
          buttonState: !(planePosAsSource)
                onButtonStateChanged: {
                    if(buttonState == true){
                        planePosAsSource = false
                    }
                    else{
                        planePosAsSource = true
                    }
                }
    }
}

}
