#ifndef UFWPLUGIN_H
#define UFWPLUGIN_H

#include <QQmlEngine>
#include <QQmlExtensionPlugin>

class UfwPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

    public:
        virtual void registerTypes(const char *uri);
};

#endif // UFWPLUGIN_H
