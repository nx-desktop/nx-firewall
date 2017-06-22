import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    property alias model: listView.model

    FocusScope {
        anchors.fill: parent
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
