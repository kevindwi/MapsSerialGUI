import QtQuick

import QtQuick.Controls
import QtQuick.Controls.Universal
import QtQuick.Controls.Material
import QtQuick.Dialogs

import QtLocation
import QtPositioning

import com.mapview.MapCoordinate 1.0
import com.mapview.SerialConnection 1.0

Window {
    minimumWidth: 1000
    minimumHeight: 600

    visible: true
    Universal.theme: Universal.System
    title: "Maps"

    MapCoordinate {
        id: mapCoordinate
    }

    SerialConnection {
        id: serialConnection
    }

    Rectangle {
        id: rectangle
        width: 1000
        height: 600

        anchors.fill: parent

        // color: Constants.backgroundColor

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

        Map {
            id: map
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(-7.313455, 112.727636) // Unesa
            zoomLevel: 20
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

            MapQuickItem {
                id: marker
                anchorPoint.x: imageMarker.width/4
                anchorPoint.y: imageMarker.height

                sourceItem: Image {
                    id: imageMarker
                    source: "images/mm_20_red.png"
                }
            }

            MouseArea {
                id: mapArea
                anchors.fill: parent
                onPressed: mouse => {
                    marker.coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                    mapCoordinate.getCoordinates(marker.coordinate.latitude, marker.coordinate.longitude)
               }
            }

            RoundButton {
                id: roundButton
                x: rectangle.width - 100
                y: rectangle.height - 100
                text: "+"

                Material.background: "#FF7777"

                property string toolTipText: "Add point"
                ToolTip.text: toolTipText
                ToolTip.visible: toolTipText ? ma.containsMouse : false

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }
        }

        ToolBar {
            id: toolBar
            x: 0
            y: 0
            width: 1000
            height: 48
            Material.background: "#fff"

            ComboBox {
                id: serialPortComboBox
                x: 8
                y: 9
                width: 120
                height: 30

                model: serialConnection.getPortList()

                background: Rectangle {
                    radius: 5
                    border.color: "#95A4A8"
                    border.width: .5
                }
            }

            ComboBox {
                id: baudRateComboBox
                x: 136
                y: 9
                width: 120
                height: 30

                model: ["9600", "115200"]

                background: Rectangle {
                    radius: 5
                    border.color: "#95A4A8"
                    border.width: .5
                }
            }

            Button {
                id: button
                x: 264
                y: 2
                width: 105
                height: 41
                text: qsTr("Connect")

                onClicked: () => {
                    // console.log(serialPortComboBox.currentText, baudRateComboBox.currentText)
                    // messageDialog.visible = true
                    popup.open()
                }
            }

            Button {
                id: button2
                x: 378
                y: 2
                width: 105
                height: 41
                text: qsTr("Close")
            }
        }

        MessageDialog {
            id: messageDialog
            title: ""
            text: ""
            informativeText: ""
            buttons: MessageDialog.Ok | MessageDialog.Cancel
            onAccepted: {
                // console.log("And of course you could only agree.")
                Qt.quit()
            }
            // Component.onCompleted: visible = true
        }

        Popup {
            id: popup
            x: 100
            y: 100
            width: 200
            height: 300
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        }
    }
}
