import QtQuick 2.0
import QtQuick.Layouts 1.3

import org.kde.plasma.components 2.0 as PlasmaComponents

PlasmaComponents.ListItem {
    RowLayout {
        Layout.fillWidth: true
        PlasmaComponents.Label {
            Layout.leftMargin: 12
            Layout.preferredWidth: 60
            text: model.protocol
        }
        PlasmaComponents.Label {
            Layout.preferredWidth: 160
            text: model.localAddress
        }
        PlasmaComponents.Label {
            Layout.preferredWidth: 160
            text: model.foreignAddress
        }
//        PlasmaComponents.Label {
//            Layout.preferredWidth: 100
//            text: model.status
//        }
        PlasmaComponents.Label {
            Layout.preferredWidth: 40
            text: model.pid
        }
        PlasmaComponents.Label {
            Layout.preferredWidth: 120
            text: model.program
        }
    }
}
