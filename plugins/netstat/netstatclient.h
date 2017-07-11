#ifndef NETSTATCLIENT_H
#define NETSTATCLIENT_H

#include <QObject>

#include "conectionsmodel.h"

class NetstatClient : public QObject
{
    Q_OBJECT

public:
    explicit NetstatClient(QObject *parent = nullptr);

    Q_INVOKABLE ConnectionsModel * connections();
signals:

public slots:

protected:
    ConnectionsModel * m_connections;
};

#endif // NETSTATCLIENT_H
