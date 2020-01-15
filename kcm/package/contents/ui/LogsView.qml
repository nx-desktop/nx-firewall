
/*
 * Copyright 2018 Alexis Lopes Zubeta <contact@azubieta.net>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
