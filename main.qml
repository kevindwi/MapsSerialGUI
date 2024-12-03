import QtQuick 2.15

import QtQuick.Controls
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs
import QtQuick.Layouts 1.3

import QtLocation
import QtPositioning

import com.mapview.MapSerial 1.0
import com.mapview.MarkerModel 1.0

Window {
    property bool serialConnected: false
    property bool isAddingMarker: false

    property var nowCoordinate: [0, 0]

    property var coordinate: undefined

    property var myMarker: null

    minimumWidth: 1200
    minimumHeight: 600

    visible: true
    title: "Maps"

    MapSerial {
        id: mapSerial
    }

    MarkerModel {
        id: markerModel
    }

    Rectangle {
        id: rectangle
        width: 1000
        height: 600

        anchors.fill: parent

        color: "#EAEAEA"

        Plugin {
            id: mapPlugin
            name: "osm"

            PluginParameter {
                name: "osm.mapping.providersrepository.disabled"
                value: "true"
            }

            PluginParameter {
                name: "osm.mapping.custom.host"
                value: "https://tile.thunderforest.com/cycle/%z/%x/%y.png?apikey=bb9230b1738b49188a09468e199e25e1"
            }
        }

        Column {
            id: column
            x: rectangle.width - column.width
            y: 0
            width: 350

            height: parent.height

            Column {
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: label
                    // leftPadding: 20
                    topPadding: 20
                    width: 150
                    text: qsTr("Configuration")
                }

                Row {
                    id: row
                    width: 300
                    topPadding: 5
                    spacing: 10

                    ComboBox {
                        id: portList
                        width: 145
                        height: 30
                        background: Rectangle {
                            radius: 5
                        }

                        model: mapSerial.getPortList()
                    }

                    ComboBox {
                        id: baudRate
                        width: 145
                        height: 30
                        background: Rectangle {
                            radius: 5
                        }

                        model: ["9600", "115200"]
                    }
                }

                Button {
                    id: buttonConnect
                    anchors.topMargin: 40
                    width: row.width
                    height: 45

                    text: serialConnected ? "Close" : "Connect"

                    contentItem: Text {
                        text: parent.text
                        color: "#fff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        id: btnRect

                        property color connectColor : "#4e5bf2"
                        property color closeColor : "#F44336"

                        color: buttonConnect.hovered ? Qt.darker(serialConnected ? closeColor : connectColor) : serialConnected ? closeColor : connectColor
                        radius: 5
                    }

                    onClicked: () => {
                        if(serialConnected) {
                            mapSerial.closeConnection()
                            serialConnected = false;
                        } else if(mapSerial.startConnection(portList.currentText, parseInt(baudRate.currentText))) {
                            serialConnected = true;
                        }
                    }
                }

                Label {
                    id: label2
                    // leftPadding: 20
                    topPadding: 10
                    bottomPadding: 5
                    width: 150
                    text: qsTr("Coordinate")
                }

                ListView {
                    id: listView
                    width: row.width
                    height: 150
                    model: markerModel
                    spacing: 5
                    delegate: MouseArea {
                        // width: column1.width
                        // height: column1.height

                        width: row.width
                        height: 30

                        Column {
                            id: column1
                            // spacing: 10
                            // width: row.width
                            // height: 30
                            anchors.fill: parent

                            Row {
                                anchors.fill: parent
                                Text {
                                    width: 20
                                    text: index + 1
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Text {
                                    width: 90
                                    text: model.position.latitude.toString().substring(0, 10)
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Text {
                                    width: 90
                                    text: model.position.longitude.toString().substring(0, 10)
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                        }

                        onClicked: {
                            listView.currentIndex = index;
                            listView.forceActiveFocus();

                            // markerTemp.
                            coordinate = markerModel.getCoordinate(listView.currentIndex)
                        }
                    }

                    highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
                    focus: true

                    onCountChanged: {
                        listView.currentIndex = -1
                    }

                    ScrollBar.vertical:  ScrollBar {
                        // x: parent.width
                        height: row.height
                        active: true
                    }
                }

                Label {
                    id: label3
                    // leftPadding: 20
                    topPadding: 50
                    bottomPadding: 5
                    width: 150
                    text: qsTr("Marker")
                }

                Row {
                    id: row2
                    width: 300
                    topPadding: 5
                    spacing: 10

                    TextField {
                        id: latitudeTextField
                        width: 145
                        height: 25
                        bottomPadding: 0
                        topPadding: 0
                        leftPadding: 6
                        placeholderText: focus || text ? "" : "latitude"
                        text: coordinate?.latitude.toString().substring(0, 10) || ""
                        readOnly: true
                        selectionColor: "#4e5bf2"

                        cursorDelegate: Rectangle {
                            visible: latitudeTextField.cursorVisible
                            color: "#4e5bf2"
                            width: latitudeTextField.cursorRectangle.width
                        }
                        background: Rectangle {
                            color: latitudeTextField.enabled ? "transparent" : "#353637"
                            border.color: latitudeTextField.focus ? "#4e5bf2" : "#74777d"
                            radius: 5
                        }
                    }

                    TextField {
                        id: longitudeTextField
                        width: 145
                        height: 25
                        bottomPadding: 0
                        topPadding: 0
                        leftPadding: 6
                        placeholderText: focus || text ? "" : "longitude"
                        text: coordinate?.longitude.toString().substring(0, 10) || ""
                        readOnly: true
                        selectionColor: "#4e5bf2"

                        cursorDelegate: Rectangle {
                            visible: longitudeTextField.cursorVisible
                            color: "#4e5bf2"
                            width: longitudeTextField.cursorRectangle.width
                        }
                        background: Rectangle {
                            color: longitudeTextField.enabled ? "transparent" : "#353637"
                            border.color: longitudeTextField.focus ? "#4e5bf2" : "#74777d"
                            radius: 5
                        }
                    }
                }

                Button {
                    id: buttonSend
                    anchors.topMargin: 40
                    width: row.width
                    height: 45

                    text: "Send"

                    contentItem: Text {
                        text: parent.text
                        color: "#fff"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        id: btnRect2

                        property color buttonColor : "#4e5bf2"

                        color: !serialConnected ? Qt.darker(buttonColor) : (buttonSend.hovered ? Qt.darker(buttonColor) : buttonColor)
                        radius: 5
                    }

                    onClicked: () => {
                        if(serialConnected) {
                            markerModel.addMarker(coordinate)
                            var msg = coordinate.latitude.toString().substring(0, 11) + "," + coordinate.longitude.toString().substring(0, 11) + ",0,0"
                            mapSerial.sendData(msg)
                        }
                    }
                }

                TextArea {
                    id: serialMonitor
                    width: row.width
                    // height: 20
                    text: mapSerial.message
                }
            }
        }

        Map {
            id: map
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 350
            plugin: mapPlugin
            center: QtPositioning.coordinate(-7.313455, 112.727636) // Unesa
            zoomLevel: 18
            z: 0

            // property geoCoordinate startCentroid
            activeMapType: map.supportedMapTypes[map.supportedMapTypes.length - 1]

            PinchHandler {
                id: pinch
                target: null
                onActiveChanged: if (active) {
                    map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
                }
                onScaleChanged: (delta) => {
                    map.zoomLevel += Math.log2(delta)
                    map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                }
                onRotationChanged: (delta) => {
                    map.bearing -= delta
                    map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                }
                grabPermissions: PointerHandler.TakeOverForbidden
            }
            WheelHandler {
                id: wheel
                // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432:
                // Magic Mouse pretends to be a trackpad but doesn't work with PinchHandler
                // and we don't yet distinguish mice and trackpads on Wayland either
                acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                                 ? PointerDevice.Mouse | PointerDevice.TouchPad
                                 : PointerDevice.Mouse
                rotationScale: 1/120
                property: "zoomLevel"
            }
            DragHandler {
                id: drag
                target: null
                onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
            }
            Shortcut {
                enabled: map.zoomLevel < map.maximumZoomLevel
                sequence: StandardKey.ZoomIn
                onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
            }
            Shortcut {
                enabled: map.zoomLevel > map.minimumZoomLevel
                sequence: StandardKey.ZoomOut
                onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
            }

            MapItemView{
                model: markerModel
                delegate: mapcomponent
            }

            Component {
                id: mapcomponent
                MapQuickItem {
                    id: marker
                    anchorPoint.x: markerComponent.width/4
                    anchorPoint.y: markerComponent.height
                    coordinate: position

                    sourceItem: Column {
                        id: markerComponent
                        Text {
                            width: 20
                            text: index + 1
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Image {
                            id: image
                            source: "images/mm_20_red.png"
                        }
                    }
                }
            }

            MapQuickItem {
                id: markerTemp
                anchorPoint.x: markerComponent.width/4
                anchorPoint.y: markerComponent.height
                coordinate: myMarker

                sourceItem: Column {
                    id: markerComponent
                    Text {
                        // property int index: 0
                        width: 20
                        text: ""
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Image {
                        id: image
                        source: "images/mm_20_red.png"
                    }
                }
            }

            MapQuickItem {
                id: carMarker
                anchorPoint.x: markerComponent.width/2
                anchorPoint.y: markerComponent.height/1.6
                // coordinate: mapSerial.getCurrentPosition()


                sourceItem: Column {
                    id: carMarkerComponent
                    Text {
                        // property int index: 0
                        width: 20
                        text: ""
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    Image {
                        id: img
                        width: 50
                        height: 50
                        source: "images/blue_dot_marker.png"
                    }
                }
            }

            MouseArea {
                anchors.fill: parent

                onPressed: (mouse) => {
                    if(isAddingMarker) {
                        coordinate = map.toCoordinate(Qt.point(mouse.x,mouse.y))

                        // nowCoordinate[0] = coordinate.latitude.toString().substring(0, 10)
                        // nowCoordinate[1] = coordinate.longitude.toString().substring(0, 10)

                        // latitudeTextField.text = nowCoordinate[0]
                        // longitudeTextField.text = nowCoordinate[1]

                        // markerModel.addMarker(coordinate)
                        markerTemp.coordinate = coordinate
                        // console.log(coordinate)
                    } else {
                        markerTemp.coordinate = null
                    }
                }
            }

            RoundButton {
                id: roundButton
                text: isAddingMarker ? "\u00d7" : "+"

                contentItem: Text {
                    text: parent.text
                    color: "#fff"
                    font.pixelSize: 23
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: 20
                anchors.bottomMargin: 20

                Material.background: !serialConnected ? Qt.darker("#4e5bf2") : (roundButton.hovered ? Qt.darker("#4e5bf2") : "#4e5bf2")

                property string toolTipText: "Add point"
                ToolTip.text: toolTipText
                ToolTip.visible: toolTipText ? ma.containsMouse : false

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true

                    onPressed: () => {
                        if(serialConnected) {
                            isAddingMarker = !isAddingMarker

                            if(!isAddingMarker) {
                                markerTemp.coordinate = null
                            }
                        }
                    }
                }
            }

            Connections {
                target: mapSerial
                function onDataReceived(data, currentCoordinates) {
                    carMarker.coordinate = currentCoordinates
                    serialMonitor.text = data
                    // console.log(data)
                }
            }
        }
    }
}
