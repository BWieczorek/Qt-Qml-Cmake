import QtQuick 2.0

Item {
    id: root
anchors.fill: parent
property int pageState: 0
property bool settingsTemperature: true
property bool settingsWindUnit: true
property bool settingsAccuracy: true
property bool settingsWindMarker: true
FontLoader{
    id: standardFont
    source: "qrc:/assetsMenu/agency_fb.ttf"
}
Component.onCompleted: {
    pageState = 1
}
onPageStateChanged: {
    switch (pageState){
    case 1:
        bar1.opacity = 1
        bar2.opacity = 0.4
        bar3.opacity = 0.4
        bar4.opacity = 0.4
        pageLoader.sourceComponent = page1
        break;
    case 2:
        bar1.opacity = 0.4;
        bar2.opacity = 1;
        bar3.opacity = 0.4
        bar4.opacity = 0.4
        pageLoader.sourceComponent = page2
        break;
    case 3:
        bar1.opacity = 0.4
        bar2.opacity = 0.4
        bar3.opacity = 1
        bar4.opacity = 0.4
        pageLoader.sourceComponent = page3
        break;
    case 4:
        bar1.opacity = 0.4
        bar2.opacity = 0.4
        bar3.opacity = 0.4
        bar4.opacity = 1
        pageLoader.sourceComponent = page4
        break;
    default:
        pageState = 1

    }

}
Rectangle {
    id:page
    width: parent.width*1.1
    height: parent.height*0.75
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    color: "transparent"
    Loader {
        id: pageLoader
        anchors.fill: parent
        sourceComponent: page1
    }
}

Rectangle {
    width: parent.width*0.4
    height: parent.height*0.03
    color: "transparent"
    anchors {
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
        verticalCenterOffset: parent.height*0.3
    }

    Rectangle {
        id: bar1
        width: parent.width*0.2
        height: parent.height*0.8
        radius: parent.height*0.2
        color: "#F2B81E"
        opacity: 0.4
        anchors{
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                pageState = 1

            }
        }
    }
    Rectangle {
        id: bar2
        width: parent.width*0.2
        height: parent.height*0.8
        radius: parent.height*0.2
        color: "#F2B81E"
        opacity: 0.4
        anchors{
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -parent.width*0.13
            verticalCenter: parent.verticalCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                pageState = 2

            }
        }
    }
    Rectangle {
        id: bar3
        width: parent.width*0.2
        height: parent.height*0.8
        radius: parent.height*0.2
        color: "#F2B81E"
        opacity: 0.4
        anchors{
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: parent.width*0.13
            verticalCenter: parent.verticalCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                pageState = 3

            }
        }
    }
    Rectangle {
        id: bar4
        width: parent.width*0.2
        height: parent.height*0.8
        radius: parent.height*0.2
        color: "#F2B81E"
        opacity: 0.4
        anchors{
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                pageState = 4

            }
        }
    }
}
Component{
    id: page1
    Rectangle{
        layer.enabled: true
        id: page1Root
        anchors.fill: parent
        color: "transparent"
        property bool tempInCelsius: root.settingsTemperature
        onTempInCelsiusChanged: {
            root.settingsTemperature = tempInCelsius
            if(tempInCelsius == true){
                inCelsiusRadioButton.buttonState = true;
                inFahrenheitRadioButton.buttonState = false;
            }
            else {
                inCelsiusRadioButton.buttonState = false;
                inFahrenheitRadioButton.buttonState = true;
            }
        }




    FontLoader{
        id: standardFont
        source: "qrc:/assetsMenu/agency_fb.ttf"
    }
    Text {
        font.family: standardFont.name
        text: "Show the temperature:"
        font.pixelSize: parent.height*0.2
        color: "white"
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: parent.width*0.08
            topMargin: parent.height*0.1
        }
    }
    Text {
        id: inCelsius
        font.family: standardFont.name
        text: "in degrees Celsius"
        font.pixelSize: parent.height*0.15
        color: "white"
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: parent.width*0.4
        }
        WeatherSettingsRadioButton {
                    id: inCelsiusRadioButton
                    width: inCelsius.font.pixelSize
                    height: inCelsius.font.pixelSize
                    anchors{
                    left: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: inCelsius.font.pixelSize*0.8
                    }
                    buttonState: page1Root.tempInCelsius
                    onButtonStateChanged: {
                        if(buttonState == true){
                            page1Root.tempInCelsius = true
                        }
                        else{
                            buttonState=false
                        }
                    }
        }
    }
    Text {
        id: inFahrenheit
        font.family: standardFont.name
        text: "in degrees Fahrenheit"
        font.pixelSize: parent.height*0.15
        color: "white"
        anchors {
            right: inCelsius.right
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: parent.height*0.2
        }

        WeatherSettingsRadioButton {
              id: inFahrenheitRadioButton
              width: inCelsius.font.pixelSize
              height: inCelsius.font.pixelSize
              anchors{
                left: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: inFahrenheit.font.pixelSize*0.8
                    }
              buttonState: !(page1Root.tempInCelsius)
                    onButtonStateChanged: {
                        if(buttonState == true){
                            page1Root.tempInCelsius = false
                        }
                        else{
                            page1Root.tempInCelsius = true
                        }
                    }
        }
    }
}

  }



