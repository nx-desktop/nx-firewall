import QtQuick 2.0
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    id: root
    Component {
        id: sectionHeading
        PlasmaComponents.ListItem {
            sectionDelegate: true
            Item {
                height: 40
                width: 200
                PlasmaExtras.Heading {
                    anchors.fill: parent
                    anchors.leftMargin: 12
//                    horizontalAlignment: Text.AlignHCenter
                    text: section
                }
            }
        }
    }

    PlasmaExtras.ScrollArea {
        anchors.fill: parent
        ListView {
            model: ufwClient.logs()
            delegate: PlasmaComponents.ListItem {
                checked: action !== "UFW BLOCK"

                RowLayout {
                    id: itemLayout
                    width: root.width - 20
                    spacing: 0
                    PlasmaComponents.Label {
                        Layout.leftMargin: 14
                        text: "<i>" + model.time + "</i>"
                    }

                    PlasmaComponents.Label {
                        Layout.leftMargin: 12
                        text: i18n("from") + "<b> %1</b>".arg(sourceAddress)

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.openUrlExternally("https://www.geoiptool.com/?ip=%1".arg(sourceAddress));
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                    PlasmaComponents.Label {
                        Layout.leftMargin: 0
                        text: ":" + sourcePort
                        visible: sourcePort
                    }

                    PlasmaComponents.Label {
                        Layout.leftMargin: 6
                        text: i18n("to <b>") + destinationAddress + "</b>"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Qt.openUrlExternally("https://www.geoiptool.com/?ip=%1".arg(destinationAddress));
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                    PlasmaComponents.Label {
                        Layout.leftMargin: 0
                        text: ":" + destinationPort
                        visible: destinationPort
                    }
                    PlasmaComponents.Label {
                        Layout.fillWidth: true
                    }

                    //                    PlasmaCore.IconItem {
                    //                        source: action == "UFW BLOCK" ? "tab-close" : ""
                    //                    }
                    PlasmaComponents.Label {
                        text: model.action
                    }

                    Text {
                        Layout.preferredWidth: 40
                        Layout.leftMargin: 6
                        horizontalAlignment: Text.AlignHCenter
                        text: protocol.toLowerCase()
                        color: {
                            if (protocol.startsWith("UDP"))
                                return "brown"
                            if (protocol.startsWith("TCP"))
                                return "#006501"
                            return "gray"
                        }
                    }
                }
            }

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: sectionHeading
        }
    }
}
