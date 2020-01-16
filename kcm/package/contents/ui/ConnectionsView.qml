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

/* TODO: Move this to a Table View */
QQC2.ScrollView {
    ListView {
        clip: true
        anchors.fill: parent
        model: netStatClient.connections()
        delegate: ConnectionItemDelegate {
            onFilterConnection: mainWindow.createRuleFromConnection(protocol, localAddress, foreignAddres, status)
        }

        headerPositioning: ListView.OverlayHeader
        header: RowLayout {
            height: 40
            z: 100

            QQC2.Label {
                Layout.leftMargin: 12
                Layout.preferredWidth: 60
                text: i18n("Protocol")
            }
            QQC2.Label {
                Layout.preferredWidth: 160
                text: i18n("Local Address")
            }
            QQC2.Label {
                Layout.preferredWidth: 160
                text: i18n("Foreign Address")
            }
            QQC2.Label {
                Layout.preferredWidth: 100
                text: i18n("Status")
            }
            QQC2.Label {
                Layout.preferredWidth: 40
                text: i18n("PID")
            }
            QQC2.Label {
                Layout.preferredWidth: 120
                text: i18n("Program")
            }
        }
    }
}
