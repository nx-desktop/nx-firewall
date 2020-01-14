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
    QVariantList parseNetstatOutput(const QByteArray &netstatOutput);
    QVariantList parseSSOutput(const QByteArray &ss);

    QString extractAndStrip(const QString &src,const int &index, const int  &size);

    /* Netstat has been deprecated for more than 20 years,
    * some distros such as arch linux use 'ss' as default.
    */
    int mHasSS;

    /* Distros are not obliged to install this. let's query it before
    * assuming that this actually exists */
    int mHasNetstat;
};

#endif // NETSTATHELPER_H
