import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

FocusScope {
    property alias model: listView.model

    ScrollView {
        anchors.fill: parent

        ListView {
            id: listView
            delegate: RuleListItem {
                onMove: function (from, to) {
                    // Force valid positions
                    to = Math.max(0, to)
                    to = Math.min(listView.model.rowCount() - 1, to)

                    // Hack to force the list to be redraw and the item return to
                    // its original position
                    if (from == to)
                        listView.model.modelReset()
                    else
                        listView.model.move(from, to)
                }

                onEdit: function (index) {
                    print(index)
                    var rule = ufwClient.getRule(index)
                    ruleDeatils.rule = rule;
                    print(rule.policy, rule.position)
                    ruleDeatils.open()
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


    RuleEdit {
        id: ruleDeatils
        x: 0
        y: 0
        height: parent.height
        width: parent.width

        onAccept: function (rule) {
            ufwClient.updateRule(rule);
        }
    }
}