Component {
    id: page2
    Rectangle{
        layer.enabled: true
        id: page2Root
        anchors.fill: parent
        color: "transparent"
        property bool windUnit: root.settingsWindUnit
        onWindUnitChanged: {
            root.settingsWindUnit = windUnit
            if(windUnit == true){
                inKmpHRadioButton.buttonState = true;
                inMpHRadioButton.buttonState = false;
            }
            else {
                inKmpHRadioButton.buttonState = false;
                inMpHRadioButton.buttonState = true;
            }
        }




    FontLoader{
        id: standardFont
        source: "qrc:/assetsMenu/agency_fb.ttf"
    }
    Text {
        font.family: standardFont.name
        text: "Show the wind:"
        font.pixelSize: parent.height*0.2
        color: "white"
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: parent.width*0.08
            topMargin: parent.height*0.1
        }
    }
    Text {
        id: inKmpH
        font.family: standardFont.name
        text: "in kilometers per hours"
        font.pixelSize: parent.height*0.15
        color: "white"
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: parent.width*0.3
        }
        WeatherSettingsRadioButton {
                    id: inKmpHRadioButton
                    width: inKmpH.font.pixelSize
                    height: inKmpH.font.pixelSize
                    anchors{
                    left: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: inKmpH.font.pixelSize*0.8
                    }
                    buttonState: page2Root.windUnit
                    onButtonStateChanged: {
                        if(buttonState == true){
                            page2Root.windUnit = true
                        }
                        else{
                            buttonState=false
                        }
                    }
        }
    }
    Text {
        id: inMpH
        font.family: standardFont.name
        text: "in meters per hours"
        font.pixelSize: parent.height*0.15
        color: "white"
        anchors {
            right: inKmpH.right
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: parent.height*0.2
        }

        WeatherSettingsRadioButton {
              id: inMpHRadioButton
              width: inKmpH.font.pixelSize
              height: inKmpH.font.pixelSize
              anchors{
                left: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: inMpH.font.pixelSize*0.8
                    }
              buttonState: !(page2Root.windUnit)
                    onButtonStateChanged: {
                        if(buttonState == true){
                            page2Root.windUnit = false
                        }
                        else{
                            page2Root.windUnit = true
                        }
                    }
        }
    }
}

}
Component {
    id: page3
    Rectangle{
        layer.enabled: true
        id: page3Root
        anchors.fill: parent
        color: "transparent"
        property bool accuracyStatus: root.settingsAccuracy
        onAccuracyStatusChanged: {
            root.settingsAccuracy = accuracyStatus
            if(accuracyStatus == true){
                inUnityRadioButton.buttonState = true;
                inDecimalRadioButton.buttonState = false;
            }
            else {
                inUnityRadioButton.buttonState = false;
                inDecimalRadioButton.buttonState = true;
            }
        }




    FontLoader{
        id: standardFont
        source: "qrc:/assetsMenu/agency_fb.ttf"
    }
    Text {
        font.family: standardFont.name
        text: "Temperature accuracy:"
        font.pixelSize: parent.height*0.2
        color: "white"
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: parent.width*0.08
            topMargin: parent.height*0.1
        }
    }
    Text {
        id: inUnity
        font.family: standardFont.name
        text: "up to 1°"
        font.pixelSize: parent.height*0.15
        color: "white"
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: parent.width*0.62
        }
        WeatherSettingsRadioButton {
                    id: inUnityRadioButton
                    width: inUnity.font.pixelSize
                    height: inUnity.font.pixelSize
                    anchors{
                    left: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: inUnity.font.pixelSize*0.8
                    }
                    buttonState: page3Root.accuracyStatus
                    onButtonStateChanged: {
                        if(buttonState == true){
                            page3Root.accuracyStatus = true
                        }
                        else{
                            buttonState=false
                        }
                    }
        }
    }
    Text {
        id: inDecimal
        font.family: standardFont.name
        text: "up to 0.1°"
        font.pixelSize: parent.height*0.15
        color: "white"
        anchors {
            right: inUnity.right
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: parent.height*0.2
        }

        WeatherSettingsRadioButton {
              id: inDecimalRadioButton
              width: inUnity.font.pixelSize
              height: inUnity.font.pixelSize
              anchors{
                left: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: inDecimal.font.pixelSize*0.8
                    }
              buttonState: !(page3Root.accuracyStatus)
                    onButtonStateChanged: {
                        if(buttonState == true){
                            page3Root.accuracyStatus = false
                        }
                        else{
                            page3Root.accuracyStatus = true
                        }
                    }
        }
    }
}
}
Component {
    id: page4
    Rectangle{
        layer.enabled: true
        id: page4Root
        anchors.fill: parent
        color: "transparent"
        property bool markerStatus: root.settingsWindMarker
        onMarkerStatusChanged: {
            root.settingsWindMarker = markerStatus
            if(markerStatus == true){
                inIndicatorRadioButton.buttonState = true;
                inNumericRadioButton.buttonState = false;
            }
            else {
                inIndicatorRadioButton.buttonState = false;
                inNumericRadioButton.buttonState = true;
            }
        }




    FontLoader{
        id: standardFont
        source: "qrc:/assetsMenu/agency_fb.ttf"
    }
    Text {
        font.family: standardFont.name
        text: "Show wind speed and humidity:"
        font.pixelSize: parent.height*0.2
        color: "white"
        anchors {
            left: parent.left
            top: parent.top
            leftMargin: parent.width*0.08
            topMargin: parent.height*0.1
        }
    }
    Text {
        id: inIndicator
        font.family: standardFont.name
        text: "indicator"
        font.pixelSize: parent.height*0.15
        color: "white"
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: parent.width*0.59
        }
        WeatherSettingsRadioButton {
                    id: inIndicatorRadioButton
                    width: inIndicator.font.pixelSize
                    height: inIndicator.font.pixelSize
                    anchors{
                    left: parent.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: inIndicator.font.pixelSize*0.8
                    }
                    buttonState: page4Root.markerStatus
                    onButtonStateChanged: {
                        if(buttonState == true){
                            page4Root.markerStatus = true
                        }
                        else{
                            buttonState=false
                        }
                    }
        }
    }
    Text {
        id: inNumeric
        font.family: standardFont.name
        text: "value"
        font.pixelSize: parent.height*0.15
        color: "white"
        anchors {
            right: inIndicator.right
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: parent.height*0.2
        }

        WeatherSettingsRadioButton {
              id: inNumericRadioButton
              width: inIndicator.font.pixelSize
              height: inIndicator.font.pixelSize
              anchors{
                left: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: inNumeric.font.pixelSize*0.8
                    }
              buttonState: !(page4Root.markerStatus)
                    onButtonStateChanged: {
                        if(buttonState == true){
                            page4Root.markerStatus = false
                        }
                        else{
                            page4Root.markerStatus = true
                        }
                    }
        }
    }
}
}
}
