#include "conectionsmodel.h"

#include <QDebug>

#include <KAuth>

ConnectionsModel::ConnectionsModel(QObject *parent)
    : QAbstractListModel(parent), m_queryRunning(false)
{
    refreshConnections();
}

int ConnectionsModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    // FIXME: Implement me!
    return m_connectionsData.size();
}

QVariant ConnectionsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    QVariantList connection = m_connectionsData.at(index.row()).toList();
    return connection.at(role - ProtocolRole);
}

QHash<int, QByteArray> ConnectionsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ProtocolRole] = "protocol";
    roles[LocalAddressRole] = "localAddress";
    roles[ForeignAddressRole] = "foreignAddress";
    roles[StatusRole] = "status";
    roles[PidRole] = "pid";
    roles[ProgramRole] = "program";

    return roles;
}

void ConnectionsModel::refreshConnections()
{
    if (m_queryRunning)
    {
        qWarning() << "Netstat client is bussy";
        return;
    }

    m_queryRunning = true;

    KAuth::Action queryAction(QLatin1String("org.nxos.netstat.query"));
    queryAction.setHelperId("org.nxos.netstat");

    KAuth::ExecuteJob *job = queryAction.execute();
    connect(job, &KAuth::ExecuteJob::finished, [this] (KJob *kjob)
    {
        auto job = qobject_cast<KAuth::ExecuteJob *>(kjob);
        if (!job->error())
        {
            m_connectionsData = job->data().value("connections", QVariantList()).toList();
        } else
            qWarning() << "BACKEND ERROR: " << job->error() << job->errorText();

        m_queryRunning = false;
    });

    job->start();
}

