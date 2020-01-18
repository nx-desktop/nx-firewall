
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

import org.kde.kcm 1.1 as KCM
import org.nomad.ufw 1.0
import org.nomad.netstat 1.0

import org.kde.kirigami 2.4 as Kirigami

KCM.SimpleKCM {
    id: root

    implicitHeight: Kirigami.Units.gridUnit * 22

    KCM.ConfigModule.quickHelp: i18n("This module lets you configure firewall.")

    UfwClient {
        id: ufwClient
        logsAutoRefresh: true
    }

    NetstatClient {
        id: netStatClient
    }

    Kirigami.OverlaySheet {
        id: drawer
        parent: root.parent
        topPadding: 0
        leftPadding: 0
        rightPadding: 0
        bottomPadding: 0

        RuleEdit {
            id: ruleEdit
            height: childrenRect.height
            implicitWidth: 18 * Kirigami.Units.gridUnit
        }
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

            RulesView {
                onNewRuleRequest: {
                    ruleEdit.newRule = true
                    drawer.open();
                }
                onEditRuleRequest: {
                    ruleEdit.rule = rule
                    ruleEdit.newRule = false
                    drawer.open()
                }
            }

            ConnectionsView {
                onFilterConnection: {
                    var rule = ufwClient.createRuleFromConnection(protocol, localAddress, foreignAddres, status)
                    ruleEdit.rule
                    ruleEdit.newRule = true
                    drawer.open();
                }
            }

            LogsView {
                onFilterLog: {
                    var rule = ufwClient.createRuleFromLog(protocol, sourceAddress, sourcePort, destinationAddress, destinationPort, iface)
                    ruleEdit.rule
                    ruleEdit.newRule = true
                    drawer.open();
                }
            }
        }
    }
}
