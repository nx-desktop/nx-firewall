#ifndef NETSTATHELPER_H
#define NETSTATHELPER_H

#include <QVariantMap>
#include <KAuth>

using namespace KAuth;
class NetstatHelper : public QObject
{
    Q_OBJECT
public:
    NetstatHelper();

public Q_SLOTS:
    ActionReply query(const QVariantMap);

private:
    QVariantList parseOutput(const QByteArray &netstatOutput);
    QString extractAndStrip(const QString &src,const int &index, const int  &size);
};

#endif // NETSTATHELPER_H
