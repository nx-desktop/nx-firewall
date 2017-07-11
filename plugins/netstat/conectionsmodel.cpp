#include "conectionsmodel.h"

#include <QDebug>

#include <KAuth>

ConnectionsModel::ConnectionsModel(QObject *parent)
    : QAbstractListModel(parent), m_queryRunning(false)
{
    connect(&timer, &QTimer::timeout, this, &ConnectionsModel::refreshConnections);
    timer.setInterval(30000);
    timer.start();

    refreshConnections();
}

int ConnectionsModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_connectionsData.size();
}

QVariant ConnectionsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (index.row() < 0 || index.row() >= m_connectionsData.size())
        return QVariant();

    QVariantList connection = m_connectionsData.at(index.row()).toList();

    int value_index = role - ProtocolRole;
    if (value_index < 0 || value_index >= connection.size())
        return QVariant();

    return connection.at(value_index);
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
            beginResetModel();
            m_connectionsData = job->data().value("connections", QVariantList()).toList();

//            qDebug() << m_connectionsData;

            endResetModel();
        } else
            qWarning() << "BACKEND ERROR: " << job->error() << job->errorText();

        m_queryRunning = false;
    });

    job->start();
}

