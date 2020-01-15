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
            text: model.program !== "" ? model.program : ""
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
