
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
import QtQuick.Controls 2.12 as QQC2

import org.kde.kirigami 2.4 as Kirigami

Kirigami.BasicListItem {
    id: itemRoot
    height: 42

    RowLayout {
        id: itemLayout
        spacing: 0

        QQC2.Label {
            Layout.leftMargin: 14
            text: "<i>" + model.time + "</i>"
        }

        QQC2.Label {
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
        QQC2.Label {
            Layout.leftMargin: 0
            text: ":" + model.sourcePort
            visible: sourcePort
        }

        QQC2.Label {
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
        QQC2.Label {
            Layout.leftMargin: 0
            text: ":" + destinationPort
            visible: destinationPort
        }
        QQC2.Label {
            visible: false
            Layout.leftMargin: 4
            text: i18n(" at <b>%1</b>", model.interface)
        }

        Image {
            source: action == "UFW BLOCK" ? "tab-close" : ""
        }

        QQC2.Label {
            text: model.action
        }

        Text {
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
            visible: !filterButton.visible
            height: filterButton.height
            width: filterButton.width
        }

        QQC2.ToolButton {
            id: filterButton
            visible: itemRoot.containsMouse


            icon.name: "view-filter"
            onClicked: mainWindow.createRuleFromLog(model.protocol,
                                                    model.sourceAddress,
                                                    model.sourcePort,
                                                    model.destinationAddress,
                                                    model.destinationPort,
                                                    model.interface)
        }

        Item {
            Layout.fillWidth: true
        }
    }
}
