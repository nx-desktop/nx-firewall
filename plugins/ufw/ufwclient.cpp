#include "ufwclient.h"

#include <QDebug>
#include <QVariantMap>
#include <QNetworkInterface>

#include <KLocalizedString>


UfwClient::UfwClient(QObject *parent) :
    QObject(parent),
    m_isBusy(false),
    m_rulesModel( new RuleListModel(this))
{
    setupActions();
    queryStatus();
}

bool UfwClient::enabled() const
{
    return m_currentProfile.getEnabled();
}

void UfwClient::setEnabled(const bool &enabled)
{
    QVariantMap args;
    args["cmd"]="setStatus";
    args["status"] = enabled;
    m_modifyAction.setArguments(args);
    m_status = enabled ? i18n("Enabling the firewall...") : i18n("Disabling the firewall...");
    m_isBusy = true;


    KAuth::ExecuteJob *job = m_modifyAction.execute();
    connect(job, &KAuth::ExecuteJob::result, [this] (KJob *kjob)
    {
        auto job = qobject_cast<KAuth::ExecuteJob *>(kjob);

        setStatus("");
        setBusy(false);

        if (!job->error())
            queryStatus(true, false);


    });

    job->start();
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
    connect(job, &KAuth::ExecuteJob::result, [this] (KJob *kjob)
    {
        auto job = qobject_cast<KAuth::ExecuteJob *>(kjob);

        if (!job->error())
        {
            QByteArray response = job->data().value("response", "").toByteArray();
            setProfile(UFW::Profile(response));
        } else
            qWarning() << job->errorString();

        setStatus("");
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

void UfwClient::setProfile(UFW::Profile profile)
{
    auto oldProfile = m_currentProfile;
    m_currentProfile = profile;

    m_rulesModel->setProfile(m_currentProfile);
    if (m_currentProfile.getEnabled() != oldProfile.getEnabled())
        emit enabledChanged(m_currentProfile.getEnabled());
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

RuleListModel *UfwClient::rules() const
{
    return m_rulesModel;
}

RuleWrapper *UfwClient::getRule(int index)
{
    auto rules = m_currentProfile.getRules();

    if (index < 0 || index >= rules.count()) {
        return NULL;
    }

    auto rule = rules.at(index);
    rule.setPosition(index);
    RuleWrapper * wrapper = new RuleWrapper(rule, this);

    return wrapper;
}

void UfwClient::addRule(RuleWrapper *ruleWrapper)
{
    if (ruleWrapper == NULL) {
        qWarning() << __FUNCTION__ << "NULL rule";
        return;
    }

    UFW::Rule rule = ruleWrapper->getRule();

    QVariantMap args;
    args["cmd"]="addRules";
    args["count"]=1;
    args["xml"+QString().setNum(0)]=rule.toXml();

    m_modifyAction.setArguments(args);
    setStatus(i18n("Adding rule..."));

    KAuth::ExecuteJob *job = m_modifyAction.execute();
    connect(job, &KAuth::ExecuteJob::result, [this] (KJob *kjob)
    {
        auto job = qobject_cast<KAuth::ExecuteJob *>(kjob);

        if (!job->error())
        {
            QByteArray response = job->data().value("response", "").toByteArray();
            setProfile(UFW::Profile(response));
        } else
            qWarning() << job->errorString();

        setStatus("");
        setBusy(false);
    });

    job->start();
}

void UfwClient::updateRule(RuleWrapper *ruleWrapper)
{
    if (ruleWrapper == NULL) {
        qWarning() << __FUNCTION__ << "NULL rule";
        return;
    }

    UFW::Rule rule = ruleWrapper->getRule();

    rule.setPosition(rule.getPosition() + 1);
    QVariantMap args;
    args["cmd"]="editRule";
    args["xml"]=rule.toXml();
    m_modifyAction.setArguments(args);
    setStatus(i18n("Updating rule..."));

    KAuth::ExecuteJob *job = m_modifyAction.execute();
    connect(job, &KAuth::ExecuteJob::result, [this] (KJob *kjob)
    {
        auto job = qobject_cast<KAuth::ExecuteJob *>(kjob);

        if (!job->error())
        {
            QByteArray response = job->data().value("response", "").toByteArray();
            setProfile(UFW::Profile(response));
        } else
            qWarning() << job->errorString();

        setStatus("");
        setBusy(false);
    });

    job->start();
}

QStringList UfwClient::getKnownProtocols()
{
    return QStringList() << i18n("Any") << "TCP" << "UDP";
}

QStringList UfwClient::getKnownInterfaces()
{
    QStringList interfaces_names;
    interfaces_names << i18n("Any");

    QList<QNetworkInterface> interfaces = QNetworkInterface::allInterfaces();
    for (QNetworkInterface iface : interfaces)
        interfaces_names << iface.name();

    return interfaces_names;
}
