#ifndef NETSTATCLIENT_H
#define NETSTATCLIENT_H

#include <QObject>

#include "conectionsmodel.h"

class NetstatClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString status READ status WRITE setStatus NOTIFY statusChanged)

public:
    explicit NetstatClient(QObject *parent = nullptr);
    static NetstatClient* self();

    Q_INVOKABLE ConnectionsModel * connections();

    Q_SLOT void setStatus(const QString& message);
    QString status() const;
    Q_SIGNAL void statusChanged(const QString& output);

protected:
    QString mStatus;
    ConnectionsModel * m_connections;
};

#endif // NETSTATCLIENT_H
