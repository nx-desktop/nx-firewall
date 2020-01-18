
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
import QtQuick.Controls 1.4


import QtQuick.Controls 2.12 as QQC2

import org.kde.kirigami 2.4 as Kirigami


import org.nomad.ufw 1.0 as UFW

ColumnLayout {
    spacing: 12

    // First two buttons.
    GlobalRules {
    }

    // Dynamic Rules
    QQC2.ScrollView {
        id: listScrollArea
        Layout.fillWidth: true
        Layout.fillHeight: true

        ListView {
            id: listView
            model: ufwClient.rules()
            bottomMargin: 48 * 2
            delegate: RuleListItem {
                dropAreasVisible: true
                width: listView.width
                onMove: function (from, to) {
                    //                    print("moving ", from, " to ", to)
                    if (from < to)
                        to = to - 1

                    // Force valid positions
                    to = Math.max(0, to)
                    to = Math.min(listView.model.rowCount(), to)

                    if (from !== to) {
                        //                        listView.model.move(from, to)
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
        }
    }

    QQC2.ToolButton {
        height: 48
        icon.name: "list-add"
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
    }
}
