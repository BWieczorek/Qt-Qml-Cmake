import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Window 2.3
    Window {
        id: root
        flags: Qt.FramelessWindowHint
        height: 250
        width: 800
        color: "transparent"
        property string textS: ""
        property var textToVar: []

        signal setAdress(var adressS,var portS)

        FontLoader {
            id: standardFont
            source: "qrc:/assetsMenu/agency_fb.ttf"
        }

        Rectangle {
            anchors.fill: parent
            color: "#494F5F"
            radius: 10
            opacity: 0.85
            layer.enabled: true
            clip: true
            Rectangle { //topBar
                anchors{
                    top: parent.top
                    left:parent.left
                    right: parent.right
                }
                color: "#2F3243"
                height: parent.height*0.1
                radius: 10
                opacity: 1
                Rectangle{ //topBar radiusFix
                    anchors{
                        top: parent.verticalCenter
                        left:parent.left
                        right: parent.right
                    }
                    color: "#2F3243"
                    height: parent.height*0.5
                    opacity: 1
                }
                Rectangle {
                    height: parent.height*0.75
                    width: parent.height*0.75
                    radius: width
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: height*0.5
                    opacity: 1
                    color: "#F2B81E"
                    border{
                        color: "Black"
                        width: width*0.05
                    }
                    Rectangle{
                        width: parent.width*0.7
                        height: parent.height*0.1
                        antialiasing: true
                        anchors.centerIn: parent
                        color: "#2C2F3E"
                        rotation: 45
                    }
                    Rectangle{
                        width: parent.width*0.7
                        height: parent.height*0.1
                        antialiasing: true
                        anchors.centerIn: parent
                        color: "#2C2F3E"
                        rotation: 135
                    }

                    MouseArea {
                        anchors.fill:parent
                        onClicked: {
                            root.visible=false;
                        }
                    }
                }
            }

        }
        Image { //TextInput background
            id: textInputRectangle
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
                verticalCenterOffset: parent.height*0.08
            }
            height: parent.height*0.22
            width: parent.width*0.5
            source: "qrc:/assetsMenu/addressBox.png"
            TextInput {
                id: textInputTXT
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                height: parent.height*0.36
                width: parent.width*0.8
                font.pointSize: parent.height*0.33
                font.family: standardFont.name
                color: "#3C4151"
                validator: RegExpValidator {regExp: /((((localhost)|(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])[.]){3}(([2]([0-4][0-9]|[5][0-5])|[0-1]?[0-9]?[0-9])))(:[0-9]{1,5})?[;]?)+)/ }
                property string placeholderText: "Enter address:port ..."

                  Text {
                      text: (textInputTXT.placeholderText).toUpperCase()
                      color: "#3C4151"
                      font.family: standardFont.name
                      font.pixelSize: parent.font.pixelSize
                      anchors.verticalCenter: parent.verticalCenter
                      visible: !textInputTXT.text && !textInputTXT.activeFocus // <----------- ;-)
                  }
              }

            }

        Rectangle{ //accpetButton
            id:accpetButton
            color: "#3C4151"
            width: parent.width*0.16
            height: parent.height*0.17
            radius: height*0.5
            anchors {
                bottom: parent.bottom
                bottomMargin: parent.height*0.05
                left: parent.left
                leftMargin: parent.width*0.05
            }
            border{
                color: "#F2B81E"
                width: parent.height*0.005
            }

            Text{
                text: "ACCEPT"
                anchors.centerIn: parent
                font.family: standardFont.name
                font.pixelSize: parent.height*0.5
                color: "#F2B81E"
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    textS = textInputTXT.text
                    textToVar = textS.split(':')
                    setAdress(textToVar[0],textToVar[1])
                    root.visible=false;
                    textInputTXT.text = ""
                }
            }
        }
        Rectangle { //cancelButton
            id: cancelButton
            color: "#3C4151"
            radius: height*0.5
            width: parent.width*0.16
            height: parent.height*0.17
            anchors {
                verticalCenter: accpetButton.verticalCenter
                left: accpetButton.right
                leftMargin: parent.width*0.05
            }
            border{
                color: "#F2B81E"
                width: parent.height*0.005
            }
            Text{
                text: "CANCEL"
                anchors.centerIn: parent
                font.family: standardFont.name
                font.pixelSize: parent.height*0.5
                color: "#F2B81E"
                font.bold: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.visible = false
                    textInputTXT.text = ""
                }
            }
        }
        Text {
            text: "PRESS REQUEST ADDRESS"
            anchors {
                bottom: textInputRectangle.top
                bottomMargin: parent.height*0.1
                horizontalCenter: parent.horizontalCenter
            }
            font.pointSize: parent.height*0.08
            font.bold: true
            font.family: standardFont.name
            color: "#F2B81E"
            opacity: 95


        }
    }
