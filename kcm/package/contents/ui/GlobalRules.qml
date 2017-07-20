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
