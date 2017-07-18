#include "ufwplugin.h"
#include "ufwclient.h"
#include "rulelistmodel.h"
#include "rulewrapper.h"
#include "loglistmodel.h"

#include <QtQml>

void UfwPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.nomad.ufw"));

    qmlRegisterType<UfwClient>(uri, 1, 0, "UfwClient");
    qmlRegisterType<RuleListModel>(uri, 1, 0, "RuleListModel");
    qmlRegisterType<RuleWrapper>(uri, 1, 0, "Rule");
    qmlRegisterUncreatableType<LogListModel>(uri, 1, 0, "LogListModel", "Only created from the UfwClient.");
}
