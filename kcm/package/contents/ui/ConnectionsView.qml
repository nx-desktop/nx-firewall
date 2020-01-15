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

import QtQuick 2.7
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    id: connectionsViewRoot


    PlasmaExtras.ScrollArea {
        anchors.fill: parent
        ListView {
            clip: true
            anchors.fill: parent
            model: netStatClient.connections()
            delegate: ConnectionItemDelegate {
                onFilterConnection: mainWindow.createRuleFromConnection(protocol, localAddress, foreignAddres, status)

            }

            headerPositioning: ListView.OverlayHeader
            header: PlasmaCore.FrameSvgItem {
                height: 40
                z: 100

                anchors.left: parent.left
                anchors.right: parent.right

                imagePath: "opaque/widgets/panel-background"
                enabledBorders: PlasmaCore.FrameSvgItem.NoBorder

                RowLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    PlasmaComponents.Label {
                        Layout.leftMargin: 12
                        Layout.preferredWidth: 60
                        text: i18n("Protocol")
                    }
                    PlasmaComponents.Label {
                        Layout.preferredWidth: 160
                        text: i18n("Local Address")
                    }
                    PlasmaComponents.Label {
                        Layout.preferredWidth: 160
                        text: i18n("Foreign Address")
                    }
                    PlasmaComponents.Label {
                        Layout.preferredWidth: 100
                        text: i18n("Status")
                    }
                    //                    PlasmaComponents.Label {
                    //                        Layout.preferredWidth: 40
                    //                        text: i18n("PID")
                    //                    }
                    PlasmaComponents.Label {
                        Layout.preferredWidth: 120
                        text: i18n("Program")
                    }
                }
            }
        }
    }
}
