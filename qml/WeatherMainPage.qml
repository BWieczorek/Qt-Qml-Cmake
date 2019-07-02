import QtQuick 2.0

Item {
    id: root
    anchors.fill: parent
    property string mainTemerature: (generate.temp).toString()//weatherAPIAdapter.temp
    property int windValue: generate.wspeed  //weatherAPIAdapter.windSpeed
    property int rainValue: 0 //weatherAPIAdapter -- getter
    property int sunLevel: 50 //get from backend -- don't know which class field
    property string icon: generate.id
    antialiasing: true
    FontLoader{
        id: standardFont
        source: "qrc:/assetsMenu/agency_fb.ttf"
    }
    onWindValueChanged: {
        var maxwind = 100
        var minwind = 0
        if(windValue < (maxwind/5)-10){
            windDot1.color = "#F8E2A8"
            windDot2.color = "#F8E2A8"
            windDot3.color = "#F8E2A8"
            windDot4.color = "#F8E2A8"
            windDot5.color = "#F8E2A8"
        }
        else if(windValue <((maxwind/5))){
            windDot1.color = "#F6C648"
            windDot2.color = "#F8E2A8"
            windDot3.color = "#F8E2A8"
            windDot4.color = "#F8E2A8"
            windDot5.color = "#F8E2A8"
        }
        else if(windValue <(2*(maxwind/5))){
            windDot1.color = "#F6C648"
            windDot2.color = "#F6C648"
            windDot3.color = "#F8E2A8"
            windDot4.color = "#F8E2A8"
            windDot5.color = "#F8E2A8"
        }
        else if(windValue <(3*(maxwind/5))){
            windDot1.color = "#F6C648"
            windDot2.color = "#F6C648"
            windDot3.color = "#F6C648"
            windDot4.color = "#F8E2A8"
            windDot5.color = "#F8E2A8"
        }
        else if(windValue <(4*(maxwind/5))){
            windDot1.color = "#F6C648"
            windDot2.color = "#F6C648"
            windDot3.color = "#F6C648"
            windDot4.color = "#F6C648"
            windDot5.color = "#F8E2A8"
        }
        else {
            windDot1.color = "#F6C648"
            windDot2.color = "#F6C648"
            windDot3.color = "#F6C648"
            windDot4.color = "#F6C648"
            windDot5.color = "#F6C648"
        }
    }
    onRainValueChanged: {
        var maxrain = 100
        var minrain = 0
        if(rainValue < (maxrain/5)-10){
            rainDot1.color = "#CDE7EF"
            rainDot2.color = "#CDE7EF"
            rainDot3.color = "#CDE7EF"
            rainDot4.color = "#CDE7EF"
            rainDot5.color = "#CDE7EF"
        }
        else if(rainValue <((maxrain/5))){
            rainDot1.color = "#8FD2E7"
            rainDot2.color = "#CDE7EF"
            rainDot3.color = "#CDE7EF"
            rainDot4.color = "#CDE7EF"
            rainDot5.color = "#CDE7EF"
        }
        else if(rainValue <(2*(maxrain/5))){
            rainDot1.color = "#8FD2E7"
            rainDot2.color = "#8FD2E7"
            rainDot3.color = "#CDE7EF"
            rainDot4.color = "#CDE7EF"
            rainDot5.color = "#CDE7EF"
        }
        else if(rainValue <(3*(maxrain/5))){
            rainDot1.color = "#8FD2E7"
            rainDot2.color = "#8FD2E7"
            rainDot3.color = "#8FD2E7"
            rainDot4.color = "#CDE7EF"
            rainDot5.color = "#CDE7EF"
        }
        else if(rainValue <(4*(maxrain/5))){
            rainDot1.color = "#8FD2E7"
            rainDot2.color = "#8FD2E7"
            rainDot3.color = "#8FD2E7"
            rainDot4.color = "#8FD2E7"
            rainDot5.color = "#CDE7EF"
        }
        else {
            rainDot1.color = "#8FD2E7"
            rainDot2.color = "#8FD2E7"
            rainDot3.color = "#8FD2E7"
            rainDot4.color = "#8FD2E7"
            rainDot5.color = "#8FD2E7"
        }
    }
    MouseArea { //just for test before established backed connection
        anchors.fill:parent
        onClicked: {
            windValue = 43
            rainValue = 54
        }
    }


    Image {
        id: weatherMainIcon
        height: parent.height*0.4
        width: parent.width*0.25
        antialiasing: true
        source: ("qrc:/assetsMenu/weatherIcons/" + icon + ".png")
        anchors {
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -parent.height*0.1
            right: parent.right
            rightMargin: parent.height*0.25
        }
       }


    Text {
        id: weatherMainTemerature
        font.pixelSize: parent.height*0.15
        color: "white"
        font.family: standardFont.name
        anchors{
            right: weatherMainIcon.left
            top: weatherMainIcon.top
            rightMargin: parent.width*0.01
        }
        text: mainTemerature + "\u00B0" + "C"
    }
    Text{
        id: weatherCityName
        color: "white"
        text: "Cracow"
        font.family: standardFont.name
        font.pixelSize: parent.height*0.16
        font.bold: true
        anchors{
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -parent.height*0.1
            left: root.left
            leftMargin:  root.height*0.25
        }
    }

//    Rectangle {
//        id: forcastRectangle
//        width: parent.width*0.8
//        color: "transparent"
//        height: parent.height*0.35
//        anchors{
//            verticalCenter: parent.verticalCenter
//            horizontalCenter: parent.horizontalCenter
//            verticalCenterOffset: parent.height*0.15
//        }
//        Rectangle {
//            id: weatherinfo1
//            color: "transparent"
//            height: parent.height
//            width: parent.width*0.184
//            anchors.left: parent.left
//            Image{
//                source: ("qrc:/assetsMenu/weatherIcons/0" + "1" + "d.png")
//                height: parent.height*0.8
//                width: parent.width
//                anchors.centerIn: parent
//            }
//        }
//        Rectangle {
//            id: weatherinfo2
//            color: "transparent"
//            height: parent.height
//            width: parent.width*0.184
//            anchors.left: weatherinfo1.right
//            anchors.leftMargin: parent.width*0.02
//            Image{
//                source: ("qrc:/assetsMenu/weatherIcons/0" + "1" + "d.png")
//                height: parent.height*0.8
//                width: parent.width
//                anchors.centerIn: parent
//            }
//        }
//        Rectangle {
//            id: weatherinfo3
//            color: "transparent"
//            height: parent.height
//            width: parent.width*0.184
//            anchors.left: weatherinfo2.right
//            anchors.leftMargin: parent.width*0.02
//            Image{
//                source: ("qrc:/assetsMenu/weatherIcons/0" + "1" + "d.png")
//                height: parent.height*0.8
//                width: parent.width
//                anchors.centerIn: parent
//            }
//        }
//        Rectangle {
//            id: weatherinfo4
//            color: "transparent"
//            height: parent.height
//            width: parent.width*0.184
//            anchors.left: weatherinfo3.right
//            anchors.leftMargin: parent.width*0.02
//            Image{
//                source: ("qrc:/assetsMenu/weatherIcons/0" + "1" + "d.png")
//                height: parent.height*0.8
//                width: parent.width
//                anchors.centerIn: parent
//            }
//        }
//        Rectangle {
//            id: weatherinfo5
//            color: "transparent"
//            height: parent.height
//            width: parent.width*0.184
//            anchors.left: weatherinfo4.right
//            anchors.leftMargin: parent.width*0.02
//            Image{
//                source: ("qrc:/assetsMenu/weatherIcons/0" + "1" + "d.png")
//                height: parent.height*0.8
//                width: parent.width
//                anchors.centerIn: parent
//            }
//        }
//    }

    Rectangle {
        id: bottomRectangle
        color: "transparent"
        width: parent.width*0.6
        height: parent.height*0.1
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: parent.height*0.1
        }
        Text {
            text: "HUMIDITY"
            font.family: standardFont.name
            font.pixelSize: 0.7*bottomRectangle.height.toFixed(0)
            color: "#F5F0F0"
            anchors{
                bottom: bottomRectangle.top
                horizontalCenter: rainDot3.horizontalCenter
            }
        }
        Text {
            text: "WIND SPEED"
            font.family: standardFont.name
            font.pixelSize: 0.7*bottomRectangle.height.toFixed(0)
            color: "#F5F0F0"
            anchors{
                bottom: bottomRectangle.top
                horizontalCenter: windDot3.horizontalCenter
            }
        }
        Image {
            id: windIcon
            height: parent.height*0.7
            width: parent.height*0.8
            anchors.left: parent.left
            anchors.leftMargin: parent.height*0.1
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/assetsMenu/windIcon.png"

        }
        Rectangle {
            id: windDot1
            height: parent.height*0.4
            width: parent.height*0.4
            radius: parent.height*0.4
            color: "#F8E2A8"
            anchors {
                left: windIcon.right
                leftMargin: parent.height*0.15
                verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: windDot2
            height: parent.height*0.4
            width: parent.height*0.4
            radius: parent.height*0.4
            color: "#F8E2A8"
            anchors {
                left: windDot1.right
                leftMargin: parent.height*0.15
                verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: windDot3
            height: parent.height*0.4
            width: parent.height*0.4
            radius: parent.height*0.4
            color: "#F8E2A8"
            anchors {
                left: windDot2.right
                leftMargin: parent.height*0.15
                verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: windDot4
            height: parent.height*0.4
            width: parent.height*0.4
            radius: parent.height*0.4
            color: "#F8E2A8"
            anchors {
                left: windDot3.right
                leftMargin: parent.height*0.15
                verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: windDot5
            height: parent.height*0.4
            width: parent.height*0.4
            radius: parent.height*0.4
            color: "#F8E2A8"
            anchors {
                left: windDot4.right
                leftMargin: parent.height*0.15
                verticalCenter: parent.verticalCenter
            }
        }


        //-----------------------------
        Image {
            id: rainIcon
            height: parent.height*0.7
            width: parent.height*0.6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -parent.width*0.08
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/assetsMenu/rainIcon.png"
        }
        Rectangle {
            id: rainDot1
            height: parent.height*0.4
            width: parent.height*0.4
            radius: parent.height*0.4
            color: "#CDE7EF"
            anchors {
                left: rainIcon.right
                leftMargin: parent.height*0.15
                verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: rainDot2
            height: parent.height*0.4
            width: parent.height*0.4
            radius: parent.height*0.4
            color: "#CDE7EF"
            anchors {
                left: rainDot1.right
                leftMargin: parent.height*0.15
                verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: rainDot3
            height: parent.height*0.4
            width: parent.height*0.4
            radius: parent.height*0.4
            color: "#CDE7EF"
            anchors {
                left: rainDot2.right
                leftMargin: parent.height*0.15
                verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: rainDot4
            height: parent.height*0.4
            width: parent.height*0.4
            radius: parent.height*0.4
            color: "#CDE7EF"
            anchors {
                left: rainDot3.right
                leftMargin: parent.height*0.15
                verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: rainDot5
            height: parent.height*0.4
            width: parent.height*0.4
            radius: parent.height*0.4
            color: "#CDE7EF"
            anchors {
                left: rainDot4.right
                leftMargin: parent.height*0.15
                verticalCenter: parent.verticalCenter
            }
        }
        Text{
            id: sunText
            font.pixelSize: parent.height*0.8
            text: sunLevel.toString();
            color: "white"
            font.family: standardFont.name
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: parent.height*0.2
        }
        Image {
            id: sunIcon
            height: parent.height*0.7
            width: parent.height*0.7
            source: "qrc:/assetsMenu/sunLevel.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: sunText.left
            anchors.rightMargin: parent.height*0.2
        }


    }
}
