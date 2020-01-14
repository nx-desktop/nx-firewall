#ifndef UFW_TYPES_H
#define UFW_TYPES_H

/*
 * UFW KControl Module
 *
 * Copyright 2011 Craig Drummond <craig.p.drummond@gmail.com>
 *
 * ----
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include <QtCore/QString>
#include <QtCore/QVariant>

namespace UFW
{

namespace Types
{

enum LogLevel
{
    LOG_OFF,
    LOG_LOW,
    LOG_MEDIUM,
    LOG_HIGH,
    LOG_FULL,

    LOG_COUNT
};

enum Logging
{
    LOGGING_OFF,
    LOGGING_NEW,
    LOGGING_ALL,

    LOGGING_COUNT
};

enum Policy
{
    POLICY_ALLOW,
    POLICY_DENY,
    POLICY_REJECT,
    POLICY_LIMIT,

    POLICY_COUNT,
    POLICY_COUNT_DEFAULT=POLICY_COUNT-1 // No 'Limit' for defaults...
};

enum PredefinedPort
{
    PP_AMULE,
    PP_DELUGE,
    PP_KTORRENT,
    PP_NICOTINE,
    PP_QBITTORRNET,
    PP_TRANSMISSION,
    PP_IM_ICQ,
    PP_IM_JABBER,
    PP_IM_WLM,
    PP_IM_YAHOO,

    PP_FTP,
    PP_HTTP,
    PP_HTTPS,
    PP_IMAP,
    PP_IMAPS,
    PP_POP3,
    PP_POP3S,
    PP_SMTP,
    PP_NFS,
    PP_SAMBA,
    PP_SSH,
    PP_VNC,
    PP_ZEROCONF,
    PP_TELNET,
    PP_NTP,
    PP_CUPS,

    PP_COUNT
};

enum Protocol
{
    PROTO_BOTH,
    PROTO_TCP,
    PROTO_UDP,

    PROTO_COUNT
};

extern QString        toString(LogLevel level, bool ui=false);
extern LogLevel       toLogLevel(const QString &str);
extern QString        toString(Logging log, bool ui=false);
extern Logging        toLogging(const QString &str);
extern QString        toString(Policy policy, bool ui=false);
extern Policy         toPolicy(const QString &str);
extern QString        toString(PredefinedPort pp, bool ui=false);
extern PredefinedPort toPredefinedPort(const QString &str);
extern QString        toString(Protocol proto, bool ui=false);
extern Protocol       toProtocol(const QString &str);

}

}

#endif
