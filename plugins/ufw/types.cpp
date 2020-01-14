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

#include "types.h"
#include <KDE/KLocale>
#include <QtCore/QVariantMap>

namespace UFW
{

namespace Types
{

QString toString(LogLevel level, bool ui)
{
    switch(level)
    {
        case LOG_OFF:    return ui ? i18n("Off")    : "off";
        default:
        case LOG_LOW:    return ui ? i18n("Low")    : "low";
        case LOG_MEDIUM: return ui ? i18n("Medium") : "medium";
        case LOG_HIGH:   return ui ? i18n("High")   : "high";
        case LOG_FULL:   return ui ? i18n("Full")   : "full";
    }
}

LogLevel toLogLevel(const QString &str)
{
    for(int i=0; i<LOG_COUNT; ++i)
        if(toString((LogLevel)i)==str)
            return (LogLevel)i;
    return LOG_LOW;
}

extern QString toString(Logging log, bool ui)
{
    switch(log)
    {
        default:
        case LOGGING_OFF: return ui ? i18n("None")            : QString();
        case LOGGING_NEW: return ui ? i18n("New connections") : "log";
        case LOGGING_ALL: return ui ? i18n("All packets")     : "log-all";
    }
}

QString toString(Policy policy, bool ui)
{
    switch(policy)
    {
        default:
        case POLICY_ALLOW:  return ui ? i18n("Allow")  : "allow";
        case POLICY_DENY:   return ui ? i18n("Deny")   : "deny";
        case POLICY_REJECT: return ui ? i18n("Reject") : "reject";
        case POLICY_LIMIT:  return ui ? i18n("Limit")  : "limit";
    }
}

Policy toPolicy(const QString &str)
{
    for(int i=0; i<POLICY_COUNT; ++i)
        if(toString((Policy)i)==str)
            return (Policy)i;
    return POLICY_ALLOW;
}

QString toString(PredefinedPort pp, bool ui)
{
    switch(pp)
    {
        case PP_AMULE:        return ui ? i18n("Amule")                  : "4662/tcp 4672/udp";
        case PP_DELUGE:       return ui ? i18n("Deluge")                 : "6881:6891/tcp";
        case PP_KTORRENT:     return ui ? i18n("KTorrent")               : "6881/tcp 4444/udp";
        case PP_NICOTINE:     return ui ? i18n("Nicotine")               : "2234:2239/tcp 2242/tcp";
        case PP_QBITTORRNET:  return ui ? i18n("qBittorrent")            : "6881/tcp";
        case PP_TRANSMISSION: return ui ? i18n("Transmission")           : "51413";
        case PP_IM_ICQ:       return ui ? i18n("ICQ")                    : "5190";
        case PP_IM_JABBER:    return ui ? i18n("Jabber")                 : "5222";
        case PP_IM_WLM:       return ui ? i18n("Windows Live Messenger") : "1863";
        case PP_IM_YAHOO:     return ui ? i18n("Yahoo! Messenger")       : "5050";
        case PP_FTP:          return ui ? i18n("FTP")                    : "21";
        case PP_HTTP:         return ui ? i18n("HTTP")                   : "80";
        case PP_HTTPS:        return ui ? i18n("Secure HTTP")            : "443";
        case PP_IMAP:         return ui ? i18n("IMAP")                   : "143";
        case PP_IMAPS:        return ui ? i18n("Secure IMAP")            : "993";
        case PP_POP3:         return ui ? i18n("POP3")                   : "110";
        case PP_POP3S:        return ui ? i18n("Secure POP3")            : "995";
        case PP_SMTP:         return ui ? i18n("SMTP")                   : "25";
        case PP_NFS:          return ui ? i18n("NFS")                    : "2049";
        case PP_SAMBA:        return ui ? i18n("Samba")                  : "135,139,445/tcp 137,138/udp";
        case PP_SSH:          return ui ? i18n("Secure Shell")           : "22";
        case PP_VNC:          return ui ? i18n("VNC")                    : "5900/tcp";
        case PP_ZEROCONF:     return ui ? i18n("Zeroconf")               : "5353/udp";
        case PP_TELNET:       return ui ? i18n("Telnet")                 : "23";
        case PP_NTP:          return ui ? i18n("NTP")                    : "123";
        case PP_CUPS:         return ui ? i18n("CUPS")                   : "631";
        default:              return QString();
    }
}

PredefinedPort toPredefinedPort(const QString &str)
{
    for(int i=0; i<Types::PP_COUNT; ++i)
    {
        QStringList                ports=Types::toString((Types::PredefinedPort)i).split(" ");
        QStringList::ConstIterator it(ports.constBegin()),
                                   end(ports.constEnd());

        for(; it!=end; ++it)
            if((*it)==str)
                return (Types::PredefinedPort)i;
    }

    return PP_COUNT;
}

QString toString(Protocol proto, bool ui)
{
    switch(proto)
    {
        case PROTO_TCP:  return ui ? i18n("TCP")          : "tcp";
        case PROTO_UDP:  return ui ? i18n("UDP")          : "udp";
        case PROTO_BOTH: return ui ? i18n("Any protocol") : QString();
        default:         return QString();
    }
}

Protocol toProtocol(const QString &str)
{
    for(int i=0; i<PROTO_COUNT; ++i)
        if(toString((Protocol)i)==str)
            return (Protocol)i;
    return PROTO_BOTH;
}

Logging toLogging(const QString &str)
{
    for(int i=0; i<LOGGING_COUNT; ++i)
        if(toString((Logging)i)==str)
            return (Logging)i;
    return LOGGING_OFF;
}

}

}
