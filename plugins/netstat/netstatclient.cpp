#include "netstatclient.h"

NetstatClient::NetstatClient(QObject *parent) : QObject(parent), m_connections(new ConnectionsModel(this))
{
}

ConnectionsModel *NetstatClient::connections()
{
    return m_connections;
}
