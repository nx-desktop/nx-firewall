#include "netstatplugin.h"

#include <QtQml>

#include "netstatclient.h"
#include "conectionsmodel.h"

void NetstatPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.nomad.netstat"));

    qmlRegisterType<NetstatClient>(uri, 1, 0, "NetstatClient");
    qmlRegisterUncreatableType<ConnectionsModel> (uri, 1,9, "ConnectionsModel", "Use the NetstatClient");
}
