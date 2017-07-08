#include "netstatplugin.h"

#include <QtQml>

void NetstatPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.nomad.netstat"));

//    qmlRegisterType<UfwClient>(uri, 1, 0, "UfwClient");
}
