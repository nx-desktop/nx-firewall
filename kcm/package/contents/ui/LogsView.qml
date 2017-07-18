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
            delegate: LogItemDelegate {
                id: itemRoot
                width: root.width - 10
            }

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: sectionHeading

            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
            }
        }
    }
}
