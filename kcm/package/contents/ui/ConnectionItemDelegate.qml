import QtQuick 2.0
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
    id: itemRoot
    height: 48
    anchors.left: parent.left
    anchors.right: parent.right

    hoverEnabled: true

    signal filterConnection(var protocol, var localAddress, var foreignAddres, var status)

    Rectangle {
        id: background
        anchors.fill: parent
        color: theme.highlightColor

        visible: itemRoot.containsMouse
    }

    RowLayout {
        id: layout
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        PlasmaComponents.Label {
            Layout.leftMargin: 12
            Layout.preferredWidth: 60
            text: model.protocol
        }
        PlasmaComponents.Label {
            Layout.preferredWidth: 160
            text: model.localAddress
        }
        PlasmaComponents.Label {
            Layout.preferredWidth: 160
            text: model.foreignAddress
        }
        PlasmaComponents.Label {
            Layout.preferredWidth: 100
            text: model.status
        }
//        PlasmaComponents.Label {
//            Layout.preferredWidth: 40
//            text: model.pid
//        }
        PlasmaComponents.Label {
            Layout.preferredWidth: 120
            text: model.program
        }
    }

    PlasmaComponents.ToolButton {
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.verticalCenter: parent.verticalCenter
        visible: itemRoot.containsMouse

        height: 48
        iconSource: "view-filter"
        onClicked: itemRoot.filterConnection(model.protocol, model.localAddress,
                                             model.foreignAddress, model.status)
    }
}
