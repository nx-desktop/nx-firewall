import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.kde.kcm 1.0
import org.nomad.ufw 1.0
import org.nomad.netstat 1.0

Item {
    id: mainWindow

    implicitWidth: units.gridUnit * 44
    implicitHeight: units.gridUnit * 50
    clip: true

    UfwClient {
        id: ufwClient
        logsAutoRefresh: tabButtons.currentTab == logsTabButton
    }

    NetstatClient {
        id: netStatClient
    }

    Loader {
        id: ruleDetailsLoader
        anchors.fill: parent
    }

    PlasmaCore.FrameSvgItem {
       anchors.fill: parent
       imagePath: "dialogs/background"
       enabledBorders: PlasmaCore.FrameSvg.NoBorder
    }

    PlasmaComponents.TabBar {
        id: tabButtons
        anchors.top: parent.top
        anchors.left: parent.left

        PlasmaComponents.TabButton {
            text: i18n("Rules")
            tab: rulesTab
        }
        PlasmaComponents.TabButton {
            text: i18n("Connections")
            tab: connectionsTab
        }
        PlasmaComponents.TabButton {
            id: logsTabButton
            text: i18n("Logs")
            tab: logsTab
        }
    }

    PlasmaComponents.TabGroup {
        id: tabGroup
        anchors.top: tabButtons.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 12

        PlasmaExtras.ConditionalLoader {
            id: rulesTab
            when: tabGroup.currentTab == rulesTab
            source: Qt.createComponent("RulesView.qml")
        }
        PlasmaExtras.ConditionalLoader {
            id: connectionsTab
            when: tabGroup.currentTab == connectionsTab
            source: Qt.createComponent("ConnectionsView.qml")
        }
        PlasmaExtras.ConditionalLoader {
            id: logsTab
            when: tabGroup.currentTab == logsTab
            source: Qt.createComponent("LogsView.qml")
        }
    }

    PlasmaComponents.Label {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        text: ufwClient.status
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
