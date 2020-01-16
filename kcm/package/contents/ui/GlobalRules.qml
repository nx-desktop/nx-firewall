
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

ColumnLayout {

    RowLayout {
        Rectangle {
            height: 28
            width: 28
            radius: 14
            color: ufwClient.enabled ? "lightgreen" : "lightgray"
        }

        Kirigami.Heading {
            level: 3
            Layout.leftMargin: 12
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            text: ufwClient.enabled ? i18n("Firewall enabled")
                                    : i18n("Firewall disabled")
        }

        QQC2.Button {
            text: ufwClient.enabled ? i18n("Disable") : i18n("Enable")
            onClicked: ufwClient.enabled = !ufwClient.enabled
        }
    }

    RowLayout {
        Layout.topMargin: 12
        Kirigami.Heading {
            level: 4
            text: i18n("Default Incoming Policy:")
        }

        RowLayout {
            Layout.leftMargin: 24
            QQC2.Button {
                text: i18n("Allow")
                checked: ufwClient.defaultIncomingPolicy === "allow"
                onClicked: ufwClient.defaultIncomingPolicy = "allow"
            }
            QQC2.Button {
                text: i18n("Deny")
                checked: ufwClient.defaultIncomingPolicy === "deny"
                onClicked: ufwClient.defaultIncomingPolicy = "deny"
            }
            QQC2.Button {
                text: i18n("Reject")
                checked: ufwClient.defaultIncomingPolicy === "reject"
                onClicked: ufwClient.defaultIncomingPolicy = "reject"
            }
        }
    }

    RowLayout {
        Kirigami.Heading {
            level: 4
            text: i18n("Default Outgoing Policy:")
        }

        RowLayout {
            Layout.leftMargin: 24
            QQC2.Button {
                text: i18n("Allow")
                checked: ufwClient.defaultOutgoingPolicy === "allow"
                onClicked: ufwClient.defaultOutgoingPolicy = "allow"
            }
            QQC2.Button {
                text: i18n("Deny")
                checked: ufwClient.defaultOutgoingPolicy === "deny"
                onClicked: ufwClient.defaultOutgoingPolicy = "deny"
            }
            QQC2.Button {
                text: i18n("Reject")
                checked: ufwClient.defaultOutgoingPolicy === "reject"
                onClicked: ufwClient.defaultOutgoingPolicy = "reject"
            }
        }
    }
}
