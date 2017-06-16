import QtQuick 2.6
import QtQuick.Controls 1.4

import org.kde.plasma.core 2.0 as PlasmaCore

import org.nomad.ufw 1.0

ApplicationWindow {
    visible: true
    width: 900
    height: 700
    title: i18n("Nomad Firewall")

    id: mainWindow
    UfwClient {
    }
}
