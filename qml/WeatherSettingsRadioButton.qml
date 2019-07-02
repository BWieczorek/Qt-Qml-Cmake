import QtQuick 2.0

Item {
property bool buttonState: false
    onButtonStateChanged: {
        if(buttonState){
            buttonImage.source = "qrc:/assetsMenu/CheckedRadioButton.png"
        }
        else {
           buttonImage.source = "qrc:/assetsMenu/BlankRadioButton.png"
        }
    }

    Image {
        id:buttonImage
        anchors.fill: parent
        source: "qrc:/assetsMenu/BlankRadioButton.png"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                buttonState = true;
            }
        }
    }

}
