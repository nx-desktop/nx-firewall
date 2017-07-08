#ifndef NETSTATHELPER_H
#define NETSTATHELPER_H

#include <QVariantMap>
#include <KAuth>

class NetstatHelper : public QObject
{
    Q_OBJECT
public:
    NetstatHelper();

public Q_SLOTS:
    KAuth::ActionReply queryActiveConnections(const QVariantMap &args);

protected:

};

#endif // NETSTATHELPER_H
