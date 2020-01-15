
/*
 * Copyright 2018 Alexis Lopes Zubeta <contact@azubieta.net>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
