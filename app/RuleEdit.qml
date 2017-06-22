import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Popup {
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    GridLayout {
        columns: 6
        rowSpacing:  24

        anchors.fill: parent
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
                PlasmaComponents.ToolButton {
                    text: i18n("Allow")
                }
                PlasmaComponents.ToolButton {
                    text: i18n("Deny")
                }
                PlasmaComponents.ToolButton {
                    text: i18n("Reject")
                }
                PlasmaComponents.ToolButton {
                    text: i18n("Limit")
                }
        }

        PlasmaExtras.Heading {
            level: 4
            text: i18n("Direction:")
        }

        PlasmaComponents.ButtonRow {
            Layout.columnSpan: 5
                PlasmaComponents.ToolButton {
                    text: i18n("Incoming")
                    iconName: "arrow-down"
                }
                PlasmaComponents.ToolButton {
                    text: i18n("Outgoing")
                    iconName: "arrow-up"
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

            Layout.columnSpan: 2
        }
        PlasmaExtras.Heading {
            level: 4
            text: i18n("Interface:")
        }
        PlasmaComponents.ComboBox {
            id: interfaceCb

            model: ["Any", "lo", "enp1s0", "wlo1"]

            Layout.columnSpan: 2
        }
        PlasmaExtras.Heading {
            level: 4
            text: i18n("Logging:")
        }

        PlasmaComponents.ButtonRow {
            Layout.columnSpan: 5
                PlasmaComponents.ToolButton {
                    text: i18n("None")
                }
                PlasmaComponents.ToolButton {
                    text: i18n("New connections")
                }
                PlasmaComponents.ToolButton {
                    text: i18n("All Packets")
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
        }

        PlasmaComponents.Button {
            text: i18n("Accept")
            iconName: "dialog-ok"
            Layout.columnSpan: 5
            Layout.alignment: Qt.AlignRight
        }
    }
}
