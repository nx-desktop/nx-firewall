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

    clip: true

    Component {
        id: sectionHeading
        PlasmaComponents.ListItem {
            sectionDelegate: true
            Item {
                height: 32
                width: 200
                PlasmaExtras.Heading {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    level: 4
                    text: section == "true" ? "IPv6" : "IPv4"
                }
            }
        }
    }

    PlasmaExtras.ScrollArea {
        id: listScrollArea
        anchors.fill: parent

        ListView {
            id: listView
            bottomMargin: 48 * 2
            delegate: RuleListItem {
                dropAreasVisible: true
                width: listView.width
                onMove: function (from, to) {
//                    print("moving ", from, " to ", to)
                    // Force valid positions
                    to = Math.max(0, to)
                    to = Math.min(listView.model.rowCount() - 1, to)

                    // Hack to force the list to be redraw and the item return to
                    // its original position
                    if (from !== to) {
                        listView.model.move(from, to)
                        ufwClient.moveRule(from, to)
                    }
                }

                onEdit: function (index) {
                    var rule = ufwClient.getRule(index)
                    ruleDetailsLoader.setSource("RuleEdit.qml", {
                                                    rule: rule,
                                                    newRule: false,
                                                    x: 0,
                                                    y: 0,
                                                    height: mainWindow.height,
                                                    width: mainWindow.width
                                                })
                }

                onRemove: function (index) {
                    ufwClient.removeRule(index)
                }
            }

            section.property: "ipv6"
            section.criteria: ViewSection.FullString
            section.delegate: sectionHeading
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
                                            height: mainWindow.height,
                                            width: mainWindow.width
                                        })
        }

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12
    }
}
