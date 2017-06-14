#include "ufwplugin.h"
#include "ufwclient.h"

#include <QtQml>

void UfwPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.nomad.ufw"));

    qmlRegisterType<UfwClient>(uri, 1, 0, "UfwClient");
}
