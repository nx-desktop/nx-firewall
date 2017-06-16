#include "ufwclient.h"

#include <QDebug>
#include <QVariantMap>

#include <KLocalizedString>

UfwClient::UfwClient(QObject *parent) :
    QObject(parent),
    m_isBusy(false)
{
    setupActions();
}

bool UfwClient::isActive() const
{

    return true;
}

bool UfwClient::isBusy() const
{
    return m_isBusy;
}

void UfwClient::queryStatus(bool readDefaults, bool listProfiles)
{
    if (isBusy())
    {
        qWarning() << "Ufw client is bussy";
        return;
    }

    QVariantMap args;
    args["defaults"]=readDefaults;
    args["profiles"]=listProfiles;
    m_queryAction.setArguments(args);
    setStatus(i18n("Querying firewall status..."));

    KAuth::ExecuteJob *job = m_queryAction.execute();
    connect(job, &KAuth::ExecuteJob::result, [this] (KJob *kjob)  {
        auto job = qobject_cast<KAuth::ExecuteJob *>(kjob);
        qDebug() << job->error() << job->errorString() << job->data() ;

        setBusy(false);
    });
    job->start();
}

void UfwClient::setStatus(const QString &status)
{
    m_status = status;
    emit statusChanged(m_status);
}

void UfwClient::setBusy(const bool &isBusy)
{
    if (m_isBusy != isBusy)
    {
        m_isBusy = isBusy;
        emit isBusyChanged(isBusy);
    }
}


void UfwClient::setupActions()
{
    m_queryAction=KAuth::Action("org.nomad.ufw.query");
    m_modifyAction=KAuth::Action("org.nomad.ufw.modify");
    m_queryAction.setHelperId("org.nomad.ufw");
    m_modifyAction.setHelperId("org.nomad.ufw");
}

QString UfwClient::status() const
{
    return m_status;
}
