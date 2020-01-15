#ifndef NETSTATPLUGIN_H
#define NETSTATPLUGIN_H

#include <QQmlExtensionPlugin>

class NetstatPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

    public:
        virtual void registerTypes(const char *uri) override;
};

#endif // NETSTATPLUGIN_H
