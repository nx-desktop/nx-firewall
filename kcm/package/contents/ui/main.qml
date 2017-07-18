import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

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
    }

    NetstatClient {
        id: netStatClient
    }

    Loader {
        id: ruleDetailsLoader
        anchors.fill: parent
    }

    TabView {
        id: tabs
        anchors.fill: parent
        Tab {
            title: i18n("Connections")

            ConnectionsView {
                Component.onCompleted: {
                    filterConnection.connect(mainWindow.createRuleFromConnection)
                }
            }
        }

        Tab {
            title: i18n("Rules")

            Item {
                GlobalRules {
                    id: globalControls

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    anchors.margins: 12
                    anchors.leftMargin: 18
                }

                PlasmaCore.FrameSvgItem {
                    anchors.top: globalControls.bottom
                    anchors.topMargin: 18
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    anchors.margins: 12

                    RulesView {
                        anchors.fill: parent
                        model: ufwClient.rules()
                    }

                    imagePath: "opaque/widgets/panel-background"
                }

            }
        }

        Tab {
            title: i18n("Logs")

            LogsView {
            }

            onActiveChanged: ufwClient.logsAutoRefresh = active
        }
    }


    PlasmaComponents.Label {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        text: ufwClient.status
    }

    function createRuleFromConnection( protocol, localAddress, foreignAddres, status) {
        // Transform to the ufw notation
        localAddress = localAddress.replace("*","")
        foreignAddres = foreignAddres.replace("*","")

        localAddress = localAddress.replace("0.0.0.0","")
        foreignAddres = foreignAddres.replace("0.0.0.0","")

        var localAddressData = localAddress.split(":");
        var foreignAddresData = foreignAddres.split(":");

        var rule = Qt.createQmlObject("import org.nomad.ufw 1.0; Rule {}", mainWindow);

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

    function createRuleFromLog( protocol, sourceAddress, sourcePort, destinationAddress, destinationPort, inn, out) {
        // Transform to the ufw notation
        sourceAddress = sourceAddress.replace("*","")
        destinationAddress = destinationAddress.replace("*","")

        sourceAddress = sourceAddress.replace("0.0.0.0","")
        destinationAddress = destinationAddress.replace("0.0.0.0","")

        var rule = Qt.createQmlObject("import org.nomad.ufw 1.0; Rule {}", mainWindow);

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
