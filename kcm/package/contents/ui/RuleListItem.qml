import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: itemRoot

    height: dragableItem.height

    property bool isLast: false
    signal move(int from, int to)
    signal edit(int index)
    signal remove(int index)

    MouseArea {
        id: itemRootMouseArea
        anchors.fill: parent
        hoverEnabled: true

        acceptedButtons: Qt.LeftButton
        onClicked: edit(index)

        onEntered: eraseButton.visible = true
        onExited: eraseButton.visible = false
        propagateComposedEvents: true

        Rectangle {
            anchors.fill: parent
            color: parent.containsMouse ? "green" : "blue"
            opacity: 0.5
        }
    }

    DropArea {
        id: upperDropArea
        height: 9
        anchors.left: parent.left
        anchors.right: parent.right
        y: 0

        onEntered: drag.source.dropIndex = index
        onExited: drag.source.dropIndex = -1
        Rectangle {
            anchors.fill: parent
            color: parent.containsDrag ? theme.highlightColor : "transparent"
        }

        states: [
            State {
                name: "hovered"
                when: upperDropArea.containsDrag
                PropertyChanges {
                    target: upperDropArea
                    height: 18
                    y: -9
                }
            }
        ]

        transitions: Transition {
            NumberAnimation {
                properties: "height,y"
                easing.type: Easing.InOutQuad
                duration: 200
            }
        }
    }

    PlasmaComponents.ListItem {
        id: dragableItem
        height: 48
        property int dropIndex: -1
        property int base_x: 0
        property int base_y: 0

        Component.onCompleted: {
            dragableItem.base_x = dragableItem.x
            dragableItem.base_y = dragableItem.y
        }

        checked: dragArea.drag.active

        z: dragArea.drag.active ? 100 : 0
        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: dragArea.width / 2
        Drag.hotSpot.y: dragArea.height / 2

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
                        print(dragableItem.dropIndex, index)
                        if (dragableItem.dropIndex == -1
                                || index + 1 == dragableItem.dropIndex
                                || index == dragableItem.dropIndex) {
                            dragableItem.x = dragableItem.base_x
                            dragableItem.y = dragableItem.base_y
                        } else
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
                Layout.fillWidth: true
                height: 32
                width: 32

                PlasmaComponents.ToolButton {
                    id: eraseButton
                    height: 32
                    width: 32
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 32
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
        visible: isLast
        height: 9

        anchors.left: parent.left
        anchors.right: parent.right
        y: height

        onEntered: drag.source.dropIndex = index + 1
        onExited: drag.source.dropIndex = -1
        Rectangle {
            anchors.fill: parent
            color: parent.containsDrag ? theme.highlightColor : "transparent"
        }

        states: [
            State {
                name: "hovered"
                when: lowerDropArea.containsDrag
                PropertyChanges {
                    target: lowerDropArea
                    height: 18
                    y: height + 9
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
