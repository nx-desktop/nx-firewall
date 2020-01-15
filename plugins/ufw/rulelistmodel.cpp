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
    if (index.row() < 0 || index.row() >= m_rules.count())
        return QVariant();

    const UFW::Rule rule = m_rules.at(index.row());

    if (role == ActionRole)
        return rule.actionStr();
    else if (role == FromRole)
        return rule.fromStr();
    else if (role == ToRole)
        return rule.toStr();
    else if (role == Ipv6Role)
        return rule.getV6();
    else if (role == LoggingRole)
        return rule.loggingStr();

    return QVariant();
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
    QHash<int, QByteArray> roles;
    roles[ActionRole] = "action";
    roles[FromRole] = "from";
    roles[ToRole] = "to";
    roles[Ipv6Role] = "ipv6";
    roles[LoggingRole] = "logging";

    return roles;
}
