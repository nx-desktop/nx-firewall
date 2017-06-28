import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.kde.kcm 1.0

Item {
    //implicitWidth and implicitHeight will be used as initial size
    //when loaded in kcmshell5
    implicitWidth: units.gridUnit * 20
    implicitHeight: units.gridUnit * 20

    ConfigModule.buttons: ConfigModule.Help | ConfigModule.Apply

//    height: 600
//    width: 800

    property bool isFirewallOn: false
    property string firewallStatusString: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."

    GridLayout {

        columns: 3
        anchors.fill: parent

        Rectangle {
            height: 28
            width: 28
            radius: 28

            color: isFirewallOn ? "lightgreen" : "lightgray"
        }

        PlasmaExtras.Heading {
            level: 3
            Layout.leftMargin: 24
            Layout.fillWidth: true
            text: isFirewallOn ? i18n("Firewall: On") : i18n("Firewall: Off")
            horizontalAlignment: Text.AlignLeft
        }

        PlasmaComponents.Button {
            text: isFirewallOn ? i18n("Turn Off Firewall") : i18n(
                                     "Turn On Firewall")
            onClicked: isFirewallOn = !isFirewallOn
        }

        PlasmaExtras.Heading {
            level: 4
            text: firewallStatusString

            Layout.columnSpan: 3
            Layout.topMargin: 24
            Layout.fillWidth: true

            wrapMode: Text.WordWrap
        }

        TabView {
            Layout.columnSpan: 3
            Layout.topMargin: 32
            Layout.fillHeight: true
            Layout.fillWidth: true

            Tab {
                title: i18n("Simple")
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12

                    PlasmaComponents.CheckBox {
                        text: i18n("Block all incoming connections")

                        Layout.topMargin: 12
                        Layout.preferredHeight: 32
                    }
                    PlasmaExtras.Heading {
                        level: 4
                        text: i18n("Blocks all incoming connections except those required for basic internet services, such as DHCP.")

                        Layout.columnSpan: 3
                        Layout.fillWidth: true

                        wrapMode: Text.WordWrap
                    }

                    PlasmaComponents.CheckBox {
                        text: i18n("Stealt mode")

                        Layout.topMargin: 12
                        Layout.preferredHeight: 32
                    }
                    PlasmaExtras.Heading {
                        level: 4
                        text: i18n("Don't respond to or acknowlegde attempts to access this computerfrom the network by test applications using ICMP, such as Ping.")

                        Layout.columnSpan: 3
                        Layout.fillWidth: true

                        wrapMode: Text.WordWrap
                    }

                    PlasmaComponents.CheckBox {
                        text: i18n("Paranoic mode")

                        Layout.topMargin: 12
                        Layout.preferredHeight: 32
                    }
                    PlasmaExtras.Heading {
                        level: 4
                        text: i18n("Blocks all connections to/from your computer and set the logging level to full.")

                        Layout.columnSpan: 3
                        Layout.fillWidth: true

                        wrapMode: Text.WordWrap
                    }

                    Item {

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }

            Tab {
                title: i18n("Applications")
                ViewAppNetworkAccess {
                    anchors.fill: parent
                    anchors.margins: 12
                }
            }

            Tab {
                title: i18n("Rules")
                ViewRules {
                }
            }
        }
    }
}
