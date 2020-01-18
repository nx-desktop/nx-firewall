import QtQuick 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.1

import QtQuick.Controls 2.12 as QQC2
import org.kde.kirigami 2.4 as Kirigami

import org.nomad.ufw 1.0 as UFW

Kirigami.FormLayout {
    signal accept(var rule)
    signal reject()

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
    }

    anchors.fill: parent

    RowLayout {
        Kirigami.FormData.label: "Policy:"
        QQC2.Button {
            text: i18n("Allow")
            checked: rule.policy === "allow"
            onClicked: rule.policy = "allow"
        }
        QQC2.Button {
            text: i18n("Deny")
            checked: rule.policy === "deny"
            onClicked: rule.policy = "deny"
        }
        QQC2.Button {
            text: i18n("Reject")
            checked: rule.policy === "reject"
            onClicked: rule.policy = "reject"
        }
        QQC2.Button {
            text: i18n("Limit")
            checked: rule.policy === "limit"
            onClicked: rule.policy = "limit"
        }
    }

    RowLayout {
        Kirigami.FormData.label: "Direction:"

        QQC2.Button {
            text: i18n("Incoming")
            icon.name: "arrow-down"
            checked: rule.incoming
            onClicked: rule.incoming = true
        }
        QQC2.Button {
            text: i18n("Outgoing")
            icon.name: "arrow-up"
            checked: !rule.incoming
            onClicked: rule.incoming = false
        }
    }

    GridLayout {
        Kirigami.FormData.label: "Source:"

        columns: 3
        QQC2.Label {
            text: i18n("Address:")
        }
        IpV4TextField {
            id: sourceAddress
            text: rule.sourceAddress
            onTextChanged: rule.sourceAddress = text

            //TODO: Move this to KConfigXT
            property var originalValue
            Component.onCompleted: originalValue = rule.sourceAddress
        }

        QQC2.CheckBox {
            text: i18n("Any")
            checked: sourceAddress.text == ""
                        || sourceAddress.text == "0.0.0.0/0"
            onClicked: sourceAddress.text = checked ? "" : sourceAddress.originalValue
        }
        QQC2.Label {
            text: i18n("Port:")
        }
        PortTextField{
            id: sourcePort
            text: rule.sourcePort
            onTextChanged: rule.sourcePort = text

            //TODO: Move this to KConfigXT
            property var originalValue
            Component.onCompleted: originalValue = rule.sourcePort
        }
        QQC2.CheckBox {
            text: i18n("Any")
            Layout.fillWidth: true

            checked: sourcePort.text == "" || sourcePort.text == "0/0"
            onClicked: sourcePort.text = checked ? "" : sourcePort.originalValue
        }
    }

    GridLayout {
        Kirigami.FormData.label: "Destination:"

        columns: 3
        QQC2.Label {
            text: i18n("Address:")
        }
        IpV4TextField {
            id: destinationAddress
            text: rule.destinationAddress
            onTextChanged: rule.destinationAddress = text
        }
        QQC2.CheckBox {
            text: i18n("Any")
            checked: destinationAddress.text == ""
                        || destinationAddress.text == "0.0.0.0/0"
        }
        QQC2.Label {
            text: i18n("Port:")
        }
        PortTextField {
            id: destinationPort
            placeholderText: "0/0"
            text: rule.destinationPort
            onTextChanged: rule.destinationPort = text
        }
        QQC2.CheckBox {
            text: i18n("Any")
            checked: destinationPort.text == ""
                        || destinationPort.text == "0/0"

            Layout.fillWidth: true
        }
    }

    QQC2.ComboBox {
        Kirigami.FormData.label: "Protocol:"

        id: protocolCb

        model: ufwClient.getKnownProtocols()

        currentIndex: rule.protocol
        onCurrentIndexChanged: rule.protocol = currentIndex
    }
    QQC2.ComboBox {
        Kirigami.FormData.label: "Interface:"

        id: interfaceCb

        model: ufwClient.getKnownInterfaces()

        currentIndex: rule.interface
        onCurrentIndexChanged: rule.interface = currentIndex

    }

    RowLayout {
        Kirigami.FormData.label: "Logging:"

        QQC2.Button {
            text: i18n("None")
            checked: rule.logging === "none"
            onClicked: rule.logging = "none"
        }
        QQC2.Button {
            text: i18n("New connections")
            checked: rule.logging === "log"
            onClicked: rule.logging = "log"
        }
        QQC2.Button {
            text: i18n("All Packets")
            checked: rule.logging === "log-all"
            onClicked: rule.logging = "log-all"
        }
    }
    Item {
        Layout.fillHeight: true
    }
    RowLayout {
        QQC2.Button {
            text: i18n("Cancel")
            icon.name: "dialog-cancel"

            onClicked: reject()
        }

        QQC2.Button {
            text: i18n("Accept")
            icon.name: "dialog-ok"

            onClicked: accept(rule)
        }
    }
}
