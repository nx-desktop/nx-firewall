#include "rulelistmodel.h"

#include <QDebug>

RuleListModel::RuleListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

void RuleListModel::add(int index)
{
    beginInsertRows(QModelIndex(), index, index);
    // TODO
    qDebug() << "Add rule not implemented yet";
    endInsertRows();
}

void RuleListModel::remove(int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    // TODO
    qDebug() << "Remove rule not implemented yet";
    endRemoveRows();
}

void RuleListModel::move(int from, int to)
{
    if(to < 0 && to >= m_rules.count())
        return;

    int newPos = to > from ? to + 1 : to;
    bool validMove = beginMoveRows(QModelIndex(), from, from, QModelIndex(), newPos);
    if (validMove)
    {
        m_rules.move(from, to);
        endMoveRows();
    }
}

void RuleListModel::change(int index)
{
    // TODO
    qDebug() << "Change rule not implemented yet";
    dataChanged(QModelIndex(), createIndex(index, 0));
}

int RuleListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_rules.count();
}

QVariant RuleListModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_rules.count()) {
        return {};
    }

    const UFW::Rule rule = m_rules.at(index.row());

    switch(role) {
        case ActionRole: return rule.actionStr();
        case FromRole: return rule.fromStr();
        case ToRole: return rule.toStr();
        case Ipv6Role: return rule.getV6();
        case LoggingRole: return rule.loggingStr();
    }
    return {};
}

void RuleListModel::setProfile(UFW::Profile profile)
{
    beginResetModel();
    m_profile = profile;
    m_rules = m_profile.getRules();

    endResetModel();
}

QHash<int, QByteArray> RuleListModel::roleNames() const
{
    return {
        {ActionRole, "action"},
        {FromRole, "from"},
        {ToRole, "to"},
        {Ipv6Role, "ipv6"},
        {LoggingRole, "logging"},
    };
}
