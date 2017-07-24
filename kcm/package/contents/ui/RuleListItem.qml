import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: itemRoot

    property bool dropAreasVisible: false

    signal move(int from, int to)
    signal edit(int index)
    signal remove(int index)

    height: upperSpacer.height + dragableItem.height + lowerSpacer.height

    DropArea {
        id: upperDropArea
        anchors {
            top: parent.top
            bottom: dragableItem.verticalCenter
            left: parent.left
            right: parent.right
        }

        visible: dropAreasVisible && !dragArea.drag.active
        enabled: !dragArea.drag.active && index == 0

        onEntered: drag.source.dropIndex = index
        onExited: drag.source.dropIndex = -1
    }

    PlasmaCore.FrameSvgItem {
        id: upperSpacer
        anchors.left: parent.left
        anchors.right: parent.right
        imagePath: "translucent/widgets/panel-background"

        height: 0
        visible: false

        PlasmaComponents.Label {
            text: i18n("Drop rule")
            anchors.centerIn: parent
        }

        states: [
            State {
                name: "expanded"
                when: upperDropArea.containsDrag
                PropertyChanges {
                    target: upperSpacer
                    height: 48
                    visible: true
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                properties: "height"
                easing.type: Easing.InOutQuad
                duration: 200
            }
        }
    }

    PlasmaComponents.ListItem {
        id: dragableItem
        y: upperSpacer.height

        anchors.left: parent.left
        anchors.right: parent.right
        height: 48

        property int dropIndex: -1
        property int base_x: 0
        property int base_y: 0

        Component.onCompleted: {
            dragableItem.base_x = dragableItem.x
            dragableItem.base_y = dragableItem.y
        }

        MouseArea {
            id: itemRootMouseArea
            anchors.fill: parent
            hoverEnabled: true

            acceptedButtons: Qt.LeftButton
            onClicked: edit(index)

            onEntered: eraseButton.visible = true
            onExited: eraseButton.visible = false
            propagateComposedEvents: true
        }

        checked: dragArea.drag.active

        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: dragArea.width / 2
        Drag.hotSpot.y: dragArea.height / 2

        z: Drag.active ? 100 : 0

        RowLayout {
            anchors.fill: parent

            Item {
                Layout.leftMargin: 4
                height: 32
                width: 32

                PlasmaCore.IconItem {
                    anchors.centerIn: parent
                    height: 18
                    width: height
                    source: "application-menu"
                    visible: itemRootMouseArea.containsMouse
                }

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: dragableItem
                    cursorShape: dragArea.pressed ? Qt.DragMoveCursor : Qt.OpenHandCursor
                    onReleased: {
                        // allways return the item to it's original position
                        dragableItem.x = dragableItem.base_x
                        dragableItem.y = Qt.binding(function () {return upperSpacer.height})

                        if (dragableItem.dropIndex != index
                                && dragableItem.dropIndex - 1 != index)
                            move(index, dragableItem.dropIndex)
                    }
                }
            }

            PlasmaComponents.Label {
                Layout.minimumWidth: 120
                Layout.fillHeight: true
                Layout.leftMargin: 4
                text: model.action
            }
            PlasmaComponents.Label {
                Layout.minimumWidth: 160
                text: model.from
            }
            PlasmaComponents.Label {
                Layout.minimumWidth: 160
                text: model.to
            }
            //        PlasmaComponents.Label {
            //            Layout.minimumWidth: 60
            //            text: model.ipv6 ? "IPv6" : ""
            //        }
            PlasmaComponents.Label {
                Layout.leftMargin: 12
                text: model.logging
            }

            Item {
                //                Layout.fillWidth: true
                height: 32
                width: 32

                PlasmaComponents.ToolButton {
                    id: eraseButton
                    minimumHeight: 32
                    minimumWidth: 32
                    //                    anchors.verticalCenter: parent.verticalCenter
                    //                    anchors.left: parent.left
                    //                    anchors.leftMargin: 32
                    visible: false
                    onHoveredChanged: visible = hovered

                    iconSource: "user-trash"
                    onClicked: itemRoot.remove(index)
                }
            }
        }
    }



    DropArea {
        id: lowerDropArea
        anchors {
            top: dragableItem.verticalCenter
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        visible: dropAreasVisible && !dragArea.drag.active
        enabled: !dragArea.drag.active

        onEntered: drag.source.dropIndex = index + 1
        onExited: drag.source.dropIndex = -1
    }

    PlasmaCore.FrameSvgItem {
        id: lowerSpacer
        anchors.left: parent.left
        anchors.right: parent.right
        imagePath: "translucent/widgets/panel-background"

        y: dragableItem.height
        height: 0
        visible: false

        PlasmaComponents.Label {
            text: i18n("Drop rule")
            anchors.centerIn: parent
        }

        states: [
            State {
                name: "expanded"
                when: lowerDropArea.containsDrag
                PropertyChanges {
                    target: lowerSpacer
                    height: 48
                    visible: true
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                properties: "height"
                easing.type: Easing.InOutQuad
                duration: 200
            }
        }
    }
}
