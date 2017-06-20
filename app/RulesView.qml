import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {

    ListModel {
        id: exampleRules
        ListElement {
            action: "1 Deny incoming"
            from: "Anywhere"
            to: "CUPS(631)"
            ipv6: false
            logging: "None"
        }
        ListElement {
            action: "2 Deny incoming"
            from: "Anywhere"
            to: "CUPS(631)"
            ipv6: false
            logging: "None"
        }
        ListElement {
            action: "3 Deny incoming"
            from: "Anywhere"
            to: "CUPS(631)"
            ipv6: false
            logging: "None"
        }
        ListElement {
            action: "4 Deny incoming"
            from: "Anywhere"
            to: "CUPS(631)"
            ipv6: false
            logging: "None"
        }
    }

    FocusScope {
        anchors.fill: parent
        ScrollView {
            anchors.fill: parent

            ListView {
                id: listView
                model: exampleRules
                delegate: RuleListItem {
                    onMove: function (from, to) {
                        // Force valid positions
                        to = Math.max(0, to)
                        to = Math.min(exampleRules.count - 1, to)
                        exampleRules.move(from, to, 1)
                        exampleRules.modelReset()
                    }

                }
            }
        }

        PlasmaComponents.ToolButton {
            height: 48
            iconSource: "list-add"
            text: i18n("New Rule")

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            anchors.right: parent.right
            anchors.rightMargin: 12
        }
    }
}
