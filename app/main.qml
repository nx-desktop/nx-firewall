import QtQuick 2.6
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.nomad.ufw 1.0

ApplicationWindow {
    visible: true
    width: 900
    height: 700
    title: i18n("Nomad Firewall")

    id: mainWindow
    UfwClient {
        id: ufwClient
    }

    ColumnLayout {
        id: globalControls

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.margins: 12
        anchors.leftMargin: 18

        RowLayout {
            Rectangle {
                height: 28
                width: 28
                radius: 14
                color: ufwClient.enabled ? "lightgreen" : "lightgray"
            }

            PlasmaExtras.Heading {
                level: 3
                Layout.leftMargin: 12
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                text: ufwClient.enabled ? i18n("Firewall enabled") : i18n(
                                              "Firewall disabled")
            }

            PlasmaComponents.Button {
                text: ufwClient.enabled ? i18n("Disable") : i18n("Enable")
                onClicked: ufwClient.enabled = !ufwClient.enabled
            }
        }
    }


    Rectangle {
        anchors.top: globalControls.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.margins: 12
        color: "white"

        RulesView {
            anchors.fill: parent
            model: ufwClient.rules()
        }
    }

    statusBar: PlasmaComponents.Label {
        text: ufwClient.status
    }
}
