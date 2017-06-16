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

#include <QDomDocument>
#include <QDomElement>
#include <QDomNode>
#include <QDomText>
#include <QFile>
#include <QStringList>
#include <QTextStream>

#include "profile.h"

namespace UFW
{

Profile::Profile(const QByteArray &xml, bool isSys)
       : fields(0)
       , enabled(false)
       , ipv6Enabled(false)
       , logLevel(Types::LOG_OFF)
       , defaultIncomingPolicy(Types::POLICY_ALLOW)
       , defaultOutgoingPolicy(Types::POLICY_ALLOW)
       , isSystem(isSys)
{
    QDomDocument doc;
    doc.setContent(xml);
    load(doc);
}

Profile::Profile(QFile &file, bool isSys)
       : fields(0)
       , enabled(false)
       , ipv6Enabled(false)
       , logLevel(Types::LOG_OFF)
       , defaultIncomingPolicy(Types::POLICY_ALLOW)
       , defaultOutgoingPolicy(Types::POLICY_ALLOW)
       , fileName(file.fileName())
       , isSystem(isSys)
{
    QDomDocument doc;

    if(file.open(QIODevice::ReadOnly))
    {
        doc.setContent(&file);
        load(doc);
    }
}

QString Profile::toXml() const
{
    QString                    str;
    QTextStream                stream(&str);
    QList<Rule>::ConstIterator it(rules.constBegin()),
                               end(rules.constEnd());

    stream << "<ufw full=\"true\" >" << endl
           << ' ' << defaultsXml() << endl
            << " <rules>" << endl;
    for(; it!=end; ++it)
        stream << "  " << (*it).toXml();
    stream << " </rules>" << endl
            << ' ' << modulesXml() << endl
            << "</ufw>" << endl;

    return str;
}

QString Profile::defaultsXml() const
{
    return QString("<defaults ipv6=\"")+QString(ipv6Enabled ? "yes" : "no")+QChar('\"')+
           QString(" loglevel=\"")+Types::toString(logLevel)+QChar('\"')+
           QString(" incoming=\"")+Types::toString(defaultIncomingPolicy)+QChar('\"')+
           QString(" outgoing=\"")+Types::toString(defaultOutgoingPolicy)+QString("\"/>");
}

QString Profile::modulesXml() const
{
    return QString("<modules enabled=\"")+QStringList(modules.toList()).join(" ")+QString("\" />");
}

void Profile::load(const QDomDocument &doc)
{
    QDomNode ufw=doc.namedItem("ufw");

    if(!ufw.isNull())
    {
        QDomElement elem=ufw.toElement();
        bool        isFull=elem.attribute("full")=="true";

        QDomNode status=ufw.namedItem("status");
        if(!status.isNull())
        {
            QDomElement elem=status.toElement();
            enabled=elem.attribute("enabled")=="true";
            fields|=FIELD_STATUS;
        }

        QDomNode rulesNode=ufw.namedItem("rules"),
                 defaultsNode=ufw.namedItem("defaults"),
                 modulesNode=ufw.namedItem("modules");

        if(!rulesNode.isNull())
        {
            QDomNodeList nodes=rulesNode.childNodes();

            fields|=FIELD_RULES;
            if(nodes.count()>0)
            {
                for(int i=0; i<nodes.count(); ++i)
                {
                    QDomElement rule=nodes.at(i).toElement();

                    if(!rule.isNull() && "rule"==rule.tagName())
                        rules.append(Rule(rule));
                }
            }
        }

        if(!defaultsNode.isNull())
        {
            QDomElement elem=defaultsNode.toElement();
            fields|=FIELD_DEFAULTS;
            if(!elem.isNull())
            {
                QString val=elem.attribute("loglevel");
                if(!val.isEmpty())
                    for(int i=Types::LOG_LOW; i<Types::LOG_COUNT; ++i)
                        if(val==toString((Types::LogLevel)i))
                        {
                            logLevel=(Types::LogLevel)i;
                            break;
                        }

                val=elem.attribute("incoming");
                if(!val.isEmpty())
                    for(int i=Types::POLICY_ALLOW; i<Types::POLICY_COUNT_DEFAULT; ++i)
                        if(val==toString((Types::Policy)i))
                        {
                            defaultIncomingPolicy=(Types::Policy)i;
                            break;
                        }

                val=elem.attribute("outgoing");
                if(!val.isEmpty())
                    for(int i=Types::POLICY_ALLOW; i<Types::POLICY_COUNT_DEFAULT; ++i)
                        if(val==toString((Types::Policy)i))
                        {
                            defaultOutgoingPolicy=(Types::Policy)i;
                            break;
                        }
                ipv6Enabled=elem.attribute("ipv6")=="yes";
            }
        }

        if(!modulesNode.isNull())
        {
            fields|=FIELD_MODULES;
            modules=modulesNode.toElement().attribute("enabled").split(" ", QString::SkipEmptyParts).toSet();
        }

        // If this is a 'full' profile - then we expect rules/defaults/modules
        if(isFull && ( !(fields&FIELD_RULES) || !(fields&FIELD_DEFAULTS) || !(fields&FIELD_MODULES) ) )
            fields=0;
    }
}

}
