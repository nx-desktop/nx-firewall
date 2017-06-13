import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    height: 600
    width: 400
    ListModel {
        id: sampleModel
        ListElement {
            action: "Firefox - Web Browser"
            from: "firefox"
            to: ""
            ipv6: true
        }
    }

    ScrollView {
        anchors.fill: parent
        ListView {
            model: sampleModel
            delegate: PlasmaComponents.ListItem {
                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 48

                    spacing: 4

                    PlasmaCore.IconItem {
                        source: icon

                        Layout.preferredHeight: 48
                        Layout.preferredWidth: 48
                    }
                    PlasmaComponents.Label {

                        Layout.leftMargin: 12
                        text: name

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                    PlasmaComponents.ToolButton {
                        Layout.preferredHeight: 48
                        Layout.preferredWidth: 48
                        iconSource: networkAccess ? "network-connect" : "network-disconnect"
                        onClicked: networkAccess = !networkAccess
                        tooltip: networkAccess ? i18n("Network access enabled") : i18n(
                                                     "Network access disabled")
                    }
                }
            }
            headerPositioning: ListView.PullBackHeader
            header: RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right

                height: 32
                spacing: 4
                PlasmaComponents.Label {
                    Layout.fillWidth: true
                    text: i18n("Application")

                    font.pointSize: 12
                }

                PlasmaComponents.TextField {
                    Layout.minimumWidth: 180
                    placeholderText: i18n("Filter")
                }
            }

            RowLayout {
                anchors.bottom: parent.bottom
                anchors.right: parent.right

                PlasmaComponents.ToolButton {
                    iconSource: "list-remove-symbolic"
                }

                PlasmaComponents.ToolButton {
                    iconSource: "list-add-symbolic"
                }
                PlasmaComponents.ToolButton {
                    iconSource: "draw-arrow-up"
                }
                PlasmaComponents.ToolButton {
                    iconSource: "draw-arrow-down        "
                }
            }
        }
    }
}
