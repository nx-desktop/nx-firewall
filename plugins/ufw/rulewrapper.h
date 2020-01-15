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

#ifndef RULEWRAPPER_H
#define RULEWRAPPER_H

#include <QObject>

#include "rule.h"
#include "types.h"

class RuleWrapper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString policy READ policy WRITE setPolicy NOTIFY policyChanged)
    Q_PROPERTY(bool incoming READ incoming WRITE setIncoming NOTIFY incomingChanged)
    Q_PROPERTY(QString sourceAddress READ sourceAddress WRITE setSourceAddress NOTIFY sourceAddressChanged)
    Q_PROPERTY(QString sourcePort READ sourcePort WRITE setSourcePort NOTIFY sourcePortChanged)
    Q_PROPERTY(QString destinationAddress READ destinationAddress WRITE setDestinationAddress NOTIFY destinationAddressChanged)
    Q_PROPERTY(QString destinationPort READ destinationPort WRITE setDestinationPort NOTIFY destinationPortChanged)
    Q_PROPERTY(int protocol READ protocol WRITE setProtocol NOTIFY protocolChanged)
    Q_PROPERTY(int interface READ interface WRITE setInterface NOTIFY interfaceChanged)
    Q_PROPERTY(QString logging READ logging WRITE setLogging NOTIFY loggingChanged)
    Q_PROPERTY(int position READ position WRITE setPosition NOTIFY positionChanged)
public:
    explicit RuleWrapper(QObject *parent = nullptr);
    explicit RuleWrapper(UFW::Rule rule, QObject *parent = nullptr);

    QString policy() const;
    bool incoming() const;
    QString sourceAddress() const;
    QString sourcePort() const;
    QString destinationAddress() const;
    QString destinationPort() const;
    int protocol() const;
    int interface() const;
    QString logging() const;

    UFW::Rule getRule();
    int position() const;

signals:
    void policyChanged(QString policy);
    void directionChanged(QString direction);
    void sourceAddressChanged(QString sourceAddress);
    void sourcePortChanged(QString sourcePort);
    void destinationAddressChanged(QString destinationAddress);
    void destinationPortChanged(QString destinationPort);
    void protocolChanged(int protocol);
    void interfaceChanged(int interface);
    void loggingChanged(QString logging);
    void incomingChanged(bool incoming);

    void positionChanged(int position);

public slots:
    void setPolicy(QString policy);
    void setIncoming(bool incoming);
    void setSourceAddress(QString sourceAddress);
    void setSourcePort(QString sourcePort);
    void setDestinationAddress(QString destinationAddress);
    void setDestinationPort(QString destinationPort);
    void setProtocol(int protocol);
    void setInterface(int interface);
    void setLogging(QString logging);

    void setPosition(int position);

private:
    UFW::Rule m_rule;
    int m_interface;
};

#endif // RULEWRAPPER_H
