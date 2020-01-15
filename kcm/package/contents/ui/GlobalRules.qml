
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


import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

ColumnLayout {

    RowLayout {
        Rectangle {
            height: 28
            width: 28
            radius: 14
            color: ufwClient.enabled ? "lightgreen" : "lightgray"
        }

        PlasmaExtras.Heading {
            level: 3
            Layout.leftMargin: 12
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            text: ufwClient.enabled ? i18n("Firewall enabled") : i18n(
                                          "Firewall disabled")
        }

        PlasmaComponents.Button {
            text: ufwClient.enabled ? i18n("Disable") : i18n("Enable")
            onClicked: ufwClient.enabled = !ufwClient.enabled
        }
    }

    RowLayout {
        Layout.topMargin: 12
        PlasmaExtras.Heading {
            level: 4
            text: i18n("Default Incoming Policy:")
        }

        PlasmaComponents.ButtonRow {
            Layout.leftMargin: 24
            PlasmaComponents.Button {
                text: i18n("Allow")
                checked: ufwClient.defaultIncomingPolicy === "allow"
                onClicked: ufwClient.defaultIncomingPolicy = "allow"
            }
            PlasmaComponents.Button {
                text: i18n("Deny")
                checked: ufwClient.defaultIncomingPolicy === "deny"
                onClicked: ufwClient.defaultIncomingPolicy = "deny"
            }
            PlasmaComponents.Button {
                text: i18n("Reject")
                checked: ufwClient.defaultIncomingPolicy === "reject"
                onClicked: ufwClient.defaultIncomingPolicy = "reject"
            }
        }
    }

    RowLayout {
        PlasmaExtras.Heading {
            level: 4
            text: i18n("Default Outgoing Policy:")
        }

        PlasmaComponents.ButtonRow {
            Layout.leftMargin: 24
            PlasmaComponents.Button {
                text: i18n("Allow")
                checked: ufwClient.defaultOutgoingPolicy === "allow"
                onClicked: ufwClient.defaultOutgoingPolicy = "allow"
            }
            PlasmaComponents.Button {
                text: i18n("Deny")
                checked: ufwClient.defaultOutgoingPolicy === "deny"
                onClicked: ufwClient.defaultOutgoingPolicy = "deny"
            }
            PlasmaComponents.Button {
                text: i18n("Reject")
                checked: ufwClient.defaultOutgoingPolicy === "reject"
                onClicked: ufwClient.defaultOutgoingPolicy = "reject"
            }
        }
    }
}
