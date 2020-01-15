#include "netstatclient.h"

/* Access to the Netstat Client thru the Connections Model */
static NetstatClient *_self = nullptr;

NetstatClient* NetstatClient::self() {
    assert(_self);
    return _self;
}

NetstatClient::NetstatClient(QObject *parent)
    : QObject(parent)
    , m_connections(new ConnectionsModel(this))
{
    _self = this;
}

ConnectionsModel *NetstatClient::connections()
{
    return m_connections;
}

void NetstatClient::setStatus(const QString& message)
{
    if (mStatus != message) {
        mStatus = message;
        Q_EMIT statusChanged(mStatus);
    }
}

QString NetstatClient::status() const
{
    return mStatus;
}
