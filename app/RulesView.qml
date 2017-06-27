import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.nomad.ufw 1.0 as UFW
FocusScope {
    id: rulesViewRoot
    property alias model: listView.model

    PlasmaExtras.ScrollArea {
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
                    var rule = ufwClient.getRule(index)
                    ruleDetailsLoader.setSource("RuleEdit.qml", {
                                                    rule: rule,
                                                    newRule: false,
                                                    x: 0,
                                                    y: 0,
                                                    height: rulesViewRoot.height,
                                                    width: rulesViewRoot.width
                                                })
                }
            }
        }
    }

    PlasmaComponents.ToolButton {
        height: 48
        iconSource: "list-add"
        text: i18n("New Rule")

        onClicked: {
            ruleDetailsLoader.setSource("RuleEdit.qml", {
                                            newRule: true,
                                            x: 0,
                                            y: 0,
                                            height: rulesViewRoot.height,
                                            width: rulesViewRoot.width
                                        })
        }

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12
    }

    Loader {
        id: ruleDetailsLoader
        anchors.fill: parent
    }
}
