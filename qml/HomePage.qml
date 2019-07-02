import QtQuick 2.0
import QtLocation 5.9
import QtPositioning 5.8
import "MarkerGenerator.js" as MarkerGenerator
import "distanceCalculator.js" as DistanceCalculator
import "ShowErrors.js" as ShowErrors
import QtCharts 2.0
import "WeatherPageGenerator.js" as WeatherPageGenerator
Item {
    id: root
    signal connectionChanged(var connectionState)
    property int numberOfPoint : 0  //get from JS function
    property real distanceToNextPoint: DistanceCalculator.distanceCalculate();                                                      //DistanceCalculator.distanceCalculate();
    property real constDist: generate.constDistance
    property real longitude : planePosition.longitude //get from backend
    property real latitude: planePosition.latitude  //get from backend
    property string serverAdress : "LOCALHOST" //get from settings (database) or RequestDialog
    property bool connected: startButtonState
    property real transmitterDistance : batteryPercentage //get from backend

    // ------------------------------------------- \\
    property real groundSpeed : Math.sqrt((adapter.Vx)^2+(adapter.Vy)^2) //get from backend
    // ------------------------------------------- \\
    property real altitude : adapter.Alt
    // ------------------------------------------- \\
     property var planePosition: generate.lastPoint
    // ------------------------------------------- \\

    property bool mapFollow: followSwitch.status
    property real xVelocity: adapter.Vx
    property real yVelocity: adapter.Vy
    property string fontFamily: standardFont.name
    property bool notify: false
    property string realPortS: "8080"
    property int numberOfInformation: 0 //get from backend
    property int numberOfWarning: 0
    property int errorIterator: 0
    property var jsonError: ""
    property int numberOfError: 0
    property int informationIterator: 1
    property var requestError: ""
    property var informations: []
    property var sslerror: []
    property int timeElapsed: 0
    property real simVelocity: 23 * (1 - Math.exp(-timeElapsed/3000)) + 5*(1 - 1/Math.sqrt(1) * Math.exp(0* timeElapsed/3000) * Math.sin( Math.sqrt(1)/3000 * timeElapsed))
    property real simVelocityMax: 50
    property real simHeight: 120 * (1 - Math.exp(-timeElapsed/4000)) + 10*(1 - 1/Math.sqrt(1) * Math.exp(0* timeElapsed/4000) * Math.sin( Math.sqrt(1)/4000 * timeElapsed))
    property real simHeightMax: 200
    property real batteryPercentage: 100 - 70 * Math.abs(Math.sin(timeElapsed/1000000))



    Connections {
        target: request
        onSetAdress:{
            serverAdress = adressS
            realPortS = portS
        }

    }
    onBatteryPercentageChanged: {
        if(connected == true){
            transmitterTXT.text = transmitterDistance.toFixed(0).toString() + "%"
            if(transmitterDistance.toFixed(0)<=20){
                transmitterTXT.color = "#ff5900"

            }
        }
    }


//    Connections {
//        //target: //get target from context
//        onSendJSONErrors:{
//            jsonError = err
//        }
//        onSendRequestError:{
//            requestError = err
//        }
//        onSendSslVector:{
//            sslerror = data
//        }
//    }


    Component.onCompleted: {
        sslerror = 0;
        informations = 0;
        ShowErrors.showErrors();
        if(!numberOfInformation){
            informationTXT.text = "Nothing to say"
        }
        else {
            ShowErrors.showInformation();
        }
    }
    Timer {
        repeat: false
        interval: 50
        running: true
        onTriggered: {
            weatherPageBackground.width = weatherBackground.width - weatherSideMenuBackground.width

        }
    }

    onNumberOfInformationChanged: {
        if(!numberOfInformation){
            informationTXT.text = "Nothing to say"
        }
        else {
            ShowErrors.showInformation();
        }
    }


    RequestDialog{
        id:request
    }



    Timer { //information Timer
        interval: 3000; running: true; repeat: true
        onTriggered: {
                if((requestError!==0)||(jsonError!==0)||(sslerror!==0)){
                    ShowErrors.showErrors();
                }

                if(informationIterator<numberOfInformation){
                informationIterator++;
                }
                else {informationIterator = 1;}

            if(!numberOfInformation){
                informationTXT.text = "Nothing to say"
            }
            else {
                ShowErrors.showInformation();
            }
        }
    }

    FontLoader {
        id: standardFont
        source: "qrc:/assetsMenu/agency_fb.ttf"
    }



    anchors.fill: parent
    onPlanePositionChanged: {
        distanceToNextPoint = DistanceCalculator.distanceCalculate()
        if(mapFollow==true){
            map.center = planePosition
        }
    }
    onMapFollowChanged: {
        if(mapFollow==true){
            map.center = planePosition

        }
    }

    onNumberOfPointChanged: {
       distanceToNextPoint = DistanceCalculator.distanceCalculate();
                      }

    onConnectedChanged: {

        if(connected == true )
        {
                //controller.doUpdates(true)
                transmitterTXT.color = "#38865B" //green
                portTXT.color = "#38865B"
                portTXT.text = "Correctly Connected"
                port.color = "#38865B"
                realPort.color = "#38865B"
                realPort.text = "Port: " + realPortS
                port.text = serverAdress.toUpperCase()
                transmitterTXT.text = transmitterDistance.toFixed(1).toString() + "%"
            if(transmitterDistance.toFixed(1)<=20){
                transmitterTXT.color = "#ff5900"

            }
        }
            else
            {
                 //controller.doUpdates(false)
                 transmitterTXT.color = "#DB3D40"
                 portTXT.color = "#DB3D40"//red
                 portTXT.text = "Not Connected"
                 port.color = "#DB3D40"
                 port.text =  "---"
                 realPort.text = "---"
                 realPort.color = "#DB3D40"
                 transmitterTXT.text = "---"
            }

    }
    Rectangle {
        id: mainPage
        anchors.fill: parent
        color: "#292B38"
        border {
            width: 1
            color: "#333644"
        }

        onHeightChanged: {
            if(mapWidget.state == "windowed") {
                mapWidget.height = parent.height*0.5
            }
            else if(mapWidget.state == "fullPage") {
                mapWidget.height = parent.height
            }
        }
        onWidthChanged: {
            if(mapWidget.state == "windowed") {
                mapWidget.width = parent.width*0.5
            }
            else if(mapWidget.state == "fullPage") {
                mapWidget.width = parent.width
            }
        }
                }

    Item {
        id: weatherWidget
        ListModel {
            id: pageList
        }

        width: 0.28*parent.width
        height: 0.28*parent.height
        property bool menuState: false
        anchors {
            top: parent.top
            topMargin: parent.height*0.35
            right: parent.right
            rightMargin: parent.width*0.05
        }
        Component.onCompleted: {
            WeatherPageGenerator.showPage(pageList, 1)
            }

        Image {
            id: weatherBackground
            height: parent.height*1.2
            width: parent.width*1.1
            anchors.centerIn: parent
            source: "qrc:/assetsMenu/weatherBackGround.png"
        }
        Rectangle {
            id:weatherPageBackground
            height: parent.height
            width: weatherBackground.width*0.85
            color: "transparent"
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            NumberAnimation on width{
                id: pageRollOutAnim
                running: false
                //alwaysRunToEnd: true
                from: weatherBackground.width - weatherSideMenuBackground.width
                to: (weatherBackground.width - weatherSideMenuBackground.width)*0.9
                //duration: 1000

            }
            NumberAnimation on width{
                id: pageRollBackAnim
                running: false
                //alwaysRunToEnd: true
                from: (weatherBackground.width - weatherSideMenuBackground.width)*0.9
                to: weatherBackground.width - weatherSideMenuBackground.width
                duration: 1000
            }
        }
            Rectangle {
                id: weatherSideMenuBackground
                width: parent.width*0.15
                height: parent.height
                color: "transparent"
                SequentialAnimation {
                        id: weatherMenuRollBackAnim
                        alwaysRunToEnd: true
                        running: false
                    NumberAnimation {
                        target: weatherRefreshButton
                        alwaysRunToEnd: true
                        property: "height"
                        duration: 330
                        easing.type: Easing.Linear
                        to: 0
                    }
                    NumberAnimation {
                        target: weatherLocationButton
                        alwaysRunToEnd: true
                        property: "height"
                        duration: 330
                        easing.type: Easing.Linear
                        to: 0
                    }
                    NumberAnimation {
                        target: weatherSettingsButton
                        alwaysRunToEnd: true
                        property: "height"
                        duration: 330
                        easing.type: Easing.Linear
                        to: 0
                    }
                }
                    SequentialAnimation {
                            id: weatherMenuRollOutAnim
                            alwaysRunToEnd: true
                            running: false
                        NumberAnimation {
                            target: weatherSettingsButton
                            alwaysRunToEnd: true
                            property: "height"
                            duration: 330
                            easing.type: Easing.Linear
                            to: weatherSideMenuBackground.height*0.25
                        }
                        NumberAnimation {
                            target: weatherLocationButton
                            alwaysRunToEnd: true
                            property: "height"
                            duration: 330
                            easing.type: Easing.Linear
                            to: weatherSideMenuBackground.height*0.25
                        }
                        NumberAnimation {
                            target: weatherRefreshButton
                            alwaysRunToEnd: true
                            property: "height"
                            duration: 330
                            easing.type: Easing.Linear
                            to: weatherSideMenuBackground.height*0.25
                        }
                    }

                Rectangle {
                    id: weatherMainButton
                    width: parent.width
                    height: parent.height*0.25
                    color: "transparent"
                    anchors{
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                    Image {
                        id: weatherMainButtonImage
                        source: "qrc:/assetsMenu/WeatherMenuButton.png"
                        width: parent.width
                        height: parent.height

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                WeatherPageGenerator.showPage(pageList, 1)
                                if(!(pageRollBackAnim.running||weatherMenuRollOutAnim.running)){
                                if(weatherWidget.menuState){
                                    weatherMainButtonImage.source = "qrc:/assetsMenu/WeatherMenuButton.png"
                                    pageRollBackAnim.start();
                                    weatherMenuRollBackAnim.start();
                                    weatherWidget.menuState = false;
                                }
                                else {
                                    weatherMainButtonImage.source = "qrc:/assetsMenu/WeatherMenuButtonClicked.png"
                                    pageRollOutAnim.start();
                                    weatherMenuRollOutAnim.start();
                                    weatherWidget.menuState = true;

                                }
                                }
                            }
                        }
                    }
                }
                Image {
                    id: weatherRefreshButton
                    width: parent.width
                    anchors.top: weatherMainButton.bottom
                    anchors.horizontalCenter: weatherMainButton.horizontalCenter
                    source: "qrc:/assetsMenu/WeatherRefreshButton.png"
                    height: 0
                }
                Image {
                    id:weatherLocationButton
                    width: parent.width
                    anchors.top:  weatherRefreshButton.bottom
                    anchors.horizontalCenter: weatherMainButton.horizontalCenter
                    source: "qrc:/assetsMenu/WeatherLocationButton.png"
                    height: 0
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            WeatherPageGenerator.showPage(pageList, 2)
                        }
                    }
                }
                Image {
                    id:weatherSettingsButton
                    width: parent.width
                    anchors.top:  weatherLocationButton.bottom
                    anchors.horizontalCenter: weatherMainButton.horizontalCenter
                    source: "qrc:/assetsMenu/WeatherSettingsButton.png"
                    height: 0
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            WeatherPageGenerator.showPage(pageList, 3)
                        }
                    }
                }
            }

        }


    Item {
        id: transmitterWidget
        width: 0.13*parent.width
        height: 0.3*parent.height
        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height*0.05
            left: alertsWidget.left
        }
        Rectangle {
            id: transmitterBackground
            anchors.fill:parent
            color: "#2F3243"
            Image {
                anchors.fill:parent
                source: "qrc:/assetsMenu/BatteryStatus.png"
            }
            Text{
                text: "Battery\nStatus"
                wrapMode: text.WordWrap
                width: parent.width*0.5
                font.family: standardFont.name
                font.pixelSize: 0.12*parent.height.toFixed(0)
                color: "#FFFFFF"
                opacity: 0.55
                anchors{
                    top: parent.top
                    left: parent.left
                    topMargin: parent.height*0.04
                    leftMargin: parent.width*0.15
                }
            }

            Text {
                id: transmitterTXT
                color: "#DB3D40"
                font.pointSize: (parent.width*0.13).toFixed(0)
                font.family: fontFamily
                font.bold: false
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.width*0.15
                    verticalCenterOffset: parent.height*0.1
                }

                text: "---"

            }


        }
    }
    Item {
        id: alertsWidget
        width: 0.28*parent.width
        height: 0.28*parent.height
        anchors {
            top: parent.top
            topMargin: parent.height*0.05
            right: parent.right
            rightMargin: parent.width*0.05
        }
        Rectangle {
            id: alertsBackground
            anchors.fill:parent
            color: "#2F3243"
            radius: height*0.02
            Rectangle { //tob bar
                id: alertsTopBar
                height: parent.height
                width: parent.width
                radius: parent.height*0.02
                color: "#313646"
                anchors {
                    top:parent.top
                    horizontalCenter: parent.horizontalCenter

                }
                Image { //properties squares
                    height: parent.height*0.15
                    width: parent.width*0.01
                    source: "qrc:/assetsMenu/PROPERTIES SQUARES.png"
                    anchors {
                        top: parent.top
                        topMargin: parent.height*0.12
                        right: parent.right
                        rightMargin: 0.03*parent.width
                    }
                }
                Image { //alert icon
                    height: parent.height*0.18
                    width: parent.width*0.08
                    source: "qrc:/assetsMenu/NotificationIcon.png"
                    anchors {
                        top: parent.top
                        topMargin: parent.height*0.07
                        left: parent.left
                        leftMargin: 0.03*parent.width
                    }
                    Text {
                        font.pointSize: 0.8*parent.height.toFixed(0)
                        font.family: fontFamily
                        text: "Alerts"
                        color: "#999AA3"
                        font.bold: true
                        anchors {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                            horizontalCenterOffset: parent.width*2.2
                        }
                        Image {
                            source: "qrc:/assetsMenu/exampleAlertIcon2.png"
                            height: parent.height*0.6
                            width: parent.height*0.6
                            anchors{
                                left: parent.right
                                leftMargin: parent.height
                                verticalCenter: parent.verticalCenter
                            }
                            Text {
                                text: numberOfError
                                font.pointSize: 0.7*parent.height.toFixed(0);
                                color: "White"
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                    left: parent.right
                                    leftMargin: 0.16*parent.width
                                }
                            }
                            Image {
                                source: "qrc:/assetsMenu/warningIcon.png"
                                height: parent.height
                                width: parent.width
                                anchors{
                                    left: parent.right
                                    verticalCenter: parent.verticalCenter
                                    leftMargin: 0.85*parent.width
                                }
                                Text {
                                    text: numberOfWarning
                                    font.pointSize: 0.7*parent.height.toFixed(0);
                                    color: "White"
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        left: parent.right
                                        leftMargin: 0.1*parent.width
                                    }
                                }
                            }
                            Image {
                                source: "qrc:/assetsMenu/exampleAlertIcon.png"
                                height: parent.height
                                width: parent.width
                                anchors{
                                    left: parent.right
                                    verticalCenter: parent.verticalCenter
                                    leftMargin: 2.8*parent.width
                                }
                                Text {
                                    text: numberOfInformation
                                    font.pointSize: 0.7*parent.height.toFixed(0);
                                    color: "White"
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        left: parent.right
                                        leftMargin: 0.2*parent.width
                                    }
                                }
                            }
                        }

                    }

                }
                Rectangle { //bottom alert
                    radius: parent.radius
                    color: "#424D5C"
                    height: parent.height*0.6
                    width: parent.width
                    anchors{
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter

                    }
                    Image {
                        height: parent.height*0.25
                        width: parent.height*0.25
                        source: "qrc:/assetsMenu/exampleAlertIcon.png"
                        anchors {
                            left: parent.left
                            leftMargin: 0.03*parent.width
                            bottom: parent.bottom
                            bottomMargin: parent.height*0.1
                        }

                            Text {
                                id: informationTXT
                                font.family: fontFamily
                                font.pointSize: (parent.height*0.5).toFixed(0)
                                text: "Test text" //add text
                                color: "#2281D1"
                                anchors {
                                    verticalCenter: parent.verticalCenter
                                    left: parent.right
                                    leftMargin: parent.width
                                }

                        }
                    }
                }
                Rectangle{ //spacer
                    id: alertSpacer
                    width: parent.width
                    height: parent.height*0.005
                    color: "#707070"
                    anchors {
                        verticalCenter: parent.verticalCenter
                        verticalCenterOffset: parent.height*0.2
                    }

                }
                Rectangle { //middle bar
                color: "#424D5C"
                height: parent.height*0.35
                width: parent.width
                anchors{
                    bottom: alertSpacer.top
                    horizontalCenter: parent.horizontalCenter

                }
                Image {
                    id: ignoreButton
                    height: parent.height*0.45
                    width: parent.height*0.45
                    anchors{
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: parent.width*0.03
                    }
                    source: "qrc:/assetsMenu/okIcon.png"
                    visible: false
                    MouseArea {
                        anchors.fill: parent
                        onClicked:{
                            if(requestError!==0){
                               requestError = 0;
                                ignoreButton.visible = false;
                                stopConnectionButton.visible = false;
                                error.ignoreRequestErrors();
                            }

                            else if(jsonError!==0){
                                jsonError = 0;
                                ignoreButton.visible = false;
                                stopConnectionButton.visible = false;
                            }
                            else if(sslerror !== 0){
                                sslerror = 0;
                                ignoreButton.visible = false;
                                stopConnectionButton.visible = false;
                                error.ignoreRequestErrors();
                            }

                            else {
                                errorIcon.source="qrc:/assetsMenu/okIcon.png"
                                errorTXT.text = "Everything works correctly"
                                errorTXT.color = "#38865B"
                            }
                            ShowErrors.showErrors();
                        }
                    }
                }
                Image {
                    id: stopConnectionButton
                    height: parent.height*0.45
                    width: parent.height*0.45
                    anchors{
                        verticalCenter: parent.verticalCenter
                        right: ignoreButton.left
                        rightMargin: parent.width*0.015
                    }
                    source: "qrc:/assetsMenu/exampleAlertIcon2.png"
                    visible: false
                    MouseArea {
                        anchors.fill: parent
                        onClicked:{
                            if(requestError!==0){
                               requestError = 0;
                                ignoreButton.visible = false;
                                stopConnectionButton.visible = false;
                                connectionChanged(false);
                            }

                            else if(jsonError!==0){
                                jsonError = 0;
                                ignoreButton.visible = false;
                                stopConnectionButton.visible = false;
                            }
                            else if(sslerror !== 0){
                                sslerror = 0;
                                ignoreButton.visible = false;
                                stopConnectionButton.visible = false;
                                connectionChanged(false);
                            }

                            else {
                                errorIcon.source="qrc:/assetsMenu/okIcon.png"
                                errorTXT.text = "Everything works correctly"
                                errorTXT.color = "#38865B"
                            }
                            ShowErrors.showErrors();
                        }
                    }
                }


                Image {
                    id: errorIcon
                    height: parent.height*0.45
                    width: parent.height*0.45
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: parent.width*0.03
                    }

                    source: "qrc:/assetsMenu/exampleAlertIcon2.png"
                Text {
                    id: errorTXT
                    font.pointSize: (parent.height*0.5).toFixed(0)
                    text: "Test text"  //add text
                    font.family: fontFamily
                    color: "#DB3D40"
                    anchors {
                        verticalCenter: errorIcon.verticalCenter
                        left: errorIcon.right
                        leftMargin: errorIcon.width
                    }


                }
                }


            }
            }

        }
    }
    Item {

        id: graphWidget
        width: 0.4*parent.width
        height: 0.36*parent.height
        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height*0.05
            left: mapWidget.left
        }
        Rectangle {
            id: graphBackground
            anchors.fill: parent
            color: "#292B38"
            Rectangle {
                id: chartBar
                anchors {
                    top: parent.top
                    bottom: chartRect.top
                    left: parent.left
                    right: parent.right
                }
                color: "#313646"
                radius: parent.width * 0.02
                Image {
                    id: speedHeightBar
                    source: "qrc:/assetsMenu/speed_height_bar.png"
                    anchors.fill: parent
                    width: parent.width
                    height: parent.height
                }
//                Rectangle {
//                    id: chartsIcon
//                    anchors {
//                        left: parent.left
//                        top: parent.top
//                        leftMargin: 10
//                        topMargin: 5
//                    }
//                    Image {
//                        id: chartsIconImage
//                        source: "qrc:/assetsMenu/chartsIcon.png"
////                        width: parent.width
////                        height: parent.height
//                    }
//                }
                Image {
                    id: chartsIcon
                    source: "qrc:/assetsMenu/chartsIcon.png"
                    anchors {
                        left: parent.left
                        top: parent.top
                        leftMargin: parent.width * 0.02
                        topMargin: parent.height * 0.1
                    }
                    width: parent.width * 0.08
                    height: parent.height * 0.7
                }
//                Rectangle {
//                    id: chartsTextRect
//                    anchors {
//                        left: chartsIcon.right
//                        top: parent.top
//                        leftMargin: 40
//                        bottom: chartsIcon.bottom
//                    }
//                    Text {
//                        id: chartsText
//                        text: qsTr("Speed/Height chart")
//                        color: "#999AA3"
//                        font {
//                            pointSize: parent.height * 4.5
//                            family: fontFamily
//                        }
//                    }
//                }
                Text {
                    id: chartText
                    text: qsTr("Speed/Height chart")
                    color: "#999AA3"
                    font {
                        pointSize: parent.width * 0.045
                        family: fontFamily
                    }
                    anchors {
                        left: chartsIcon.right
                        leftMargin: parent.width * 0.02
//                        top: parent.top
//                        topMargin: parent.height * 0.04
                        verticalCenter: parent.verticalCenter
//                        bottomMargin: parent.height * 0.01
                    }
                    width: parent.width * 0.6
                    height: parent.height * 0.8
                }
            }
            Rectangle {
                id: chartRect
//                anchors.fill: parent
                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                height: parent.height * 0.8
//                color: parent.color
                color: "#25263B"
                ChartView {
                    anchors.fill: parent
                    margins.bottom: 0
                    margins.top: 0
                    margins.left: 0
                    margins.right: 0
                    antialiasing: true
                    backgroundColor: "#25263B"
                    legend.visible: false
                    // Define x-axis to be used with the series instead of default one
//                    ValueAxis {
//                        min: 20
//                        max: 31
//                        tickCount: 12
//                        labelFormat: "%.0f"
//                        gridVisible: false
//                        color: "#2F3243"
//                    }
                    DateTimeAxis {
                        id: xAxis
                        gridVisible: false
                        color: "#2F3243"
                        format: "hh:mm:ss"
                        tickCount: 5
                    }

                    ValueAxis {
                        id: yAxis1
                        min: 0
                        max: simVelocityMax
                        tickCount: 1
                        gridVisible: true
                        gridLineColor: "#2F3243"
                        color: "#2F3243"
                        titleText: "Velocity [kph]"
                    }
                    ValueAxis {
                        id: yAxis2
                        min: 0
                        max: simHeightMax
                        tickCount: 1
                        gridVisible: true
                        gridLineColor: "#2F3243"
                        color: "#2F3243"
                        titleText: "Altitude [masl]"
                    }

                    AreaSeries {
                        axisX: xAxis
                        axisY: yAxis1
                        color: "#4dfef5"
                        opacity: 0.25
                        //pointLabelsVisible: false
                        borderColor: "#4bddf7"
                        borderWidth: 5.0
                        upperSeries: LineSeries {
                            id: y1
//                            XYPoint { x: 20; y: 4 }
//                            XYPoint { x: 21; y: 5 }
//                            XYPoint { x: 22; y: 6 }
//                            XYPoint { x: 23; y: 8 }
//                            XYPoint { x: 24; y: 7 }
//                            XYPoint { x: 25; y: 6 }
//                            XYPoint { x: 26; y: 4 }
//                            XYPoint { x: 27; y: 6 }
//                            XYPoint { x: 28; y: 4 }
//                            XYPoint { x: 29; y: 5 }
//                            XYPoint { x: 30; y: 6 }
//                            XYPoint { x: 31; y: 7 }
                        }
                    }
                    AreaSeries {
                        axisX: xAxis
                        axisYRight: yAxis2
                        color: "#9b5ed4"
                        opacity: 0.3
                        //pointLabelsVisible: false
                        borderColor: "#bd78f2"
                        borderWidth: 5.0
                        upperSeries: LineSeries {
                            id: y2
//                            XYPoint { x: 20; y: 2 }
//                            XYPoint { x: 21; y: 3 }
//                            XYPoint { x: 22; y: 2 }
//                            XYPoint { x: 23; y: 2 }
//                            XYPoint { x: 24; y: 3 }
//                            XYPoint { x: 25; y: 3 }
//                            XYPoint { x: 26; y: 2 }
//                            XYPoint { x: 27; y: 3 }
//                            XYPoint { x: 28; y: 2 }
//                            XYPoint { x: 29; y: 2 }
//                            XYPoint { x: 30; y: 3 }
//                            XYPoint { x: 31; y: 1 }
                        }
                    }
                    Timer {
                        interval: 100
                        running: true
                        triggeredOnStart: true
                        repeat: true
                        onTriggered: {
                            xAxis.min = new Date(Date.now() - 10000);
                            xAxis.max = new Date(Date.now() + 1000);
                        }
                    }
                    Timer {
                        interval: 100
                        running: true
                        triggeredOnStart: true
                        repeat: true
                        onTriggered: {
                            y1.append(new Date(Date.now()), simVelocity);
                            y2.append(new Date(Date.now()), simHeight);


                        }
                    }
                    Timer {
                        id: valueTimer
                        interval: 100
                        running: true
                        triggeredOnStart: true
                        repeat: true
                        onTriggered: {
                            timeElapsed = timeElapsed + 100
                        }

                    }
                }
            }
        }
    }

    Item {
        id: portWidget
        width: 0.13*parent.width
        height: 0.30*parent.height
        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height*0.05
            right: alertsWidget.right
        }
        Rectangle {
            id: portBackground
            anchors.fill:parent
            color: "#2F3243"
            Image {
                anchors.fill:parent
                source: "qrc:/assetsMenu/REQUEST STATUS.png"
            }
            Rectangle {
                color: "#2F3243"
                width: parent.width*0.5
                height: parent.height*0.3
                anchors{
                    top: parent.top
                    left:parent.left
                    leftMargin: parent.width*0.12
                    topMargin: parent.height*0.07
                }
            }
            Text{
                text: "Request\nAddress"
                wrapMode: text.WordWrap
                width: parent.width*0.5
                font.family: standardFont.name
                font.pixelSize: 0.12*parent.height.toFixed(0)
                color: "#FFFFFF"
                opacity: 0.55
                anchors{
                    top: parent.top
                    left: parent.left
                    topMargin: parent.height*0.04
                    leftMargin: parent.width*0.15
                }
            }

            MouseArea{
                anchors{
                    top: parent.top
                    topMargin: parent.height*0.1
                    right: parent.right
                    rightMargin: parent.width*0.1
                }
                enabled: true
                hoverEnabled: true
                width: parent.width*0.1
                height: parent.height*0.2
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    request.visible = true;

                }

            }

            Text {
                id: portTXT
                font.family: fontFamily
                color: "#DB3D40" //red
                font.pointSize: (parent.height*0.05).toFixed(0)
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 0.01*parent.height
                    horizontalCenter: parent.horizontalCenter
                }
                text:"Not Connected"


            }
            Text {
                id: port
                font.family: fontFamily
                color: "#DB3D40" //red
                font.pointSize: (parent.height*0.1).toFixed(0)
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                    horizontalCenterOffset: parent.width*0.1
                    verticalCenterOffset: parent.height*0.1
                }

                text: "---"

            }
            Text {
                id: realPort
                font.family: fontFamily
                color: "#DB3D40" //red
                font.pointSize: (parent.height*0.1).toFixed(0)
                anchors{
                    verticalCenter: port.verticalCenter
                    horizontalCenter: port.horizontalCenter
                    verticalCenterOffset: parent.height*0.15
                }
                text: "---"
            }

        }
    }
    Item {
        id: parametersWidget
        width: 0.18*parent.width
        height: 0.36*parent.height
        anchors {
            bottom: parent.bottom
            bottomMargin: parent.height*0.05
            left: parent.left
            leftMargin: parent.width*0.47
        }
        Rectangle
        {
            id: parametersBackground
            anchors.fill:parent
            color: "#292B38"
              Rectangle { //Ground speed
                  id: groundSpeedRect
                  width: parent.width*0.75
                  height: parent.height*0.75
                  anchors.top: parent.top
                  anchors.left: parent.left
                  anchors.leftMargin: -0.18*width
                  color: "transparent"
                  anchors.topMargin: -parent.height*0.12
                  ChartView{
                      anchors.centerIn: parent
                      anchors.fill: parent
                      antialiasing: true
                      backgroundColor: "transparent"
                      theme: ChartView.ChartThemeBlueIcy
                      margins {
                          left: 0
                          right: 0
                          top: 0
                          bottom: 0
                      }
//                      transform: Rotation{angle: 45}
                      legend.visible: false
                      PieSeries {
                          id: speedSeries
                          PieSlice{
                              id: speedSlice
                              value: simVelocity
                              color: "#292BFF"
                              borderWidth: 0
                              borderColor: "transparent"
                          }
                          PieSlice{
                              value: simVelocityMax - simVelocity
                              color: "#292BAA"
                              borderWidth: 0
                              borderColor: "transparent"
                          }
                          holeSize: 0.5
                      }
//                      Timer{
//                          id: pieTimer
//                          interval: 500
//                          running: true
//                          repeat: true
//                          triggeredOnStart: true
//                          onTriggered: {
////                              speedSlice.value= simVelocity
////                              heightSlice.value= simHeight
////                              connectionSlice.value= 30 + Math.random()*(5-2)+2
//                              //distanceSlice.value = 30 + Math.random()*(5-2)+2
//                          }
//                      }
                  }
//                  Image {
//                      width: parent.width*0.98
//                      height: parent.height*0.98
//                      anchors.centerIn: parent
//                      source: "qrc:/assetsMenu/SpeedParametr.png"

//                  }
                  Text {
                      color: "#F5F0F0"
                      font.family: fontFamily
                      anchors {
                       verticalCenter: parent.verticalCenter
                       verticalCenterOffset: -parent.height*0.02
                       horizontalCenter: parent.horizontalCenter
                       horizontalCenterOffset: parent.width*0.01
                      }
                      font.pointSize: (parent.height*0.11).toFixed(0)
//                      text: groundSpeed.toFixed(0).toString() + "km/h"
                        text: simVelocity.toFixed(0).toString() + "km/h"
                  }
              }
              Rectangle { //Heigth
                  id: heightRect
                  width: parent.width*0.75
                  height: parent.height*0.75
//                  anchors.top: parent.top
                  anchors.right: parent.right
                  anchors.rightMargin: -0.2*width
//                  anchors.topMargin: -0.18*height
                  anchors.bottom: groundSpeedRect.bottom
                  color: "transparent"
//                  Image {
//                      width: parent.width
//                      height: parent.height
//                      anchors.centerIn: parent
//                      source: "qrc:/assetsMenu/Height.png"

//                  }
                  ChartView{
                      anchors.centerIn: parent
                      anchors.fill: parent
                      antialiasing: true
                      backgroundColor: "transparent"
                      theme: ChartView.ChartThemeDark
                      margins {
                          left: 0
                          right: 0
                          top: 0
                          bottom: 0
                      }
                      legend.visible: false
                      PieSeries {
                          id: heightSeries
                          PieSlice{
                              id: heightSlice
                              value: simHeight
//                              color: "#292BFF"
                              borderWidth: 0
                              borderColor: "transparent"
                          }
                          PieSlice{
                              value: simHeightMax - simHeight
//                              color: "#292BAA"
                              borderWidth: 0
                              borderColor: "transparent"
                          }
                          holeSize: 0.5
                      }
                  }
                  Text {
                      color: "#F5F0F0"
                      font.family: fontFamily
                      anchors {
                       verticalCenter: parent.verticalCenter
                       verticalCenterOffset: -parent.height*0.02
                       horizontalCenter: parent.horizontalCenter
                       horizontalCenterOffset: parent.width*0.01
                      }
                      font.pointSize: (parent.height*0.12).toFixed(0)
//                      text: altitude.toFixed(0).toString() + "m"
                        text: simHeight.toFixed(0).toString() + "m"
                  }
              }
              Rectangle { //connectionPower
                  id: connectionPowerRect
                  width: parent.width*0.75
                  height: parent.height*0.75
                  anchors.bottom: parent.bottom
                  anchors.left: groundSpeedRect.left
//                  anchors.leftMargin: -0.1*width
                  color: "transparent"
                  anchors.bottomMargin: -0.18*width
//                  Image {
//                      width: parent.width*0.98
//                      height: parent.height*0.98
//                      anchors.centerIn: parent
//                      source: "qrc:/assetsMenu/connectionPower.png"

//                  }
                  ChartView{
                      anchors.centerIn: parent
                      anchors.fill: parent
                      antialiasing: true
                      backgroundColor: "transparent"
                      theme: ChartView.ChartThemeBlueIcy
                      margins {
                          left: 0
                          right: 0
                          top: 0
                          bottom: 0
                      }
                      legend.visible: false
                      PieSeries {
                          id: connectionSeries
                          PieSlice{
                              id: connectionSlice
                              value: batteryPercentage
//                              color: "#292BFF"
                              borderWidth: 0
                              borderColor: "transparent"
                          }
                          PieSlice{
                              value: 100 - batteryPercentage
//                              color: "#292BAA"
                              borderWidth: 0
                              borderColor: "transparent"
                          }
                          holeSize: 0.5
                      }
                  }
                  Text {
                      color: "#F5F0F0"
                      font.family: fontFamily
                      anchors {
                       verticalCenter: parent.verticalCenter
                       verticalCenterOffset: -parent.height*0.01
                       horizontalCenter: parent.horizontalCenter
                       horizontalCenterOffset: -parent.width*0.02
                      }
                      font.pointSize: (parent.height*0.11).toFixed(0)
                      text: batteryPercentage.toFixed(0).toString() + "%"
                  }
              }
              Rectangle { //Distance
                  width: parent.width*0.75
                  height: parent.height*0.75
                  anchors.bottom: connectionPowerRect.bottom
//                  anchors.right: parent.right
//                  anchors.rightMargin: -0.1*width
                  anchors.left: heightRect.left
                  color: "transparent"
//                  Image {
//                      width: parent.width
//                      height: parent.height
//                      anchors.centerIn: parent
//                      source: "qrc:/assetsMenu/Distance.png"

//                  }
                  ChartView{
                      anchors.centerIn: parent
                      anchors.fill: parent
                      antialiasing: true
                      backgroundColor: "transparent"
//                      theme: ChartView.ChartThemeBlueCerulean
                      margins {
                          left: 0
                          right: 0
                          top: 0
                          bottom: 0
                      }
                      legend.visible: false
                      PieSeries {
                          id: distanceSeries
                          PieSlice{
                              id: distanceSlice
                              value: constDist - generate.distance
                              color: "#D2A40B"
//                              color: "#20AE2E"
                              borderWidth: 0
                              borderColor: "transparent"
                          }
                          PieSlice{
                              value: generate.distance
//                              color: "#14641C"
                              color: "#EECA56"
                              borderWidth: 0
                              borderColor: "transparent"
                          }
                          holeSize: 0.5
                      }
                  }
                  Text {
                      color: "#F5F0F0"
                      font.family: fontFamily
                      anchors {
                       verticalCenter: parent.verticalCenter
//                       verticalCenterOffset: -parent.height*0.01
                       horizontalCenter: parent.horizontalCenter
//                       horizontalCenterOffset: parent.width*0.01
                      }
                      font.pointSize: (parent.height*0.12).toFixed(0)
                      text: distanceToNextPoint.toFixed(1).toString() + "km"
                  }
              }

        }
    }
    Item {
        id: mapWidget
        height: parent.height*0.5
        width: parent.width*0.6
        state: "started"
        anchors {
            top: parent.top
            topMargin: parent.height*0.05
            left: parent.left
            leftMargin: parent.width*0.05

        }
        Behavior on width { SmoothedAnimation {id:anim1
                velocity: Number.POSITIVE_INFINITY
            } }
        Behavior on height { SmoothedAnimation {id:anim2
                velocity: Number.POSITIVE_INFINITY
            } }
        Behavior on anchors.topMargin  { SmoothedAnimation {id:anim3
                velocity: Number.POSITIVE_INFINITY } }
        Behavior on anchors.leftMargin { SmoothedAnimation {id:anim4
                velocity: Number.POSITIVE_INFINITY } }
        states: [
        State {
                name: "windowed"

            },
        State {
                name: "fullPage"
            }

        ]


    onStateChanged: {
        if(mapWidget.state === "fullPage") {
            anim1.velocity = 1200
            anim2.velocity = 750
            anim3.velocity = 70
            anim4.velocity = 120
            mapWidget.anchors.topMargin = 0
            mapWidget.anchors.leftMargin = 0
            mapWidget.width = parent.width
            mapWidget.height = parent.height
        }
        else if(mapWidget.state === "windowed") {
            mapWidget.anchors.topMargin = 0.05*parent.height
            mapWidget.anchors.leftMargin = 0.05*parent.width
            mapWidget.width = parent.width*0.6
            mapWidget.height = parent.height*0.5

        }
    }

        Rectangle {
            anchors.fill: parent
            color : "#2F3243"
            //radius: parent.height*0.02

// START MAIN ANIMATION CODE |||| -------------------------------------------------------------------------------------------------------------- ||||

            Map { //map
               id: map
               anchors.fill: parent

                anchors {
                    bottom: parent.bottom
                    left: parent.left
                }
                onCenterChanged: {
                    if(mapFollow==true){
                        center = planePosition
                    }
                }
                plugin: Plugin{
                    name: "mapbox"
                    PluginParameter{
                        name: "mapbox.access_token"
                        value: "pk.eyJ1IjoiYndpZWN6b3JlayIsImEiOiJjang0eWt5a3gwZGZyNDhydmNvNG5jN3NiIn0.itD8fF1I55d4NBM5CmMnwA"
                    }
                    PluginParameter{
                        name: "mapbox.mapping.map_id"
                        value: "mapbox.dark"
                    }
                }

                DropArea {
                    anchors.fill: parent
                    onDropped: {
                        var coord = map.toCoordinate(Qt.point((drop.x-10), (drop.y+9)));
                        MarkerGenerator.createMarkerObjects(coord);
                        anim.running = true;

                    }
                }
                Marker{

                    id: plane
                    coordinate: generate.lastPoint //  to change for class object

                    SequentialAnimation{
                        id: planeAnimation
                        property real direction: -9

                        //- First Animation - rotate the plane to correct direction

                        NumberAnimation{
                            id: rotateAnimation
                            target: plane
                            property: "rotate" // type of rotation 0 - 360 degrees
                            duration: 1500
                            easing.type: Easing.InOutQuad
                            to: planeAnimation.direction  // set direction before running animation
                        }

                        //- Second Animation - move plane
                        CoordinateAnimation{
                            id: planeMoveAnimation
                            duration: 5*60*1000           // five minutes in one way
                            target: generate
                            property: "lastPoint"
                            easing.type: Easing.InOutQuad
                        }

                    }

                    MouseArea{
                        anchors.fill: parent
                            onClicked: {
                                if (planeAnimation.running) {
                                    console.log("Plane is flying.");
                                    return;
                                }

                                if (generate.lastPoint === generate.endPoint) {
                                    planeMoveAnimation.from = generate.endPoint;
                                    planeMoveAnimation.to = generate.startPoint;
                                } else if (generate.lastPoint === generate.startPoint) {
                                    planeMoveAnimation.from = generate.startPoint;
                                    planeMoveAnimation.to = generate.endPoint;
                                }

                                if(counter != 1){
                                    if(startButtonState === true){
                                        planeAnimation.direction = generate.lastPoint.azimuthTo(planeMoveAnimation.to);
                                        planeAnimation.start();
                                    }
                                }else{
                                    if(startButtonState === true){
                                        planeAnimation.start();
                                        counter = counter+1;
                                    }
                                }
                            }
                    } // MouseArea end

                } // marker end

            } // map end

// END MAIN ANIMATION CODE |||| -------------------------------------------------------------------------------------------------------------- ||||

            Rectangle { //bottomBar
                id: bottomBar
                color: parent.color
                width: parent.width
                height: parent.parent.parent.height*0.1*0.5
                opacity: 0.85
                anchors {
                    bottom: parent.bottom
                    left: parent.left

                }
                Rectangle {
                width: parent.height*0.95
                height: parent.height*0.95
                color: "transparent"
                opacity: 1
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    id : fullPageIcon
                    width: parent.width*0.6
                    height: parent.height*0.6
                    anchors.centerIn: parent
                    source: "qrc:/assetsMenu/mapFullScreen.png"

                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                         if(mapWidget.state == "windowed"||mapWidget.state =="started") {mapWidget.state = "fullPage"}
                         else {mapWidget.state = "windowed"}
                    }
                }
                }
                Rectangle {
                width: parent.height*0.95
                height: parent.height*0.95
                color: "transparent"
                opacity: 1
                anchors.left: parent.left
                anchors.leftMargin: parent.height*0.5
                anchors.verticalCenter: parent.verticalCenter
                SliderSwitch {
                    id: followSwitch
                    anchors.fill: parent
                    size: parent.width*0.8
                    onstatecolor: "#009688"
                    offstatecolor: "#424D5C"
                    state: "on"
                }
                Text{
                    text: "Follow"
                    font.family: fontFamily
                    font.pointSize: (parent.height*0.3).toFixed(0)
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: parent.width*0.2
                    color: "#707070"



            }
                }

            }



            Rectangle { //topBar
                color: parent.color
                width: parent.width
                height: parent.parent.parent.height*0.2*0.5
                opacity: 0.85
                anchors {
                    top: parent.top

                }
                Rectangle { //redspacer
                    id: redspacer
                    color: "#F21E41"
                    height: parent.height*0.6
                    width: parent.width*0.002
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: root.width*0.015
                    }
                    Text {
                        id: numberOfPointsTXT
                        text: numberOfPoint.toString()
                        font.family: fontFamily
                        color: "#F5F0F0"
                        font.pointSize: (root.width*0.016).toFixed(0)
                        anchors {
                            left: parent.right
                            leftMargin: parent.width*2
                            verticalCenter: parent.verticalCenter
                            verticalCenterOffset: -parent.height*0.2
                        }

                        }
                    Text {
                        id: numberOfPointsTXTstatic
                        text: "Number of Points"
                        font.family: fontFamily
                        font.pointSize: (numberOfPointsTXT.font.pointSize*0.4).toFixed(0)
                        color: "#707070"
                        anchors {
                            left: parent.left
                            leftMargin: parent.width*3
                            bottom: parent.bottom
                        }
                    }
                }
                Rectangle { //2-nd spacer
                    color: "#1E90F2"
                    height: parent.height*0.6
                    width: parent.width*0.002
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: numberOfPointsTXTstatic.width*1.8
                    }
                    Text {
                        id: distanceToNextPointTXT
                        text: distanceToNextPoint.toFixed(2).toString()+" km"
                        font.family: fontFamily
                        color: "#F5F0F0"
                        font.pointSize: (root.width*0.016).toFixed(0)
                        anchors {
                            left: parent.right
                            leftMargin: parent.width*2
                            verticalCenter: parent.verticalCenter
                            verticalCenterOffset: -parent.height*0.2
                        }

                        }
                    Text {
                        text: "Distance To Next Point"
                        font.family: fontFamily
                        font.pointSize: (numberOfPointsTXT.font.pointSize*0.4).toFixed(0)
                        color: "#707070"
                        anchors {
                            left: parent.left
                            leftMargin: parent.width*3
                            bottom: parent.bottom
                }
            }

        }
                Rectangle { //3-nd spacer
                    color: "#1E90F2"
                    height: parent.height*0.6
                    width: parent.width*0.002
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: numberOfPointsTXTstatic.width*3.5
                    }
                    Text {
                        id: longitudeTXT
                        font.family: fontFamily
                        text: longitude.toFixed(5).toString()
                        color: "#F5F0F0"
                        font.pointSize: (root.width*0.016).toFixed(0)
                        anchors {
                            left: parent.right
                            leftMargin: parent.width*2
                            verticalCenter: parent.verticalCenter
                            verticalCenterOffset: -parent.height*0.2
                        }

                        }
                    Text {
                        text: "Longitude"
                        font.family: fontFamily
                        font.pointSize: (longitudeTXT.font.pointSize*0.4).toFixed(0)
                        color: "#707070"
                        anchors {
                            left: parent.left
                            leftMargin: parent.width*3
                            bottom: parent.bottom
                }
            }

        }
                Rectangle { //4-nd spacer
                    color: "#E4D013"
                    height: parent.height*0.6
                    width: parent.width*0.002
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: numberOfPointsTXTstatic.width*5.5
                    }
                    Text {
                        id: latitudeTXT
                        font.family: fontFamily
                        text: latitude.toFixed(5).toString()
                        color: "#F5F0F0"
                        font.pointSize: (root.width*0.016).toFixed(0)
                        anchors {
                            left: parent.right
                            leftMargin: parent.width*2
                            verticalCenter: parent.verticalCenter
                            verticalCenterOffset: -parent.height*0.2
                        }

                        }
                    Text {
                        text: "Latitude"
                        font.family: fontFamily
                        font.pointSize: (longitudeTXT.font.pointSize*0.4).toFixed(0)
                        color: "#707070"
                        anchors {
                            left: parent.left
                            leftMargin: parent.width*3
                            bottom: parent.bottom
                }
            }

        }

    }
            Image {
                id: dragAndDropIcon
                source: "qrc:/assetsMenu/markerIcon.png"
                width: bottomBar.height*0.55
                height: bottomBar.height*0.8
                x: mapWidget.width*0.95
                y: root.height*0.03
                Drag.active: markerDragAndDropMouseArea.drag.active
                Drag.hotSpot.x: 20
                Drag.hotSpot.y: 20
                SequentialAnimation {
                    id: anim
                    running: false
                    NumberAnimation { target: dragAndDropIcon; property: "opacity"; to: 0; duration: 500 }
                    PropertyAction { target: dragAndDropIcon; property: "x"; value: mapWidget.width*0.95 }
                    PropertyAction { target: dragAndDropIcon; property: "y"; value: root.height*0.03 }
                    NumberAnimation { target: dragAndDropIcon; property: "opacity"; to: 1; duration: 500 }
                }
                MouseArea {
                    id: markerDragAndDropMouseArea
                    anchors.fill: parent
                    drag.target: dragAndDropIcon
                    propagateComposedEvents: true
                    onReleased: {
                        dragAndDropIcon.Drag.drop()
                    }
                }

            }
    }

    }

}
