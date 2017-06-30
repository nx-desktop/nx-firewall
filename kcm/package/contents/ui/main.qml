import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.kde.kcm 1.0
import org.nomad.ufw 1.0

Item {
    id: mainWindow

    implicitWidth: units.gridUnit * 44
    implicitHeight: units.gridUnit * 50
    clip: true

    UfwClient {
        id: ufwClient
    }

    ColumnLayout {
        id: globalControls

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.margins: 12
        anchors.leftMargin: 18

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
                text: i18n("Default Inconmig Policy:")
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

    Loader {
        id: ruleDetailsLoader
        anchors.fill: parent
    }


    Rectangle {
        anchors.top: globalControls.bottom
        anchors.topMargin: 18
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.margins: 12
        color: "white"

        RulesView {
            anchors.fill: parent
            model: ufwClient.rules()
        }
    }

    PlasmaComponents.Label {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        text: ufwClient.status
    }
}
