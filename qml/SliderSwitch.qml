import QtQuick 2.0

Item {
    property real size
    property color onstatecolor
    property color offstatecolor
    property bool status: false
id: root
width: size*1.3
height: size*1.1


    Rectangle{
        id: slider
    color: offstatecolor
    height: size*0.4
    width: size
    radius: 0.8*size
    anchors {
    verticalCenter: parent.verticalCenter
    horizontalCenter: parent.horizontalCenter
    }
    }
    Rectangle {
        id: ball
        color: "#F1F1F1"
        width: size*0.5
        height: size*0.5
        radius: size*0.5
        border {
            color: "black"
            width: size*0.005
        }
        Behavior on anchors.horizontalCenterOffset   {SmoothedAnimation {velocity: 250}}

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: size/2
        }  

    }
    state: "off"
    states: [
        State {
                name: "off"
                PropertyChanges {
                    target: ball
                    anchors.horizontalCenterOffset: -size/2
                    color: "#F1F1F1"
                }
                PropertyChanges {
                    target: slider
                    color: offstatecolor
                    opacity: 1

                }
                PropertyChanges {
                    target: root
                    status: false
                }
            },
    State {
            name: "on"
            PropertyChanges {
                target: ball
                anchors.horizontalCenterOffset: size/2
                color : onstatecolor

            }
            PropertyChanges {
                target: slider
                color: onstatecolor
                opacity: 0.5

            }
            PropertyChanges {
                target: root
                status: true
            }
        }


]
    MouseArea {
        anchors.fill: root
        hoverEnabled: true;
        onClicked: {
            root.state =(root.state == "on" ? root.state = "off" : root.state = "on")
        }
    }
}
