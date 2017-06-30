import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.nomad.ufw 1.0 as UFW

Popup {
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    signal accept(var rule)
    property var rule: UFW.Rule {
        policy: "deny"
        incoming: true
        logging: "none"
    }
    property bool newRule: false

    onAccept: {
        if (newRule)
            ufwClient.addRule(rule)
        else
            ufwClient.updateRule(rule)

        close()
    }
    Component.onCompleted: open()

    GridLayout {
        anchors.fill: parent

        columns: 6
//        rowSpacing: 24

        PlasmaExtras.Heading {
            level: 4
            text: i18n("Policy:")
        }

        PlasmaComponents.ButtonRow {
            Layout.columnSpan: 5
            PlasmaComponents.Button {
                text: i18n("Allow")
                checked: rule.policy === "allow"
                onClicked: rule.policy = "allow"
            }
            PlasmaComponents.Button {
                text: i18n("Deny")
                checked: rule.policy === "deny"
                onClicked: rule.policy = "deny"
            }
            PlasmaComponents.Button {
                text: i18n("Reject")
                checked: rule.policy === "reject"
                onClicked: rule.policy = "reject"
            }
            PlasmaComponents.Button {
                text: i18n("Limit")
                checked: rule.policy === "limit"
                onClicked: rule.policy = "limit"
            }
        }

        PlasmaExtras.Heading {
            level: 4
            text: i18n("Direction:")
        }

        PlasmaComponents.ButtonRow {
            Layout.columnSpan: 5
            PlasmaComponents.Button {
                text: i18n("Incoming")
                iconName: "arrow-down"
                checked: rule.incoming
                onClicked: rule.incoming = true
            }
            PlasmaComponents.Button {
                text: i18n("Outgoing")
                iconName: "arrow-up"
                checked: !rule.incoming
                onClicked: rule.incoming = false
            }
        }

        GroupBox {
            title: i18n("Source")

            Layout.fillWidth: true
            Layout.columnSpan: 3

            GridLayout {
                columns: 3
                anchors.fill: parent
                PlasmaComponents.Label {
                    text: i18n("Address:")
                }
                PlasmaComponents.TextField {
                    id: sourceAddress
                    Layout.fillWidth: true

                    placeholderText: "0.0.0.0/0"
                    text: rule.sourceAddress
                    onTextChanged: rule.sourceAddress = text
                    property var originalValue

                    Component.onCompleted: originalValue = rule.sourceAddress
                }
                PlasmaComponents.CheckBox {
                    text: i18n("Any")
                    checked: sourceAddress.text == ""
                             || sourceAddress.text == "0.0.0.0/0"
                    onClicked: sourceAddress.text = checked ? "" : sourceAddress.originalValue
                }
                PlasmaComponents.Label {
                    text: i18n("Port:")
                }
                PlasmaComponents.TextField {
                    id: sourcePort
                    text: rule.sourcePort
                    onTextChanged: rule.sourcePort = text
                    placeholderText: "0/0"
                    property var originalValue

                    Component.onCompleted: originalValue = rule.sourcePort
                }
                PlasmaComponents.CheckBox {
                    text: i18n("Any")
                    Layout.fillWidth: true

                    checked: sourcePort.text == "" || sourcePort.text == "0/0"
                    onClicked: sourcePort.text = checked ? "" : sourcePort.originalValue
                }
            }
        }

        GroupBox {
            title: i18n("Destination")

            Layout.fillWidth: true
            Layout.columnSpan: 3

            GridLayout {
                anchors.fill: parent
                columns: 3
                PlasmaComponents.Label {
                    text: i18n("Address:")
                }
                PlasmaComponents.TextField {
                    id: destinationAddress
                    Layout.fillWidth: true

                    placeholderText: "0.0.0.0/0"
                    text: rule.destinationAddress
                    onTextChanged: rule.destinationAddress = text
                }
                PlasmaComponents.CheckBox {
                    text: i18n("Any")
                    checked: destinationAddress.text == ""
                             || destinationAddress.text == "0.0.0.0/0"
                }
                PlasmaComponents.Label {
                    text: i18n("Port:")
                }
                PlasmaComponents.TextField {
                    id: destinationPort

                    placeholderText: "0/0"
                    text: rule.destinationPort
                    onTextChanged: rule.destinationPort = text
                }
                PlasmaComponents.CheckBox {
                    text: i18n("Any")
                    checked: destinationPort.text == ""
                             || destinationPort.text == "0/0"

                    Layout.fillWidth: true
                }
            }
        }
        PlasmaExtras.Heading {
            level: 4
            text: i18n("Protocol:")
        }
        PlasmaComponents.ComboBox {
            id: protocolCb

            model: ufwClient.getKnownProtocols()

            currentIndex: rule.protocol
            onCurrentIndexChanged: rule.protocol = currentIndex

            Layout.columnSpan: 2
        }
        PlasmaExtras.Heading {
            level: 4
            text: i18n("Interface:")
        }
        PlasmaComponents.ComboBox {
            id: interfaceCb

            model: ufwClient.getKnownInterfaces()

            currentIndex: rule.interface
            onCurrentIndexChanged: rule.interface = currentIndex

            Layout.columnSpan: 2
        }
        PlasmaExtras.Heading {
            level: 4
            text: i18n("Logging:")
        }

        PlasmaComponents.ButtonRow {
            Layout.columnSpan: 5
            PlasmaComponents.Button {
                text: i18n("None")
                checked: rule.logging === "none"
                onClicked: rule.logging = "none"
            }
            PlasmaComponents.Button {
                text: i18n("New connections")
                checked: rule.logging === "log"
                onClicked: rule.logging = "log"
            }
            PlasmaComponents.Button {
                text: i18n("All Packets")
                checked: rule.logging === "log-all"
                onClicked: rule.logging = "log-all"
            }
        }


        PlasmaComponents.Button {
            text: i18n("Cancel")
            iconName: "dialog-cancel"

            onClicked: close()
        }

        PlasmaComponents.Button {
            text: i18n("Accept")
            iconName: "dialog-ok"
            Layout.columnSpan: 5
            Layout.alignment: Qt.AlignRight

            onClicked: accept(rule)
        }
    }
}
