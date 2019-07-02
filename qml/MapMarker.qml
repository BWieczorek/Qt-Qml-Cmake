import QtQuick 2.0
import QtLocation 5.9
import "MarkerGenerator.js" as MarkerGenerator


MapQuickItem {
id: marker
anchorPoint.x: image.width/2
anchorPoint.y: image.height
visible: true
width: 25
height: 32
property bool isPositionMarker: true
signal markerDeleted()

sourceItem: Image {
    id:image
    height: 32
    width: 25
    source: "qrc:/assetsMenu/markerIcon.png"
}
MouseArea {
    hoverEnabled: true
    acceptedButtons: Qt.RightButton
    anchors.fill:parent
    onClicked: {
        MarkerGenerator.removeMarker(marker);

    }


}
}
