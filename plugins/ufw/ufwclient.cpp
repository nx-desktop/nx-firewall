/*
 * Copyright 2018 Alexis Lopes Zubeta <contact@azubieta.net>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "ufwclient.h"

#include <QDebug>
#include <QTimer>
#include <QVariantMap>
#include <QNetworkInterface>

#include <KLocalizedString>


UfwClient::UfwClient(QObject *parent) :
    QObject(parent),
    m_isBusy(false),
    m_rulesModel(new RuleListModel(this)),
    m_logs(new LogListModel(this))
{
    // HACK: Quering the firewall status in this context
    // creates a segmentation fault error in some situations
    // due to an usage of the rootObject before it's
    // initialization. So, it's delayed a little.
    //    refresh();
    QTimer::singleShot(100, this, &UfwClient::refresh);
    QTimer::singleShot(2000, this, &UfwClient::refreshLogs);
}

void UfwClient::refresh()
{
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
    KAuth::Action modifyAction = buildModifyAction(args);

    m_status = enabled ? i18n("Enabling the firewall...") : i18n("Disabling the firewall...");
    m_isBusy = true;


    KAuth::ExecuteJob *job = modifyAction.execute();
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
        qWarning() << "Ufw client is busy";
        return;
    }

    QVariantMap args;
    args["defaults"]=readDefaults;
    args["profiles"]=listProfiles;
    KAuth::Action queryAction = buildQueryAction(args);

    setStatus(i18n("Querying firewall status..."));


    KAuth::ExecuteJob *job = queryAction.execute();
    connect(job, &KAuth::ExecuteJob::result, [this] (KJob *kjob)
    {
        auto job = qobject_cast<KAuth::ExecuteJob *>(kjob);

        if (!job->error())
        {
            QByteArray response = job->data().value("response", "").toByteArray();
            setProfile(UFW::Profile(response));
            setStatus("");
        } else {
            setStatus("There was an error in the backend! Please report it.");
            qWarning() << job->errorString();
        }

        setBusy(false);
    });

    job->start();
}

void UfwClient::setDefaultIncomingPolicy(QString defaultIncomingPolicy)
{
    QVariantMap args;
    args["cmd"]="setDefaults";
    args["xml"]=QString("<defaults incoming=\"")+defaultIncomingPolicy+QString("\" />");
    KAuth::Action modifyAction = buildModifyAction(args);
    m_status = i18n("Setting firewall default incomming policy...");
    m_isBusy = true;

    KAuth::ExecuteJob *job = modifyAction.execute();
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

void UfwClient::setDefaultOutgoingPolicy(QString defaultOutgoingPolicy)
{
    QVariantMap args;
    args["cmd"]="setDefaults";
    args["xml"]=QString("<defaults outgoing=\"")+defaultOutgoingPolicy+QString("\" />");
    KAuth::Action modifyAction = buildModifyAction(args);
    m_status = i18n("Setting firewall default outgoing policy...");
    m_isBusy = true;

    KAuth::ExecuteJob *job = modifyAction.execute();
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

void UfwClient::setLogsAutoRefresh(bool logsAutoRefresh)
{
    if (m_logsAutoRefresh == logsAutoRefresh)
        return;

    if (logsAutoRefresh) {
        connect(&m_logsRefreshTimer, &QTimer::timeout, this, &UfwClient::refreshLogs);
        m_logsRefreshTimer.setInterval(3000);
        m_logsRefreshTimer.start();
    } else {
        disconnect(&m_logsRefreshTimer, &QTimer::timeout, this, &UfwClient::refreshLogs);
        m_logsRefreshTimer.stop();
    }

    m_logsAutoRefresh = logsAutoRefresh;
    emit logsAutoRefreshChanged(m_logsAutoRefresh);
}

void UfwClient::refreshLogs()
{
    KAuth::Action action("org.nomad.ufw.viewlog");
    action.setHelperId("org.nomad.ufw");

    QVariantMap args;
    if (m_rawLogs.size() > 0)
        args["lastLine"] = m_rawLogs.last();

    action.setArguments(args);

    KAuth::ExecuteJob *job = action.execute();
    connect(job, &KAuth::ExecuteJob::finished, [this] (KJob *kjob)
    {
        auto job = qobject_cast<KAuth::ExecuteJob *>(kjob);

        if (!job->error())
        {
            QStringList newLogs = job->data().value("lines", "").toStringList();
            m_rawLogs.append(newLogs);
            m_logs->addRawLogs(newLogs);
        } else
            qWarning() << job->errorString();

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

    if (m_currentProfile.getDefaultIncomingPolicy() != oldProfile.getDefaultIncomingPolicy()) {
        QString policy = UFW::Types::toString(m_currentProfile.getDefaultIncomingPolicy());
        emit defaultIncomingPolicyChanged(policy);
    }

    if (m_currentProfile.getDefaultOutgoingPolicy() != oldProfile.getDefaultOutgoingPolicy()) {
        QString policy = UFW::Types::toString(m_currentProfile.getDefaultOutgoingPolicy());
        emit defaultOutgoingPolicyChanged(policy);
    }
}

KAuth::Action UfwClient::buildQueryAction(const QVariantMap &arguments)
{
    auto action = KAuth::Action("org.nomad.ufw.query");
    action.setHelperId("org.nomad.ufw");
    action.setArguments(arguments);

    return action;
}

KAuth::Action UfwClient::buildModifyAction(const QVariantMap &arguments)
{
    auto action = KAuth::Action("org.nomad.ufw.modify");
    action.setHelperId("org.nomad.ufw");
    action.setArguments(arguments);

    return action;
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

    KAuth::Action modifyAction = buildModifyAction(args);
    setStatus(i18n("Adding rule..."));

    KAuth::ExecuteJob *job = modifyAction.execute();
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

void UfwClient::removeRule(int index)
{
    if (index < 0 || index >= m_currentProfile.getRules().count()) {
        qWarning() << __FUNCTION__ << "invalid rule index";
        return;
    }

    // Correct index
    index ++;

    QVariantMap args;
    args["cmd"]="removeRule";
    args["index"]=QString().setNum(index);
    KAuth::Action modifyAction = buildModifyAction(args);
    setStatus(i18n("Removing rule from firewall..."));

    KAuth::ExecuteJob *job = modifyAction.execute();
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
    KAuth::Action modifyAction = buildModifyAction(args);
    setStatus(i18n("Updating rule..."));

    KAuth::ExecuteJob *job = modifyAction.execute();
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

void UfwClient::moveRule(int from, int to)
{
    QList<UFW::Rule> rules = m_currentProfile.getRules();
    if (from < 0 || from >= rules.count()) {
        qWarning() << __FUNCTION__ << "invalid from index";
        return;
    }

    if (to < 0 || to >= rules.count()) {
        qWarning() << __FUNCTION__ << "invalid to index";
        return;
    }
    // Correct indices
    from ++;
    to ++;

    QVariantMap args;
    args["cmd"]="moveRule";
    args["from"]=from;
    args["to"]=to;
    KAuth::Action modifyAction = buildModifyAction(args);
    setStatus(i18n("Moving rule in firewall..."));

    KAuth::ExecuteJob *job = modifyAction.execute();
    connect(job, &KAuth::ExecuteJob::finished, [this] (KJob *kjob)
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

QString UfwClient::defaultIncomingPolicy() const
{
    auto policy_t = m_currentProfile.getDefaultIncomingPolicy();
    return UFW::Types::toString(policy_t);
}

QString UfwClient::defaultOutgoingPolicy() const
{
    auto policy_t = m_currentProfile.getDefaultOutgoingPolicy();
    return UFW::Types::toString(policy_t);
}

LogListModel *UfwClient::logs()
{
    return m_logs;
}


bool UfwClient::logsAutoRefresh() const
{
    return m_logsAutoRefresh;
}
