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

#include "loglistmodel.h"

#include <QDebug>
#include <QDateTime>
#include <QRegularExpression>

LogListModel::LogListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int LogListModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_logsData.size();
}

QVariant LogListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (index.row() >= 0 && index.row() < m_logsData.size()) {
        QVariantList logData = m_logsData[index.row()].toList();

        int valueIndex = role - (Qt::UserRole + 1);
        if (valueIndex >= logData.size())
            return QString();
        else
            return logData.value(valueIndex);
    }

    return QVariant();
}

void LogListModel::addRawLogs(QStringList rawLogsList)
{
    beginInsertRows(QModelIndex(), 0, rawLogsList.size() - 1);
    // UNSCAPED REGEX: (.*)\s(.*)\s(.*):\s\[(.*)\]\s\[(.*)\].*IN=([\w|\d]*).*SRC=([\w|\.|\d]*).*DST=([\w|\.|\d]*).*PROTO=([\w|\.|\d]*)\s(SPT=(\d*)\sDPT=(\d*))?.*
    static QRegularExpression regex(
        "(.*)\\s(.*)\\s(.*):\\s\\[(.*)\\]\\s\\[(.*)\\]"
        ".*IN=([\\w|\\d]*)"
        ".*SRC=([\\w|\\.|\\d]*)"
        ".*DST=([\\w|\\.|\\d]*)"
        ".*PROTO=([\\w|\\.|\\d]*)"
        "\\s(SPT=(\\d*)\\sDPT=(\\d*))?.*");

    for (QString log : rawLogsList) {

        auto match = regex.match(log);
        if (match.hasMatch()) {
            QDateTime date = QDateTime::fromString(match.captured(1), "MMM d HH:mm:ss");
            QString host = match.captured(2);
            QString id = match.captured(4);
            QString action = match.captured(5);
            QString interface = match.captured(6);
            QString sourceAddress = match.captured(7);
            QString destinationAddress = match.captured(8);
            QString protocol = match.captured(9);
            QString sourcePort = match.captured(11);
            QString destinationPort = match.captured(12);

//            qDebug() << "host" << host;
//            qDebug() << "id" << id;
//            qDebug() << "action" << action;
//            qDebug() << "interface" << interface;
//            qDebug() << "sourceAddress" << sourceAddress;
//            qDebug() << "destinationAddress" << destinationAddress;
//            qDebug() << "protocol" << protocol;
//            qDebug() << "sourcePort" << sourcePort;
//            qDebug() << "destinationPort" << destinationPort;
            QVariantList logDetails;

            logDetails << sourceAddress << sourcePort;
            logDetails << destinationAddress << destinationPort;
            logDetails << protocol << interface;
            logDetails << action << date.toString("HH:mm:ss") << date.toString("MMM dd");

            m_logsData.push_front((QVariant) logDetails);
        }
    }
    endInsertRows();
}

QHash<int, QByteArray> LogListModel::roleNames() const
{
    return {
        {SourceAddressRole, "sourceAddress"},
        {SourcePortRole, "sourcePort"},
        {DestinationAddressRole, "destinationAddress"},
        {DestinationPortRole, "destinationPort"},
        {ProtocolRole, "protocol"},
        {InterfaceRole, "interface"},
        {ActionRole, "action"},
        {TimeRole, "time"},
        {DateRole, "date"},
    };
}
