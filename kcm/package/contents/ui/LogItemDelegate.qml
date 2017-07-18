import QtQuick 2.0
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

PlasmaComponents.ListItem {
    id: itemRoot
    height: 42

    MouseArea {
        anchors.fill: parent
        onEntered: filterButton.visible = true
        onExited: filterButton.visible = false
        hoverEnabled: true
    }
    RowLayout {
        id: itemLayout
        spacing: 0
        anchors.fill: parent

        PlasmaComponents.Label {
            Layout.leftMargin: 14
            text: "<i>" + model.time + "</i>"
        }

        PlasmaComponents.Label {
            Layout.leftMargin: 12
            text: i18n("from") + "<b> %1</b>".arg(sourceAddress)

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally(
                               "https://www.geoiptool.com/?ip=%1".arg(
                                   sourceAddress))
                cursorShape: Qt.PointingHandCursor
            }
        }
        PlasmaComponents.Label {
            Layout.leftMargin: 0
            text: ":" + sourcePort
            visible: sourcePort
        }

        PlasmaComponents.Label {
            Layout.leftMargin: 6
            text: i18n("to <b>") + destinationAddress + "</b>"

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally(
                               "https://www.geoiptool.com/?ip=%1".arg(
                                   destinationAddress))
                cursorShape: Qt.PointingHandCursor
            }
        }
        PlasmaComponents.Label {
            Layout.leftMargin: 0
            text: ":" + destinationPort
            visible: destinationPort
        }
        PlasmaComponents.Label {
            visible: false
            Layout.leftMargin: 4
            text: i18n(" at <b>%1</b>", model.interface)
        }
        PlasmaComponents.Label {
            Layout.fillWidth: true
        }

        //                    PlasmaCore.IconItem {
        //                        source: action == "UFW BLOCK" ? "tab-close" : ""
        //                    }
        PlasmaComponents.Label {
            text: model.action
        }

        Text {
            Layout.preferredWidth: 40
            Layout.leftMargin: 6
            horizontalAlignment: Text.AlignHCenter
            text: protocol.toLowerCase()
            color: {
                if (protocol.startsWith("UDP"))
                    return "brown"
                if (protocol.startsWith("TCP"))
                    return "#006501"
                return "gray"
            }
        }

        Item {
            height: 32
            width: 32
            PlasmaComponents.ToolButton {
                id: filterButton
                anchors.fill: parent
                visible: false
                onHoveredChanged: visible = hovered

                iconSource: "view-filter"
                onClicked: mainWindow.createRuleFromLog(model.protocol,
                                                        model.sourceAddress,
                                                        model.sourcePort,
                                                        model.destinationAddress,
                                                        model.destinationPort,
                                                        model.interface)
            }
        }
    }
}
