import QtQuick 2.7
import QtQuick.Layouts 1.3

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras


Item {
    PlasmaExtras.ScrollArea {
        anchors.fill: parent
        ListView {
            clip: true
            anchors.fill: parent
            model: netStatClient.connections()
            delegate: ConnectionItemDelegate {
            }

            headerPositioning: ListView.OverlayHeader
            header: PlasmaCore.FrameSvgItem {
                height: 40
                z: 100

                anchors.left: parent.left
                anchors.right: parent.right

                imagePath: "opaque/widgets/panel-background"
                enabledBorders: PlasmaCore.FrameSvgItem.NoBorder


                RowLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    PlasmaComponents.Label {
                        Layout.leftMargin: 12
                        Layout.preferredWidth: 60
                        text: i18n("Protocol")
                    }
                    PlasmaComponents.Label {
                        Layout.preferredWidth: 160
                        text: i18n("Local Address")
                    }
                    PlasmaComponents.Label {
                        Layout.preferredWidth: 160
                        text: i18n("Foreign Address")
                    }
            //        PlasmaComponents.Label {
            //            Layout.preferredWidth: 100
            //            text: model.status
            //        }
                    PlasmaComponents.Label {
                        Layout.preferredWidth: 40
                        text: i18n("PID")
                    }
                    PlasmaComponents.Label {
                        Layout.preferredWidth: 120
                        text: i18n("Program")
                    }
                }
            }
        }
    }
}
