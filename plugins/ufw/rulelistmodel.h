#ifndef PROFILEITEMMODEL_H
#define PROFILEITEMMODEL_H

#include <QAbstractListModel>

#include "rulewrapper.h"
#include "profile.h"

class RuleListModel : public QAbstractListModel

{
    Q_OBJECT

public:
    enum ProfileItemModelRoles
    {
        ActionRole = Qt::UserRole + 1,
        FromRole,
        ToRole,
        Ipv6Role,
        LoggingRole
    };

    explicit RuleListModel(QObject *parent = nullptr);

    Q_INVOKABLE void add(int index);
    Q_INVOKABLE void remove(int index);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void change(int index);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    void setProfile(UFW::Profile profile);
protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    UFW::Profile m_profile;
    QList<UFW::Rule> m_rules;
};

#endif // PROFILEITEMMODEL_H
