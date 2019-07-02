import QtQuick 2.0

Image {
    id: menuImage
    width: parent.width*4
    height: parent.height*2
    source: {
        if(parent.notify===false){
            source="qrc:/assetsMenu/NOTIFY DIALOG OFF.png"

        }
        else {
            source="qrc:/assetsMenu/NOTIFY DIALOG ON.png"
        }
    }

    anchors {
        left: parent.right
        verticalCenter: parent.verticalCenter
    }

    property bool currentState:false
    MouseArea {
        height: parent.height/3
        width: parent.width
        anchors {
            bottom: parent.bottom
        }
        onClicked: {
            parent.parent.notify=false
            menuImage.source="qrc:/assetsMenu/NOTIFY DIALOG OFF.png"
            menuImage.parent.source ="qrc:/assetsMenu/NOTIFY BELL.png"

        }
    }
    MouseArea {
        height: parent.height/3
        width: parent.width
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        onClicked: {
            parent.parent.notify=true
            menuImage.source="qrc:/assetsMenu/NOTIFY DIALOG ON.png"
            menuImage.parent.source ="qrc:/assetsMenu/NOTIFY BELL ON.png"
        }
    }

    }


