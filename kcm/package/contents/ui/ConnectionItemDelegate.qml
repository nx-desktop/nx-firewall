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

import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12 as QQC2

import org.kde.kirigami 2.4 as Kirigami

Kirigami.BasicListItem {
    id: root

    signal filterConnection(var protocol, var localAddress, var foreignAddres, var status)

    RowLayout {
        id: layout
        height: iconButton.height

        QQC2.Label {
            Layout.leftMargin: 12
            Layout.preferredWidth: 60
            text: model.protocol
        }
        QQC2.Label {
            Layout.preferredWidth: 160
            text: model.localAddress
        }
        QQC2.Label {
            Layout.preferredWidth: 160
            text: model.foreignAddress
        }
        QQC2.Label {
            Layout.preferredWidth: 100
            text: model.status
        }
        QQC2.Label {
            Layout.preferredWidth: 40
            text: model.pid
        }
        QQC2.Label {
            Layout.preferredWidth: 120
            text: model.program !== "" ? model.program : ""
        }
        Item {
            visible: !root.containsMouse
            height: iconButton.height
            width: iconButton.width
        }
        QQC2.ToolButton {
            id: iconButton
            visible: root.containsMouse
            icon.name: "view-filter"
            onClicked: root.filterConnection(model.protocol, model.localAddress,
                                                model.foreignAddress, model.status)
        }
    }
}
