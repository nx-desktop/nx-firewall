#ifndef UFW_PROFILE_H
#define UFW_PROFILE_H

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

#include <QtCore/QByteArray>
#include <QtCore/QList>
#include <QtCore/QSet>
#include "rule.h"
#include "types.h"

class QFile;
class QDomDocument;

namespace UFW
{

class Profile
{
    public:

    enum Fields
    {
        FIELD_RULES    = 0x01,
        FIELD_DEFAULTS = 0x02,
        FIELD_MODULES  = 0x04,
        FIELD_STATUS   = 0x08
    };

    Profile()
        : fields(0), enabled(false), ipv6Enabled(false)
    {
    }
    Profile(const QByteArray &xml, bool isSys=false);
    Profile(QFile &file, bool isSys=false);
    Profile(bool ipv6, Types::LogLevel ll, Types::Policy dip, Types::Policy dop, const QList<Rule> &r, const QSet<QString> &m)
        : fields(0xFF), enabled(true), ipv6Enabled(ipv6), logLevel(ll), defaultIncomingPolicy(dip), defaultOutgoingPolicy(dop)
        , rules(r), modules(m), isSystem(false)
    {
    }

    bool operator==(const Profile &o) const
    {
        return ipv6Enabled==o.ipv6Enabled &&
               logLevel==o.logLevel &&
               defaultIncomingPolicy==o.defaultIncomingPolicy &&
               defaultOutgoingPolicy==o.defaultOutgoingPolicy &&
               rules==o.rules &&
               modules==o.modules;
    }

    QString               toXml() const;
    QString               defaultsXml() const;
    QString               modulesXml() const;

    bool                  hasRules() const                 { return fields&FIELD_RULES; }
    bool                  hasDefaults() const              { return fields&FIELD_DEFAULTS; }
    bool                  hasModules() const               { return fields&FIELD_MODULES; }
    bool                  hasStatus() const                { return fields&FIELD_STATUS; }

    int                   getFields() const                { return fields; }
    bool                  getEnabled() const               { return enabled; }
    bool                  getIpv6Enabled() const           { return ipv6Enabled; }
    Types::LogLevel       getLogLevel() const              { return logLevel; }
    Types::Policy         getDefaultIncomingPolicy() const { return defaultIncomingPolicy; }
    Types::Policy         getDefaultOutgoingPolicy() const { return defaultOutgoingPolicy; }
    const QList<Rule> &   getRules() const                 { return rules; }
    const QSet<QString> & getModules() const               { return modules; }
    const QString &       getFileName() const              { return fileName; }
    bool                  getIsSystem() const              { return isSystem; }

    private:

    void load(const QDomDocument &doc);

    private:

    int             fields;
    bool            enabled,
                    ipv6Enabled;
    Types::LogLevel logLevel;
    Types::Policy   defaultIncomingPolicy,
                    defaultOutgoingPolicy;
    QList<Rule>     rules;
    QSet<QString>   modules;
    QString         fileName;
    bool            isSystem;

};

}

#endif
