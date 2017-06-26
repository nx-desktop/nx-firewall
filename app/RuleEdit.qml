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

    property var rule: UFW.Rule
    onAccept: close()
    onOpened: {
        contentLoader.sourceComponent = content;
    }
    onClosed: {
        rule = undefined
        contentLoader.sourceComponent == undefined;
    }

    Loader {
        id: contentLoader
        anchors.fill: parent
    }

    Component {
        id: content
        GridLayout {
            columns: 6
            rowSpacing: 24

            PlasmaExtras.Heading {
                level: 2
                text: i18n("Rule details")

                Layout.columnSpan: 6
            }

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
                        text: rule.sourceAddress
                        onTextChanged: rule.sourceAddress = text
                    }
                    PlasmaComponents.CheckBox {
                        text: i18n("Any")
                        onCheckedChanged: {
                            sourceAddress.enabled = !checked
                            sourceAddress.text = checked ? "0.0.0.0/0" : ""
                        }
                    }
                    PlasmaComponents.Label {
                        text: i18n("Port:")
                    }
                    PlasmaComponents.TextField {
                        id: sourcePort
                        text: rule.sourcePort
                        onTextChanged: rule.sourcePort = text
                    }
                    PlasmaComponents.CheckBox {
                        text: i18n("Any")
                        onCheckedChanged: {
                            sourcePort.enabled = !checked
                            sourcePort.text = checked ? "0/0" : ""
                        }
                        Layout.fillWidth: true
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
                        text: rule.destinationAddress
                        onTextChanged: rule.destinationAddress = text
                    }
                    PlasmaComponents.CheckBox {
                        text: i18n("Any")
                        onCheckedChanged: {
                            destinationAddress.enabled = !checked
                            destinationAddress.text = checked ? "0.0.0.0/0" : ""
                        }
                    }
                    PlasmaComponents.Label {
                        text: i18n("Port:")
                    }
                    PlasmaComponents.TextField {
                        id: destinationPort
                        text: rule.destinationPort
                        onTextChanged: rule.destinationPort = text
                    }
                    PlasmaComponents.CheckBox {
                        text: i18n("Any")
                        onCheckedChanged: {
                            destinationPort.enabled = !checked
                            destinationPort.text = checked ? "0/0" : ""
                        }

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

                model: ["Any", "TCP", "UDP"]

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

                model: ["Any", "lo", "enp1s0", "wlo1"]

                Component.onCompleted: {
                    var i = 0
                    print("Interface", rule.interface)
                    for (; i < model.count(); i ++) {
                        if (model[i] == rule.interface)
                            break;
                    }
                    if (i == model.count())
                        currentIndex == -1
                    else
                        currentText == i;
                }
                onCurrentIndexChanged: rule.interface = model[currentIndex];

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

            Item {
                Layout.columnSpan: 6
                Layout.fillHeight: true
                Layout.fillWidth: true
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

                onClicked: {
                    accept(rule)
                }
            }
        }
    }
}
