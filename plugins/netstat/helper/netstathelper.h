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
    QVariantList parseOutput(const QByteArray &netstatOutput);
    QString extractAndStrip(const QString &src,const int &index, const int  &size);
};

#endif // NETSTATHELPER_H
