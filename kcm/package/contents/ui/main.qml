
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

import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.9 as QQC2

import org.kde.kcm 1.0
import org.nomad.ufw 1.0
import org.nomad.netstat 1.0

import org.kde.kirigami 2.4 as Kirigami
import org.kde.kcm 1.1 as KCM

KCM.SimpleKCM {
    id: root

    implicitHeight: Kirigami.Units.gridUnit * 22

    KCM.ConfigModule.quickHelp: i18n("This module lets you configure firewall.")

    UfwClient {
        id: ufwClient
        logsAutoRefresh: tabButtons.currentTab == logsTabButton
    }

    NetstatClient {
        id: netStatClient
    }

    Loader {
        id: ruleDetailsLoader
    }

    ColumnLayout {
        Kirigami.InlineMessage {
            id: netstatError
            type: Kirigami.MessageType.Information
            text: netStatClient.status !== ""
            visible: netStatClient.status !== ""
            Layout.fillWidth: true
        }

        Kirigami.InlineMessage {
            id: ufwError
            type: Kirigami.MessageType.Information
            text: ufwClient.status
            visible: ufwClient.status !== ""
            Layout.fillWidth: true
        }

        QQC2.TabBar {
            id: tabButtons

            QQC2.TabButton {
                text: i18n("Rules")
            }
            QQC2.TabButton {
                text: i18n("Connections")
            }
            QQC2.TabButton {
                text: i18n("Logs")
            }
        }

        StackLayout {
            id: tabGroup
            currentIndex: tabButtons.currentIndex

            Layout.fillWidth: true
            Layout.fillHeight: true

            RulesView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            ConnectionsView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            LogsView {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    function createRuleFromConnection(protocol, localAddress, foreignAddres, status) {
        // Transform to the ufw notation
        localAddress = localAddress.replace("*", "")
        foreignAddres = foreignAddres.replace("*", "")

        localAddress = localAddress.replace("0.0.0.0", "")
        foreignAddres = foreignAddres.replace("0.0.0.0", "")

        var localAddressData = localAddress.split(":")
        var foreignAddresData = foreignAddres.split(":")

        var rule = Qt.createQmlObject("import org.nomad.ufw 1.0; Rule {}",
                                      mainWindow)

        // Prepare rule draft
        if (status === "LISTEN") {
            // Create deny incoming rule
            rule.incoming = true
            rule.policy = "deny"

            rule.sourceAddress = foreignAddresData[0]
            rule.sourcePort = foreignAddresData[1]

            rule.destinationAddress = localAddressData[0]
            rule.destinationPort = localAddressData[1]
        } else {
            // Create deny outgoing rule
            rule.incoming = false
            rule.policy = "deny"

            rule.sourceAddress = localAddressData[0]
            rule.sourcePort = localAddressData[1]

            rule.destinationAddress = foreignAddresData[0]
            rule.destinationPort = foreignAddresData[1]
        }

        var protocols = ufwClient.getKnownProtocols()
        rule.protocol = protocols.indexOf(protocol.toUpperCase())

        ruleDetailsLoader.setSource("RuleEdit.qml", {
                                        rule: rule,
                                        newRule: true,
                                        x: 0,
                                        y: 0,
                                        height: mainWindow.height,
                                        width: mainWindow.width
                                    })
    }

    function createRuleFromLog(protocol, sourceAddress, sourcePort, destinationAddress, destinationPort, inn, out) {
        // Transform to the ufw notation
        sourceAddress = sourceAddress.replace("*", "")
        destinationAddress = destinationAddress.replace("*", "")

        sourceAddress = sourceAddress.replace("0.0.0.0", "")
        destinationAddress = destinationAddress.replace("0.0.0.0", "")

        var rule = Qt.createQmlObject("import org.nomad.ufw 1.0; Rule {}",
                                      mainWindow)

        // Prepare rule draft
        rule.incoming = (inn !== "")
        rule.policy = "allow"
        rule.sourceAddress = sourceAddress
        rule.sourcePort = sourcePort

        rule.destinationAddress = destinationAddress
        rule.destinationPort = destinationPort

        var protocols = ufwClient.getKnownProtocols()
        rule.protocol = protocols.indexOf(protocol.toUpperCase())

        ruleDetailsLoader.setSource("RuleEdit.qml", {
                                        rule: rule,
                                        newRule: true,
                                        x: 0,
                                        y: 0,
                                        height: mainWindow.height,
                                        width: mainWindow.width
                                    })
    }
}
