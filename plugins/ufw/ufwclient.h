#ifndef UFWCLIENT_H
#define UFWCLIENT_H

#include <QObject>
#include <QString>

#include <KAuth>

#include "profile.h"

class UfwClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool isBusy READ isBusy NOTIFY isBusyChanged)
    Q_PROPERTY(QString status READ status NOTIFY statusChanged)
public:
    explicit UfwClient(QObject *parent = nullptr);

    bool enabled() const;
    void setEnabled(const bool &enabled);

    bool isBusy() const;
    void setupActions();
    QString status() const;
signals:
    void isBusyChanged(const bool isBusy);
    void enabledChanged(const bool enabled);
    void statusChanged(const QString &status);

public slots:
    void queryStatus(bool readDefaults=true, bool listProfiles=true);


protected:
    void setStatus(const QString &status);
    void setBusy(const bool &busy);
private:
    QString m_status;
    KAuth::Action       m_queryAction,
                        m_modifyAction;
    bool                m_isBusy;
    UFW::Profile        m_currentProfile;
//    UFW::Blocker       *blocker;
};

#endif // UFWCLIENT_H
